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

  NavigationDrawerWidget _buildDrawer() {
    return NavigationDrawerWidget(
      currentIndex: _currentIndex,
      onSelectScreen: (index) {
        setState(() => _currentIndex = index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawer = _buildDrawer();

    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(drawer: drawer),
              ProjectsScreen(drawer: drawer),
              StoreScreen(drawer: drawer),
              ForumScreen(drawer: drawer),
              ProfileScreen(drawer: drawer),
            ],
          ),
        ),
        BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
        ),
      ],
    );
  }
}
