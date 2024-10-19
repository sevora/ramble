import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/button.dart';
import '../reusable/post_widget.dart';

class ViewProfileWidget extends StatelessWidget {
  final UserController _controller;
  const ViewProfileWidget({super.key, required controller}):
    _controller = controller;

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
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeOutDuration: const Duration(milliseconds: 500),
                    imageUrl: 'https://picsum.photos/seed/296/600',
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 150.0, 0.0, 0.0),
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
                                        'User',
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
                                      '@userTag',
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
                                      'More about me...',
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
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeOutDuration: const Duration(milliseconds: 500),
                      imageUrl:
                      'https://images.unsplash.com/photo-1517242027094-631f8c218a0f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxsZWdvfGVufDB8fHx8MTcyNTUyNTYwMnww&ixlib=rb-4.0.3&q=80&w=1080',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          decoration: const BoxDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: LightModeTheme().secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Posts',
                          textAlign: TextAlign.center,
                          style: TypographyTheme().bodyMedium.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              LightModeTheme().orangePeel,
                              LightModeTheme().orangePeel
                            ],
                            stops: const [0.0, 1.0],
                            begin: const AlignmentDirectional(0.0, -1.0),
                            end: const AlignmentDirectional(0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: LightModeTheme().secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Likes',
                          textAlign: TextAlign.center,
                          style: TypographyTheme().bodyMedium.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          color: LightModeTheme().secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(),
          child: ListView(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              PostWidget(
                userName: '@felix',
                displayName: 'Fix it Felix',
                imageURL: 'https://picsum.photos/seed/632/600',
                content:
                'So this building, yeah I made it. Yeah I did.',
                isLiked: true,
                likeCount: 2,
                profileImageURL:
                'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c7e58dd8-1dd0-4b5e-aac2-307db078977a/d5i4hk9-1751eb66-6fb6-46be-9493-58fe2cb797ca.jpg/v1/fill/w_700,h_700,q_75,strp/fix_it_felix_portrait_by_estefanoida_d5i4hk9-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzAwIiwicGF0aCI6IlwvZlwvYzdlNThkZDgtMWRkMC00YjVlLWFhYzItMzA3ZGIwNzg5NzdhXC9kNWk0aGs5LTE3NTFlYjY2LTZmYjYtNDZiZS05NDkzLTU4ZmUyY2I3OTdjYS5qcGciLCJ3aWR0aCI6Ijw9NzAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.tAjFRcXDR20PmoCPGVgjWoNba3dNICjgGkh7nuoAhXo',
                controller: _controller,
              ),
              PostWidget(
                isLiked: true,
                controller: _controller,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
