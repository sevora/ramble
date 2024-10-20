import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/views/pages/base_widget.dart';
import 'package:ramble_mobile/views/reusable/tab_filter.dart';
import '../../controllers/user_controller.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/icon_button.dart';
import '../reusable/mini_profile_widget.dart';
import '../reusable/post_widget.dart';

class FollowingWidget extends StatefulWidget {
  final UserController userController;
  final BaseController baseController;
  final UserModel user;
  final String initialCategory;
  const FollowingWidget({super.key, required this.userController, required this.baseController, required this.user, required this.initialCategory});

  @override
  State<FollowingWidget> createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends State<FollowingWidget> {
  late UserController _userController;
  late UserModel _user;
  final PagingController<int, UserModel> _accountsController = PagingController(firstPageKey: 0);

  late String _category;

  Future<void> _loadUsers(int pageKey) async {
    var newUsers = await _userController.getFollowAccounts(page: pageKey, username: _user.username, category: _category);
    if (newUsers.isNotEmpty) {
      _accountsController.appendPage(newUsers, pageKey+1);
    } else {
      _accountsController.appendLastPage([]);
    }
  }

  @override
  void initState() {
    _user = widget.user;
    _userController = widget.userController;
    _category = widget.initialCategory;
    _accountsController.addPageRequestListener((pageKey) {
      _loadUsers(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TabFilter(choices: ["following", "follower"], active: _category, onSelect: (choice) {
          setState(() {
            _category = choice;
            _accountsController.refresh();
          });
        }),
        Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                    () {
                      _accountsController.refresh();
                      },
              ),
              child:
              PagedListView(
                  pagingController: _accountsController,
                  builderDelegate: PagedChildBuilderDelegate<UserModel>(
                      itemBuilder: (context, item, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: MiniProfileWidget(user: item, userController: _userController, baseController: widget.baseController,)
                        );
                      }
                  )
              ) ,
            )
        )
      ],
    );
  }

  @override
  void dispose() {
    _accountsController.dispose();
    super.dispose();
  }
}
