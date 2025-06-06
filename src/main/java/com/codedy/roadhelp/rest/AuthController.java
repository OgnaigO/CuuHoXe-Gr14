package com.codedy.roadhelp.rest;

import com.codedy.roadhelp.model.Authority;
import com.codedy.roadhelp.model.User;
import com.codedy.roadhelp.payload.request.LoginRequest;
import com.codedy.roadhelp.payload.response.JwtResponse;
import com.codedy.roadhelp.payload.response.MessageResponse;
import com.codedy.roadhelp.rest.exception.RestNotFoundException;
import com.codedy.roadhelp.security.jwt.JwtUtils;
import com.codedy.roadhelp.service.authority.AuthorityService;
import com.codedy.roadhelp.service.user.UserDetailsImpl;
import com.codedy.roadhelp.service.user.UserService;
import com.codedy.roadhelp.util.Common;
import com.codedy.roadhelp.util.email.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/auth")
public class AuthController {

    //region - Autowired Service -
    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    AuthorityService authorityService;

    @Autowired
    UserService userService;

    @Autowired
    JwtUtils jwtUtils;

    @Qualifier("emailServiceImplement_SpringMail")
    @Autowired
    private EmailService emailService;
    //endregion


    //region - Config -
    @Value("${bezkoder.app.jwtExpirationMs}")
    private int jwtExpirationMs;
    //endregion


    //region - Base -
    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        Date date = new Date();
        long iat = date.getTime();
        Date exp = new Date(iat + jwtExpirationMs);
        int expiresIn = jwtExpirationMs / 1000 * 7;

