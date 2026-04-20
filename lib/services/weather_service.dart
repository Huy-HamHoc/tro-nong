import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '9545076a1583de1051bc4ab1e6a14fdf';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// Lấy thời tiết theo tên thành phố/địa chỉ
  /// Trả về Map với: temp, description, icon, city
  Future<Map<String, dynamic>?> getWeatherByAddress(String address) async {
    if (address.isEmpty) return null;

    // Trích xuất tên tỉnh/thành phố từ địa chỉ
    final city = _extractCity(address);

    try {
      final uri = Uri.parse(
        '$_baseUrl?q=$city,VN&appid=$_apiKey&units=metric&lang=vi',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final weather = (data['weather'] as List).first;
        final main = data['main'] as Map<String, dynamic>;

        return {
          'temp': (main['temp'] as num).round(),
          'feels_like': (main['feels_like'] as num).round(),
          'humidity': main['humidity'],
          'description': _translateDescription(weather['main'] as String),
          'icon': weather['main'] as String,
          'city': data['name'] as String,
          'advice': _getFarmingAdvice(weather['main'] as String),
        };
      }
    } catch (_) {}
    return null;
  }

  /// Trích xuất tên tỉnh từ địa chỉ
  String _extractCity(String address) {
    // Danh sách tỉnh/thành phố Việt Nam phổ biến
    final provinces = [
      'An Giang', 'Bà Rịa', 'Bạc Liêu', 'Bắc Giang', 'Bắc Kạn',
      'Bắc Ninh', 'Bến Tre', 'Bình Dương', 'Bình Định', 'Bình Phước',
      'Bình Thuận', 'Cà Mau', 'Cao Bằng', 'Cần Thơ', 'Đà Nẵng',
      'Đắk Lắk', 'Đắk Nông', 'Điện Biên', 'Đồng Nai', 'Đồng Tháp',
      'Gia Lai', 'Hà Giang', 'Hà Nam', 'Hà Nội', 'Hà Tĩnh',
      'Hải Dương', 'Hải Phòng', 'Hậu Giang', 'Hòa Bình', 'Hưng Yên',
      'Khánh Hòa', 'Kiên Giang', 'Kon Tum', 'Lai Châu', 'Lạng Sơn',
      'Lào Cai', 'Lâm Đồng', 'Long An', 'Nam Định', 'Nghệ An',
      'Ninh Bình', 'Ninh Thuận', 'Phú Thọ', 'Phú Yên', 'Quảng Bình',
      'Quảng Nam', 'Quảng Ngãi', 'Quảng Ninh', 'Quảng Trị', 'Sóc Trăng',
      'Sơn La', 'Tây Ninh', 'Thái Bình', 'Thái Nguyên', 'Thanh Hóa',
      'Thừa Thiên Huế', 'Tiền Giang', 'Hồ Chí Minh', 'Trà Vinh',
      'Tuyên Quang', 'Vĩnh Long', 'Vĩnh Phúc', 'Yên Bái',
    ];

    // Tìm tỉnh trong địa chỉ
    for (final province in provinces) {
      if (address.toLowerCase().contains(province.toLowerCase())) {
        return province;
      }
    }

    // Nếu không tìm thấy, lấy phần cuối địa chỉ
    final parts = address.split(RegExp(r'[,\-]'));
    return parts.last.trim().isNotEmpty ? parts.last.trim() : 'An Giang';
  }

  String _translateDescription(String main) {
    switch (main) {
      case 'Clear': return 'Trời nắng đẹp';
      case 'Clouds': return 'Có mây';
      case 'Rain': return 'Có mưa';
      case 'Drizzle': return 'Mưa nhỏ';
      case 'Thunderstorm': return 'Có dông bão';
      case 'Snow': return 'Có tuyết';
      case 'Mist':
      case 'Fog': return 'Có sương mù';
      case 'Haze': return 'Trời mờ sương';
      default: return main;
    }
  }

  String _getFarmingAdvice(String main) {
    switch (main) {
      case 'Clear': return 'Lý tưởng để ra đồng';
      case 'Clouds': return 'Thích hợp tưới tiêu';
      case 'Rain': return 'Chú ý thoát nước ruộng';
      case 'Drizzle': return 'Hạn chế phun thuốc';
      case 'Thunderstorm': return 'Không nên ra đồng';
      case 'Mist':
      case 'Fog': return 'Chú ý sâu bệnh';
      default: return 'Kiểm tra điều kiện thời tiết';
    }
  }

}
