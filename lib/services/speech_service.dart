import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  static final SpeechToText _stt = SpeechToText();
  static final FlutterTts _tts = FlutterTts();
  static bool _initialized = false;

  /// Khởi tạo (gọi 1 lần)
  static Future<bool> initialize() async {
    if (_initialized) return true;
    _initialized = await _stt.initialize(
      onError: (error) {},
      onStatus: (status) {},
    );

    // Cấu hình TTS tiếng Việt
    await _tts.setLanguage('vi-VN');
    await _tts.setSpeechRate(0.85);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    return _initialized;
  }

  static bool get isAvailable => _stt.isAvailable;
  static bool get isListening => _stt.isListening;

  /// Bắt đầu nghe
  static Future<void> startListening({
    required void Function(String transcript) onResult,
    required void Function() onDone,
  }) async {
    final ok = await initialize();
    if (!ok) return;

    await _stt.listen(
      localeId: 'vi_VN',
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          onResult(result.recognizedWords);
          onDone();
        }
      },
    );
  }

  /// Dừng nghe
  static Future<void> stopListening() async {
    await _stt.stop();
  }

  /// Đọc to văn bản
  static Future<void> speak(String text, {void Function()? onDone}) async {
    await _tts.stop();
    if (onDone != null) {
      _tts.setCompletionHandler(onDone);
    }
    await _tts.speak(text);
  }

  /// Dừng đọc
  static Future<void> cancelSpeech() async {
    await _tts.stop();
  }
}
