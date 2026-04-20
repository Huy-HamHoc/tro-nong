import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
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
import 'screens/personal_info_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // Dùng StreamBuilder để theo dõi trạng thái đăng nhập
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Đang kiểm tra → Splash screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // Đã đăng nhập → Vào app
          if (snapshot.hasData && snapshot.data != null) {
            return const MainScaffold();
          }
          // Chưa đăng nhập → Màn hình Login
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScaffold(),
        '/project-detail': (context) => const ProjectDetailScreen(),
        '/add-project': (context) => const AddProjectScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/qr': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
          return QrScreen(
            projectId: args['projectId'] ?? '',
            projectName: args['projectName'] ?? 'Dự án',
          );
        },
        '/settings': (context) => const SettingsScreen(),
        '/personal-info': (context) => const PersonalInfoScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/tasks': (context) => const TasksScreen(),
      },
    );
  }
}
