import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/views/reusable/tab_filter.dart';
import '../../controllers/user_controller.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/button.dart';
import '../reusable/post_widget.dart';

class ViewProfileWidget extends StatefulWidget {
  final UserController userController;
  final UserModel user;
  const ViewProfileWidget({super.key, required this.userController, required this.user});

  @override
  State<ViewProfileWidget> createState() => _ViewProfileWidgetState();
}

class _ViewProfileWidgetState extends State<ViewProfileWidget> {
  late UserController _userController;
  late UserModel _user;
  final PagingController<int, PostModel> _pageController = PagingController(firstPageKey: 0);

  String _filter = "posts";

  @override
  void initState() {
    _userController = widget.userController;
    _user = widget.user;
    _pageController.addPageRequestListener((pageKey) {
      _loadPosts(pageKey);
    });
    super.initState();
  }

  Future<void> _loadPosts(int pageKey) async {
    var newPosts = await _userController.getPosts(page: pageKey, username: _user.username);
    if (newPosts.isNotEmpty) {
      _pageController.appendPage(newPosts, pageKey+1);
    } else {
      _pageController.appendLastPage([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: 100.0,
            constraints: const BoxConstraints(
              minHeight: 300.0,
            ),
            decoration: BoxDecoration(
              color: LightModeTheme().secondaryBackground,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeOutDuration: const Duration(milliseconds: 500),
                    imageUrl: _user.userBannerPicture ?? "",
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset("assets/banner_placeholder.jpg", fit: BoxFit.cover,),
                    errorWidget: (context, url, error) => Image.asset("assets/banner_placeholder.jpg", fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 170.0, 0.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: LightModeTheme().secondaryBackground,
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height:
                              MediaQuery.sizeOf(context).height *
                                  1.0,
                              decoration: const BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20.0, 10.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(
                                          0.0, 15.0, 0.0, 0.0),
                                      child: Text(
                                        _user.userCommonName,
                                        textAlign: TextAlign.start,
                                        style: TypographyTheme()
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Roboto',
                                          color: LightModeTheme()
                                              .primaryText,
                                          fontSize: 20.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '@${_user.username}',
                                      style: TypographyTheme()
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Roboto',
                                        color: const Color(0xFFEE8B60),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      _user.userBiography ?? "No biography...",
                                      style: TypographyTheme()
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          splashColor:
                                          Colors.transparent,
                                          focusColor:
                                          Colors.transparent,
                                          hoverColor:
                                          Colors.transparent,
                                          highlightColor:
                                          Colors.transparent,
                                          onTap: () async {
                                            // context.pushNamed(
                                            //   'AccountFollows',
                                            //   extra: <String, dynamic>{
                                            //     kTransitionInfoKey:
                                            //         TransitionInfo(
                                            //       hasTransition: true,
                                            //       transitionType:
                                            //           PageTransitionType
                                            //               .leftToRight,
                                            //     ),
                                            //   },
                                            // );
                                          },
                                          child: Text(
                                            '3 Following',
                                            style: TypographyTheme()
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              'Roboto',
                                              color: LightModeTheme()
                                                  .secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          splashColor:
                                          Colors.transparent,
                                          focusColor:
                                          Colors.transparent,
                                          hoverColor:
                                          Colors.transparent,
                                          highlightColor:
                                          Colors.transparent,
                                          onTap: () async {
                                            // context.pushNamed(
                                            //   'AccountFollows',
                                            //   extra: <String, dynamic>{
                                            //     kTransitionInfoKey:
                                            //         TransitionInfo(
                                            //       hasTransition: true,
                                            //       transitionType:
                                            //           PageTransitionType
                                            //               .leftToRight,
                                            //     ),
                                            //   },
                                            // );
                                          },
                                          child: Text(
                                            '2 Followers',
                                            style: TypographyTheme()
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              'Roboto',
                                              color: LightModeTheme()
                                                  .secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(width: 10.0)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height:
                              MediaQuery.sizeOf(context).height *
                                  1.0,
                              decoration: const BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 10.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ButtonWidget(
                                        onPressed: () {
                                          print('Button pressed ...');
                                        },
                                        text: 'Edit',
                                        options: ButtonOptions(
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(
                                              16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0,
                                              0.0, 0.0),
                                          color: LightModeTheme()
                                              .orangePeel,
                                          textStyle: TypographyTheme()
                                              .titleMedium
                                              .override(
                                            fontFamily:
                                            'Roboto',
                                            letterSpacing: 0.0,
                                          ),
                                          elevation: 0.0,
                                          borderRadius:
                                          BorderRadius.circular(
                                              24.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(
                                          0.0, 20.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Opacity(
                                            opacity: 0.5,
                                            child: Icon(
                                              Icons
                                                  .calendar_today_sharp,
                                              color: LightModeTheme()
                                                  .primaryText,
                                              size: 20.0,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(3.0, 0.0,
                                                5.0, 0.0),
                                            child: Text(
                                              'Joined',
                                              style: TypographyTheme()
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                'Roboto',
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0,
                                                15.0, 0.0),
                                            child: Text(
                                              'September 2024',
                                              style: TypographyTheme()
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                'Roboto',
                                                color:
                                                LightModeTheme()
                                                    .primaryText,
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 100.0, 0.0, 0.0),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                      errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeOutDuration: const Duration(milliseconds: 500),
                      imageUrl:
                      _user.userProfilePicture ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TabFilter(choices: ["posts", "likes"], active: _filter, onSelect: (choice) {
          setState(() {
            _filter = choice;
          });
        }),
        Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                    () => _pageController.refresh(),
              ),
              child: PagedListView(
                  pagingController: _pageController,
                  builderDelegate: PagedChildBuilderDelegate<PostModel>(
                      itemBuilder: (context, item, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: PostWidget(post: item, userController: _userController, allowViewPost: true,
                              onDelete: () {
                                _pageController.refresh();
                              },)
                        );
                      }
                  )
              ),
            )
        ),
      ],
    );
  }
}
