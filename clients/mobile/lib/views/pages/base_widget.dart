import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../views/pages/posts_widget.dart';
import '../../views/pages/search_widget.dart';
import '../../views/pages/settings_widget.dart';
import '../../views/pages/view_profile_widget.dart';
import '../../themes/light_mode_theme.dart';

class BaseWidget extends StatefulWidget {
  final UserController userController;
  const BaseWidget({super.key, required this.userController});

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class BaseController {
  final Function(void Function()) setState;
  List<Widget> widgets = [];

  BaseController({required this.setState});

  Widget? get current {
    if (widgets.isEmpty) {
      return null;
    }
    return widgets.last;
  }

  void clear() {
    setState(() {
      widgets.clear();
    });
  }

  void pop() {
    setState(() {
      if (widgets.isNotEmpty) {
        widgets.removeLast();
      }
    });
  }

  void push(Widget widget) {
    setState(() {
      widgets.add(widget);
    });
  }
}

class _BaseWidgetState extends State<BaseWidget> {
  Widget? _customPage;
  List<Widget> _pages = [];
  int _pageIndex = 0;

  late BaseController _baseController;

  @override
  void initState() {
    _baseController = BaseController(setState: setState);
    UserController userController = widget.userController;

    // _pageIndex = _customPage != null ? -1 : _pageIndex;
    _pages = [
      PostsWidget(userController: userController, baseController: _baseController),
      SearchWidget(userController: userController,  baseController: _baseController),
      ViewProfileWidget(userController: userController, user: userController.user, baseController: _baseController, key: Key(userController.user.username)),
      SettingsWidget(userController: userController),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (a, b) {
        _baseController.pop();
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (index) => setState(() {
            _pageIndex = index;
            _baseController.clear();
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
          child: _baseController.current != null ? _baseController.current! : _pages.elementAt(_pageIndex),
        ),
      ),
    );
  }
}