        String notification = "Login successfully!";

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                exp,
                expiresIn,
                notification,
                roles));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody User userRequest, @RequestParam(value = "autoLogin", required = false, defaultValue = "false") boolean autoLogin) {
        // Create new user's account
        User user = new User();
        user.setUsername(userRequest.getUsername());
        user.setPhone(userRequest.getPhone());
        user.setEmail(userRequest.getEmail());
        user.setPassword(BCrypt.hashpw(userRequest.getPassword(), BCrypt.gensalt(12)));

        // Create new authority
        Authority authority = new Authority();
        authority.setUser(user);
        authority.setAuthority("ROLE_MEMBER");

        List<Authority> authorities = new ArrayList<>();
        authorities.add(authority);

        user.setAuthorities(authorities);

        userService.save(user);


        // Tự động đăng nhập
        if (autoLogin == true) {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(userRequest.getUsername(), userRequest.getPassword()));

            Date date = new Date();
            long iat = date.getTime();
            Date exp = new Date(iat + jwtExpirationMs);
            int expiresIn = jwtExpirationMs / 1000;

            String notification = "User registered successfully!";

            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = jwtUtils.generateJwtToken(authentication);

            UserDetailsImpl userDetails = (UserDetailsImpl) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            List<String> roles = userDetails.getAuthorities().stream()
                    .map(item -> item.getAuthority())
                    .collect(Collectors.toList());

            return ResponseEntity.ok(new JwtResponse(jwt,
                    userDetails.getId(),
                    userDetails.getUsername(),
                    exp,
                    expiresIn,
                    notification,
                    roles));
        }

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));

    }
    //endregion


    //region - Extend -
    @PostMapping(path = {"/become-to-partner/{userMemberId}", "/become-to-partner/{userMemberId}/"})
    public ResponseEntity<?> becomeToPartner(@PathVariable int userMemberId) {

        User user = userService.findById(userMemberId);

        String verificationPartnerCode = String.valueOf(Common.random(1000, 9999));

        // 01. Cập nhật DB
        user.setVerificationPartnerCode(verificationPartnerCode);
        userService.save(user);

        // 02. Gửi mail
        Map<String, Object> mail_data = new HashMap<>() {{
            put("verificationPartnerCode", verificationPartnerCode);
        }};
        this.sendEmail_VerificationPartnerCode(user.getEmail(), mail_data);

        return ResponseEntity.ok(new MessageResponse("Successfully! Please check email and verification code"));
    }

    @PostMapping(path = {"/become-to-partner/{userMemberId}/verification/{verificationPartnerCode}", "/become-to-partner/{userMemberId}/verification/{verificationPartnerCode}/"})
    public ResponseEntity<?> becomeToPartnerVerification(@PathVariable int userMemberId, @PathVariable String verificationPartnerCode) {

        User user = userService.findById(userMemberId);

        if (!user.getVerificationPartnerCode().equals(verificationPartnerCode)) {
            throw new RuntimeException("Mã xác thực không khớp.");
        }

        user.setRequestBecomePartner(true);
        user.setVerificationPartnerCode(null); //Xóa mã
        userService.save(user);

        return ResponseEntity.ok(new MessageResponse("Request become partner successfully"));
    }

    @PostMapping(path = {"/confirm-become-to-partner/{userMemberId}", "/confirm-become-to-partner/{userMemberId}/"})
    public ResponseEntity<?> confirmBecomeToPartner(@PathVariable int userMemberId) {

        User user = userService.findById(userMemberId);

        if (!user.isRequestBecomePartner()) {
            throw new RuntimeException("Tài khoản này không trong trạng thái 'yêu cầu trở thành đối tác'");
        }

        List<Authority> auths = user.getAuthorities();

        String role = "ROLE_PARTNER";

        Authority authority = new Authority();

        for (var auth : auths) {
            if (!Objects.equals(auth.getAuthority(), role)) {
                authority.setUser(user);
                authority.setAuthority("ROLE_PARTNER");

                List<Authority> authorities = new ArrayList<>();
                authorities.add(authority);
                authority.setId(authority.getId());

                authorityService.save(authority);

                //Cập nhật user
                user.setRequestBecomePartner(false);
                userService.save(user);

                // 02. Gửi mail thông báo admin đã xác nhận nâng cấp tài khoản parter:
                Map<String, Object> mail_data = new HashMap<>() {{
                    //put("key", "value");
                }};
                this.sendEmail_NotificationNewPartnerAccount(user.getEmail(), mail_data);

                return ResponseEntity.ok(new MessageResponse("Become to partner successfully!"));
            }
        }

        return ResponseEntity.ok(new MessageResponse("Become to partner failure!"));
    }

    // Danh sách user đang yêu cầu trở thành partner - Admin - Làm tạm
    @GetMapping(path = {"/userRequestBecomePartner", "/userRequestBecomePartner/"})
    public List<LinkedHashMap<String, Object>> userRequestBecomePartner() {

        return userService.findAllByRequestBecomePartner(true).stream().map(User::toApiResponse).toList();

    }
    //endregion


    private void sendEmail_VerificationPartnerCode(String toEmail, Map<String, Object> mailData) {

        //toEmail = "DinhHieu8896@gmail.com"; //Test Only

        // Cách 1. Gửi mail đơn giản:
        emailService.sendSimpleMessage(toEmail, "Thông báo mã xác minh trở thành đối tác", "Mã xác minh của bạn là: " + mailData.get("verificationPartnerCode"));

    }

    private void sendEmail_NotificationNewPartnerAccount(String toEmail, Map<String, Object> mailData) {

        // Cách 1. Gửi mail đơn giản:
        emailService.sendSimpleMessage(toEmail, "Bạn đã trở thành đối tác của Chúng tôi", "Chúng tôi đã xem xét và phê duyệt yêu cầu nâng cấp tài khoản đối tác của bạn. Hãy khởi động lại ứng dụng để trải nghiệm đầy đủ tính năng của tài khoản đối tác. Cảm ơn bạn.");

    }

    @PostMapping(path = {"/reset-password", "/reset-password/"})
    public ResponseEntity<?> resetPassword(@RequestParam(required = false, defaultValue = "") String email){

        User user = userService.findByEmail(email);

        if (user == null) {
            throw new RestNotFoundException("Email not found - " + email);
        }

        String resetPasswordCode = String.valueOf(Common.random(1000, 9999));

        // 01. Cập nhật DB
        user.setResetPasswordCode(resetPasswordCode);
        userService.save(user);

        // 02. Gửi mail
        Map<String, Object> mail_data = new HashMap<>() {{
            put("resetPasswordCode", resetPasswordCode);
        }};
        this.sendEmail_ResetPasswordCode(user.getEmail(), mail_data);

        return ResponseEntity.ok(new MessageResponse("Successfully! Please check email and verification code"));

    }

    @PostMapping(path = {"/reset-password/{email}/verification/{resetPasswordCode}", "/reset-password/{email}/verification/{resetPasswordCode}/"})
    public ResponseEntity<?> resetPasswordVerification(@PathVariable String email, @PathVariable String resetPasswordCode) {

        User user = userService.findByEmail(email);

        if (!user.getResetPasswordCode().equals(resetPasswordCode)) {
            throw new RuntimeException("Mã xác thực không khớp.");
        }

        user.setResetPasswordCode(null); //Xóa mã
        userService.save(user);

        return ResponseEntity.ok(new MessageResponse("Reset password successfully"));
    }

    @PutMapping(path = {"/confirm-reset-password/{email}", "/confirm-reset-password/{email}/"})
    public ResponseEntity<?> confirmResetPassword(@Valid @RequestBody HashMap<String, String> requestBody, @PathVariable String email) {
        User user = userService.findByEmail(email);
        String password = requestBody.get("password");
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt(12)));

        userService.save(user);
        return ResponseEntity.ok(new MessageResponse("Reset password successfully!"));
    }

    private void sendEmail_ResetPasswordCode(String toEmail, Map<String, Object> mailData) {
        emailService.sendSimpleMessage(toEmail, "Thông báo mã xác minh", "Mã xác minh của bạn là: " + mailData.get("resetPasswordCode"));


    }
}
