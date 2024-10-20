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

class SearchWidget extends StatefulWidget {
  final UserController userController;
  final BaseController baseController;
  const SearchWidget({super.key, required this.userController, required this.baseController});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late UserController _userController;
  final PagingController<int, PostModel> _postsController = PagingController(firstPageKey: 0);
  final PagingController<int, UserModel> _accountsController = PagingController(firstPageKey: 0);

  String _search = "";
  String _activeSearch = "";
  String _filter = "people";

  Future<void> _loadPosts(int pageKey) async {
    if (_activeSearch.isNotEmpty && _filter == "posts") {
      var newPosts = await _userController.searchPosts(page: pageKey, content: _activeSearch);
      if (newPosts.isNotEmpty) {
        _postsController.appendPage(newPosts, pageKey+1);
      } else {
        _postsController.appendLastPage([]);
      }
    } else {
      _postsController.appendLastPage([]);
    }
  }

  Future<void> _loadUsers(int pageKey) async {
    if (_activeSearch.isNotEmpty && _filter == "people") {
      var newUsers = await _userController.searchAccounts(page: pageKey, username: _activeSearch);
      if (newUsers.isNotEmpty) {
        _accountsController.appendPage(newUsers, pageKey+1);
      } else {
        _accountsController.appendLastPage([]);
      }
    } else {
      _accountsController.appendLastPage([]);
    }
  }

  @override
  void initState() {
    _userController = widget.userController;
    _postsController.addPageRequestListener((pageKey) {
      _loadPosts(pageKey);
    });
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
        Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          decoration: BoxDecoration(
            color: LightModeTheme().secondaryBackground,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          _search = text;
                        });
                      },
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle:
                        TypographyTheme().labelMedium.override(
                          fontFamily: 'Roboto',
                          letterSpacing: 0.0,
                        ),
                        hintText:
                        'Search for users, posts, and comments',
                        hintStyle:
                        TypographyTheme().labelMedium.override(
                          fontFamily: 'Roboto',
                          letterSpacing: 0.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: LightModeTheme().error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: LightModeTheme().error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: LightModeTheme().secondaryBackground,
                      ),
                      style: TypographyTheme().bodyMedium.override(
                        fontFamily: 'Roboto',
                        letterSpacing: 0.0,
                      ),
                      cursorColor: LightModeTheme().primaryText,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  child: IconButtonWidget(
                    borderRadius: 100.0,
                    buttonSize: 40.0,
                    fillColor: LightModeTheme().orangePeel,
                    icon: const Icon(
                      Icons.search_sharp,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _activeSearch = _search;
                        if (_filter == "posts") {
                          _postsController.refresh();
                        } else if (_filter == "people") {
                          _accountsController.refresh();
                        }
                      });
                    },
                  ),
                ),
              ].divide(const SizedBox(width: 20.0)),
            ),
          ),
        ),
        TabFilter(choices: ["people", "posts"], active: _filter, onSelect: (choice) {
          setState(() {
            _filter = choice;
            if (_filter == "posts") {
              _postsController.refresh();
            } else if (_filter == "people") {
              _accountsController.refresh();
            }
          });
        }),
        Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                    () {
                      if (_filter == "posts") {
                        _postsController.refresh();
                      } else if (_filter == "people") {
                        _accountsController.refresh();
                      }
                      },
              ),
              child: _filter == "posts" ?
              PagedListView(
                  pagingController: _postsController,
                  builderDelegate: PagedChildBuilderDelegate<PostModel>(
                      itemBuilder: (context, item, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: PostWidget(post: item, userController: _userController, allowViewPost: true, onDelete: () {
                              _postsController.refresh();
                            }, baseController: widget.baseController,)
                        );
                      }
                  )
              )
                  :
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
    _postsController.dispose();
    _accountsController.dispose();
    super.dispose();
  }
}
