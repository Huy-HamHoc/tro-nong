# 🌾 Trợ Nông - Ứng dụng hỗ trợ nông dân

Ứng dụng Flutter hỗ trợ nông dân quản lý dự án, mua bán nông sản, và kết nối cộng đồng.

## 📱 Các màn hình

| # | Màn hình | Mô tả |
|---|----------|-------|
| 1 | Splash | Trang loading với logo |
| 2 | Đăng nhập | Số điện thoại + mật khẩu |
| 3 | Đăng ký | Tạo tài khoản mới |
| 4 | Trang chủ | Thời tiết, công việc, chức năng |
| 5 | Dự án | Danh sách dự án đang thực hiện |
| 6 | Cửa hàng | Quản lý sản phẩm, doanh thu |
| 7 | Diễn đàn | Bài viết, thảo luận nông nghiệp |
| 8 | Hồ sơ | Thông tin cá nhân, thống kê |
| 9 | Chi tiết dự án | Nhật ký, tiến độ, vật tư |
| 10 | Thêm dự án | Form tạo dự án mới |
| 11 | Thêm sản phẩm | Đăng bán sản phẩm |
| 12 | Tạo mã QR | Truy xuất nguồn gốc |
| 13 | Cài đặt | Font, âm lượng, thông báo |
| 14 | Bảo mật | Đổi mật khẩu |
| 15 | Công việc | Danh sách việc hôm nay |

## 🚀 Hướng dẫn cài đặt và sử dụng (Cho người mới)

### 1. Yêu cầu môi trường
Trước khi bắt đầu, máy tính của bạn cần cài đặt các công cụ sau:
- **Flutter SDK** (phiên bản 3.11+): [Hướng dẫn cài đặt Flutter](https://docs.flutter.dev/get-started/install)
- **Android Studio** hoặc **Visual Studio Code**: 

### 2. Tải 

**Bước 1: Cài đặt các thư viện (dependencies)**
```bash
flutter pub get
```

---

### 3. Hướng dẫn chạy ứng dụng

#### Tùy chọn 1: Chạy trên trình duyệt Chrome 
```bash
flutter run -d chrome
```
*Cách xem giao diện điện thoại*
1. Khi app đã chạy, trên tab Chrome nhấn **F12** (mở Developer Tools).
2. Nhấn **Ctrl + Shift + M** (bật chế độ hiển thị thiết bị di động).
3. Chọn thiết bị giả lập ở thanh trên cùng (ví dụ: iPhone 14 Pro) và F5 (Refresh) lại trang.

#### 📱 Tùy chọn 2: Build file APK (Android)
Đảm bảo đã cài đặt Android Studio và Android SDK.

**Cách 1: Chạy trực tiếp lên máy ảo / máy thật**
- Bật máy ảo từ Android Studio, HOẶC cắm điện thoại Android vào máy tính
```bash
flutter run -d android
```

**Cách 2: Xuất file cài đặt APK**
Để tạo file `.apk` và gửi cho người dùng cài đặt, chạy lệnh sau:
```bash
flutter build apk --release
```
*Sau khi build thành công, file APK sẽ được tạo tại thư mục:*
`build\app\outputs\flutter-apk\app-release.apk`
Bạn có thể copy file này vào điện thoại để cài đặt.

## 🛠 Công nghệ sử dụng
- **Flutter** 3.11+
- **Dart**
- **Google Fonts** (Be Vietnam Pro)

## 📂 Cấu trúc thư mục
```
lib/
├── main.dart                  # Entry point
├── theme/
│   └── app_theme.dart         # Màu sắc, typography
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── projects_screen.dart
│   ├── store_screen.dart
│   ├── forum_screen.dart
│   ├── profile_screen.dart
│   ├── project_detail_screen.dart
│   ├── add_project_screen.dart
│   ├── add_product_screen.dart
│   ├── qr_screen.dart
│   ├── settings_screen.dart
│   ├── change_password_screen.dart
│   ├── tasks_screen.dart
│   └── main_scaffold.dart
└── widgets/
    ├── logo_widget.dart
    ├── bottom_nav_bar.dart
    └── navigation_drawer_widget.dart
```
