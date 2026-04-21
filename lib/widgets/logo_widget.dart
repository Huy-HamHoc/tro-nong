import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  const LogoWidget({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/logo_duan.jpg',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
