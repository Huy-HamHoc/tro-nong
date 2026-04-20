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

## 🚀 Cách chạy app

### Yêu cầu
- **Flutter SDK** (phiên bản 3.11+): [Tải tại đây](https://docs.flutter.dev/get-started/install)
- **Chrome** (để chạy trên web)

### Bước 1: Clone dự án
```bash
git clone https://github.com/Huy-HamHoc/tro-nong.git
cd tro-nong
```

### Bước 2: Cài dependencies
```bash
flutter pub get
```

### Bước 3: Chạy app
```bash
# Chạy trên Chrome (web)
flutter run -d chrome

# Chạy trên Android (cần Android Studio + thiết bị/emulator)
flutter run -d android

# Chạy trên Windows
flutter run -d windows
```

### Bước 4: Xem giao diện điện thoại trên Chrome
1. Nhấn **F12** (mở Developer Tools)
2. Nhấn **Ctrl + Shift + M** (bật chế độ mobile)
3. Chọn thiết bị (ví dụ: iPhone 14 Pro)

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
