import 'package:flutter/material.dart';
import '../../views/pages/posts_widget.dart';
import '../../views/pages/search_widget.dart';
import '../../views/pages/settings_widget.dart';
import '../../views/pages/view_profile_widget.dart';
import '../../themes/light_mode_theme.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({super.key});

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    const PostsWidget(),
    const SearchWidget(),
    const ViewProfileWidget(),
    const SettingsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) => setState(() {
          _pageIndex = index;
        }),
        backgroundColor: LightModeTheme().primaryBackground,
        selectedItemColor: LightModeTheme().orangePeel,
        unselectedItemColor: LightModeTheme().secondaryText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Posts',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search_rounded),
            activeIcon: Icon(Icons.search_outlined),
          ),
          BottomNavigationBarItem(
            label: 'View Profile',
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_sharp),
          )
        ],
      ),
      backgroundColor: LightModeTheme().primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
            child: _pages.elementAt(_pageIndex)
        ),
      ),
    );
  }
}
