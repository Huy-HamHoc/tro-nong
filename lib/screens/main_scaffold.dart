import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/navigation_drawer_widget.dart';
import 'home_screen.dart';
import 'projects_screen.dart';
import 'store_screen.dart';
import 'forum_screen.dart';
import 'profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  NavigationDrawerWidget _buildDrawer() {
    return NavigationDrawerWidget(
      currentIndex: _currentIndex,
      onSelectScreen: _switchTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawer = _buildDrawer();

    // Dùng danh sách widget thay vì IndexedStack để tránh lỗi multiple heroes
    final screens = <Widget>[
      HomeScreen(drawer: drawer, onSwitchTab: _switchTab),
      ProjectsScreen(drawer: drawer),
      StoreScreen(drawer: drawer),
      ForumScreen(drawer: drawer),
      ProfileScreen(drawer: drawer),
    ];

    return Scaffold(
      // Chỉ hiện 1 screen tại 1 thời điểm (không dùng IndexedStack)
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
      ),
    );
  }
}
