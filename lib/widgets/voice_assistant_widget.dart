import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/speech_service.dart';
import '../services/gemini_service.dart';

enum _AssistantState { idle, listening, thinking, speaking }

class VoiceAssistantWidget extends StatefulWidget {
  const VoiceAssistantWidget({super.key});

  @override
  State<VoiceAssistantWidget> createState() => _VoiceAssistantWidgetState();
}

class _VoiceAssistantWidgetState extends State<VoiceAssistantWidget>
    with SingleTickerProviderStateMixin {
  _AssistantState _state = _AssistantState.idle;
  String _transcript = '';
  String _response = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    // Khởi tạo trước
    SpeechService.initialize();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    SpeechService.stopListening();
    SpeechService.cancelSpeech();
    super.dispose();
  }

  Future<void> _onMicTap() async {
    if (_state == _AssistantState.listening) {
      await SpeechService.stopListening();
      _pulseController.stop();
      setState(() => _state = _AssistantState.idle);
    } else if (_state == _AssistantState.speaking) {
      await SpeechService.cancelSpeech();
      _pulseController.stop();
      setState(() => _state = _AssistantState.idle);
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _state = _AssistantState.listening;
      _transcript = '';
      _response = '';
    });
    _pulseController.repeat(reverse: true);

    await SpeechService.startListening(
      onResult: (transcript) {
        if (!mounted) return;
        setState(() => _transcript = transcript);
        _askGemini(transcript);
      },
      onDone: () {
        // Nếu không nhận được gì
        if (mounted && _state == _AssistantState.listening) {
          _pulseController.stop();
          setState(() {
            _state = _AssistantState.idle;
            _response = 'Không nghe rõ. Bạn thử nói lại nhé!';
          });
        }
      },
    );
  }

  Future<void> _askGemini(String question) async {
    _pulseController.stop();
    setState(() => _state = _AssistantState.thinking);

    final answer = await GeminiService().ask(question);
    if (!mounted) return;

    setState(() {
      _state = _AssistantState.speaking;
      _response = answer;
    });
    _pulseController.repeat(reverse: true);

    await SpeechService.speak(answer, onDone: () {
      if (mounted) {
        _pulseController.stop();
        setState(() => _state = _AssistantState.idle);
      }
    });
  }

  String get _statusText {
    switch (_state) {
      case _AssistantState.idle: return 'Bạn cần giúp gì?';
      case _AssistantState.listening: return 'Đang nghe...';
      case _AssistantState.thinking: return 'Đang suy nghĩ...';
      case _AssistantState.speaking: return 'Đang trả lời...';
    }
  }

  Color get _ringColor {
    switch (_state) {
      case _AssistantState.idle: return const Color(0xFFE8D5A0);
      case _AssistantState.listening: return AppColors.primaryGreen;
      case _AssistantState.thinking: return Colors.orange;
      case _AssistantState.speaking: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Mic Button ─────────────────────────────────────────
        GestureDetector(
          onTap: _onMicTap,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, child) {
              final scale = (_state == _AssistantState.listening ||
                      _state == _AssistantState.speaking)
                  ? _pulseAnimation.value
                  : 1.0;
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF5E0B0).withValues(alpha: 0.5),
                border: Border.all(color: _ringColor.withValues(alpha: 0.5), width: 3),
                boxShadow: _state != _AssistantState.idle
                    ? [BoxShadow(color: _ringColor.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 4)]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_state == _AssistantState.thinking)
                    const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.orange),
                    )
                  else
                    Icon(
                      _state == _AssistantState.speaking
                          ? Icons.volume_up
                          : _state == _AssistantState.listening
                              ? Icons.mic
                              : Icons.mic_none,
                      size: 40,
                      color: _state == _AssistantState.idle
                          ? AppColors.primaryGreen.withValues(alpha: 0.7)
                          : _ringColor,
                    ),
                  const SizedBox(height: 6),
                  Text(_statusText,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _state == _AssistantState.idle
                            ? AppColors.textPrimary
                            : _ringColor,
                      )),
                ],
              ),
            ),
          ),
        ),

        // ─── Câu hỏi ────────────────────────────────────────────
        if (_transcript.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person_outline, size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(_transcript,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14, color: AppColors.textPrimary, fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),
        ],

        // ─── Câu trả lời ────────────────────────────────────────
        if (_response.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trợ Nông AI',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                      const SizedBox(height: 4),
                      Text(_response,
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
                      if (_state == _AssistantState.speaking) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            await SpeechService.cancelSpeech();
                            _pulseController.stop();
                            if (mounted) setState(() => _state = _AssistantState.idle);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.stop_circle_outlined, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('Dừng đọc',
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
