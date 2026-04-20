import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/project_detail_screen.dart';
import 'screens/add_project_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/qr_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(const TroNongApp());
}

class TroNongApp extends StatelessWidget {
  const TroNongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trợ Nông',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScaffold(),
        '/project-detail': (context) => const ProjectDetailScreen(),
        '/add-project': (context) => const AddProjectScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/qr': (context) => const QrScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/tasks': (context) => const TasksScreen(),
      },
    );
  }
}
