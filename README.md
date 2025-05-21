# flutter_application_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# RoadHelp - Cứu hộ đường bộ (Flutter + Spring Boot)

Ứng dụng hỗ trợ người dùng tìm kiếm dịch vụ cứu hộ xe cộ, gửi yêu cầu khẩn cấp, định vị trên bản đồ và theo dõi tiến trình xử lý — được phát triển bởi Flutter (Mobile) và Spring Boot (Backend).

---

## 🚀 Tính năng chính

- Đăng nhập / Đăng ký tài khoản (Admin, Member, Partner)
- Gửi yêu cầu cứu hộ khẩn cấp
- Định vị và chia sẻ vị trí theo thời gian thực
- Quản lý tài khoản, đơn hàng, thông báo
- Phân quyền theo vai trò người dùng

---

## 🧑‍💻 Công nghệ sử dụng

| Thành phần     | Công nghệ                    |
|----------------|------------------------------|
| Frontend       | Flutter 3.29.3               |
| Ngôn ngữ       | Dart 3.7.2                   |
| Backend        | Spring Boot 2.5.6            |
| Java           | JDK 17.0.14 (LTS)            |
| Build tool     | Maven 3.8.8                  |
| Database       | MySQL                        |
| WebSocket      | STOMP over WebSocket         |
| Authentication | JWT (JSON Web Token)         |

---

## 💻 Môi trường phát triển

| Thành phần     | Phiên bản                    |
|----------------|------------------------------|
| Hệ điều hành   | Windows 11 (10.0, amd64)     |
| Java           | 17.0.14                      |
| Maven          | 3.8.8                        |
| Flutter SDK    | 3.29.3                       |
| Dart SDK       | 3.7.2                        |
| MySQL          | (cấu hình riêng theo hệ thống) |

---

## ⚙️ Hướng dẫn chạy dự án

### 🔹 Backend (Spring Boot)

```bash
cd roadhelp_web
mvn clean install
mvn spring-boot:run
-- Mobile App (Flutter)
bash
Copy
Edit
cd roadhelp_app
flutter pub get
flutter run# CuuHoXe-Gr14
