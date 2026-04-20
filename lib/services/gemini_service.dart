import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyCLSVGqD6696AKNP5LOwCtafFxjO6prka4';
  static const String _model = 'gemini-1.5-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  static const String _systemPrompt = '''
Bạn là trợ lý nông nghiệp thông minh của ứng dụng "Trợ Nông" – một ứng dụng hỗ trợ nông dân Việt Nam quản lý canh tác, bán nông sản và trao đổi kiến thức nông nghiệp.

Vai trò của bạn:
- Giải đáp câu hỏi về kỹ thuật canh tác lúa, rau màu, cây ăn trái
- Tư vấn xử lý sâu bệnh, phân bón, tưới tiêu
- Hướng dẫn sử dụng các tính năng của ứng dụng Trợ Nông
- Giải thích về thị trường nông sản, giá cả
- Chia sẻ kiến thức khí hậu, thời vụ phù hợp

Tính năng của ứng dụng Trợ Nông:
- Trang chủ: xem thời tiết, công việc hôm nay, chức năng nhanh
- Dự án: quản lý vụ mùa, ghi nhật ký canh tác
- Cửa hàng: đăng bán nông sản
- Diễn đàn: trao đổi với nông dân khác
- Hồ sơ: thông tin cá nhân, cài đặt

Quy tắc trả lời:
- Dùng tiếng Việt tự nhiên, thân thiện như người nông dân
- Câu trả lời ngắn gọn, dễ hiểu (3-5 câu là đủ với câu hỏi đơn giản)
- Nếu câu hỏi kỹ thuật phức tạp thì có thể trả lời chi tiết hơn
- Dùng các đơn vị quen thuộc: ha, công, kg, bao...
- Đừng dùng markdown (không dùng **, ##, -) vì câu trả lời sẽ được đọc to
''';

  Future<String> ask(String question) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': '$_systemPrompt\n\nNông dân hỏi: $question'}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 512,
          },
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List<dynamic>;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>;
          final parts = content['parts'] as List<dynamic>;
          return (parts[0]['text'] as String).trim();
        }
      }
      return 'Xin lỗi, tôi không thể kết nối được lúc này. Bạn thử lại sau nhé!';
    } catch (e) {
      return 'Xin lỗi, có lỗi kết nối. Kiểm tra mạng và thử lại nhé!';
    }
  }
}
