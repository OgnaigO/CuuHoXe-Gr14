package com.codedy.roadhelp.model;

import com.codedy.roadhelp.model.enums.UserGender;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.List;

@Entity
@Table(name = "users")
//@JsonIdentityInfo(scope = Authority.class, generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class User extends BaseModel implements Serializable {

    //region - Define Fields -
    @NotNull
    @Size(min = 6, max = 64)
    private String username;

    @Email(message = "Email is not valid", regexp = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
    @NotEmpty(message = "Email cannot be empty")
    @Size(max = 128)
    private String email;

    @Size(min = 10)
    private String phone;

    @Size(min = 6)
    private String password;

    @Size(min = 2, max = 64)
    private String firstName;

    @Size(min = 2, max = 64)
    private String lastName;

    @Size(max = 128)
    private String image;

    private String address;

    private UserGender gender;

    private Boolean active;

    private double rateAvg;

    private boolean requestBecomePartner;

    private String verificationMemberCode;

    private String verificationPartnerCode;

    private String resetPasswordCode;
    //endregion


    //region - Relationship -
    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<Authority> authorities;

    @OneToMany(mappedBy = "userPartner", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    private List<Garage> garages;

    @OneToMany(mappedBy = "userMember", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    //@JsonBackReference(value = "issueMemberDetails")
    private List<Issue> memberIssues;

    @OneToMany(mappedBy = "userPartner", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    //@JsonBackReference(value = "issuesPartnerDetails")
    private List<Issue> partnerIssues;

    @OneToMany(mappedBy = "userMember")
    private List<RatingGarage> ratingGarages;

    @OneToMany(mappedBy = "userMember")
    //@JsonBackReference(value = "ratingIssues")
    private List<RatingIssue> ratingIssues;
    //endregion


    //region - Getter & Setter -
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public UserGender getGender() {
        return gender;
    }

    public void setGender(UserGender gender) {
        this.gender = gender;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public List<Authority> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(List<Authority> authorities) {
        this.authorities = authorities;
    }

    public List<Garage> getGarages() {
        return garages;
    }

    public void setGarages(List<Garage> garages) {
        this.garages = garages;
    }

    public List<Issue> getMemberIssues() {
        return memberIssues;
    }

    public void setMemberIssues(List<Issue> memberIssues) {
        this.memberIssues = memberIssues;
    }

    public List<Issue> getPartnerIssues() {
        return partnerIssues;
    }

    public void setPartnerIssues(List<Issue> partnerIssues) {
        this.partnerIssues = partnerIssues;
    }

    public List<RatingGarage> getRatingGarages() {
        return ratingGarages;
    }

    public void setRatingGarages(List<RatingGarage> ratingGarages) {
        this.ratingGarages = ratingGarages;
    }

    public List<RatingIssue> getRatingIssues() {
        return ratingIssues;
    }

    public void setRatingIssues(List<RatingIssue> ratingIssues) {
        this.ratingIssues = ratingIssues;
    }

    public double getRateAvg() {
        return rateAvg;
    }

    public void setRateAvg(double rateAvg) {
        this.rateAvg = rateAvg;
    }

    public boolean isRequestBecomePartner() {
        return requestBecomePartner;
    }

    public void setRequestBecomePartner(boolean requestBecomePartner) {
        this.requestBecomePartner = requestBecomePartner;
    }

    public String getVerificationMemberCode() {
        return verificationMemberCode;
    }

    public void setVerificationMemberCode(String verificationMemberCode) {
        this.verificationMemberCode = verificationMemberCode;
    }

    public String getVerificationPartnerCode() {
        return verificationPartnerCode;
    }

    public void setVerificationPartnerCode(String verificationPartnerCode) {
        this.verificationPartnerCode = verificationPartnerCode;
    }

    public String getResetPasswordCode() {
        return resetPasswordCode;
    }

    public void setResetPasswordCode(String resetPasswordCode) {
        this.resetPasswordCode = resetPasswordCode;
    }
    //endregion


    //region - Relationship Helper -

    /**
     * Hàm này trả về cấu trúc nguyên thủy của entity này.<br/><br/>
     * <p>
     * @return
     */
    protected LinkedHashMap<String, Object> toHashMap() {
        LinkedHashMap<String, Object> hashMap = super.toHashMap();

        hashMap.put("username", username);
        hashMap.put("email", email);
        hashMap.put("password", password);
        hashMap.put("image", image);
        hashMap.put("gender", gender);
        hashMap.put("firstName", firstName);
        hashMap.put("lastName", lastName);
        hashMap.put("phone", phone);
        hashMap.put("address", address);
        hashMap.put("active", active);
        hashMap.put("rateAvg", rateAvg);
        hashMap.put("requestBecomePartner", requestBecomePartner);
        hashMap.put("verificationMemberCode", verificationMemberCode);
        hashMap.put("verificationPartnerCode", verificationPartnerCode);
        hashMap.put("resetPasswordCode", resetPasswordCode);

        return hashMap;
    }

    /**
     * Hàm này trả về định dạng hiển thị dữ liệu API cho entity này.<br/><br/>
     * <p>
     *
     * @return
     */
    public LinkedHashMap<String, Object> toApiResponse() {
        LinkedHashMap<String, Object> hashMap = this.toHashMap();

        hashMap.put("authorities", getAuthoritiesHashMap());
        hashMap.put("garages", getGaragesHashMap());
        hashMap.put("memberIssues", getMemberIssuesHashMap());
        hashMap.put("partnerIssues", getPartnerIssuesHashMap());
        hashMap.put("ratingGarages", getRatingGaragesHashMap());
        hashMap.put("ratingIssues", getRatingIssuesHashMap());

        return hashMap;
    }


    //@JsonProperty("authorities")
    private List<LinkedHashMap<String, Object>> getAuthoritiesHashMap() {
        return authorities != null ? authorities.stream().map(Authority::toHashMap).toList() : null;
    }

    //@JsonProperty("garages")
    private List<LinkedHashMap<String, Object>> getGaragesHashMap() {
        return garages != null ? garages.stream().map(Garage::toHashMap).toList() : null;
    }

    //@JsonProperty("memberIssues")
    private List<LinkedHashMap<String, Object>> getMemberIssuesHashMap() {
        return memberIssues != null ? memberIssues.stream().map(Issue::toHashMap).toList() : null;
    }

    //@JsonProperty("partnerIssues")
    private List<LinkedHashMap<String, Object>> getPartnerIssuesHashMap() {
        return partnerIssues != null ? partnerIssues.stream().map(Issue::toHashMap).toList() : null;
    }

    //@JsonProperty("ratingGarages")
    private List<LinkedHashMap<String, Object>> getRatingGaragesHashMap() {
        return ratingGarages != null ? ratingGarages.stream().map(RatingGarage::toHashMap).toList() : null;
    }

    //@JsonProperty("ratingIssues")
    private List<LinkedHashMap<String, Object>> getRatingIssuesHashMap() {
        return ratingIssues != null ? ratingIssues.stream().map(RatingIssue::toHashMap).toList() : null;
    }

    //endregion

}
