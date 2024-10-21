import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import 'package:ramble_mobile/utilities/time_ago.dart';
import 'package:ramble_mobile/views/pages/base_widget.dart';
import 'package:ramble_mobile/views/pages/view_profile_widget.dart';
import '../../models/post_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/button.dart';
import '../../views/reusable/ramble_icon_button.dart';
import '../pages/view_post_widget.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final UserController userController;
  final bool allowViewPost;
  final Function()? onDelete;
  final BaseController baseController;

  const PostWidget({
    super.key,
    required this.post,
    required this.userController,
    this.allowViewPost=false,
    this.onDelete,
    required this.baseController
  });

  @override
  State<StatefulWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late PostModel _post;
  late UserController _userController;
  late bool _allowViewPost;

  Future<void> _toggleLike() async {
    if (_post.hasLiked) {
      await _userController.dislikePost(postId: _post.postId);
    } else {
      await _userController.likePost(postId: _post.postId);
    }

    var updatedPost = await _userController.viewPost(postId: _post.postId);
    setState(() {
      _post = updatedPost;
    });
  }

  @override
  void initState() {
    _post = widget.post;
    _userController = widget.userController;
    _allowViewPost = widget.allowViewPost;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: LightModeTheme().secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                var user = await _userController.getUser(username: _post.username);
                widget.baseController.push(ViewProfileWidget(userController: _userController, user: user, baseController: widget.baseController, key: Key(user.username)));
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 46.0,
                    height: 46.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeOutDuration: const Duration(milliseconds: 500),
                      imageUrl: _post.userProfilePicture ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                      errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _post.userCommonName,
                                  style: TypographyTheme().bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                    '@${_post.username}',
                                  style: TypographyTheme().bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                            Opacity(
                              opacity: 0.8,
                              child: Text(
                                timeAgo(_post.postCreatedAt),
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ].divide(const SizedBox(width: 10.0)),
                        ),
                      ),
                    ),
                  ),
                ].divide(const SizedBox(width: 10.0)),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (_allowViewPost) {
                  widget.baseController.push(ViewPostWidget(key: Key(_post.postId), post: _post, userController: _userController,baseController: widget.baseController));
                  }
                },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 15.0, 0.0, 10.0),
                      child: Text(
                        _post.postContent,
                        maxLines: 3,
                        style: TypographyTheme().bodyMedium.override(
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),

                  if (_post.postMedia != null)
                    FullScreenWidget(
                      disposeLevel: DisposeLevel.High,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Image.asset("assets/banner_placeholder.jpg"),
                            errorWidget: (context, url, error) => Image.asset("assets/banner_placeholder.jpg"),
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 500),
                            imageUrl: _post.postMedia!,
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      if (_post.hasLiked) {
                        return ButtonWidget(
                          onPressed: () {
                            _toggleLike();
                          },
                          text: formatNumber(
                            _post.likeCount,
                            formatType: FormatType.compact,
                          ),
                          icon: const Icon(
                            Icons.favorite_sharp,
                            size: 22.0,
                          ),
                          options: ButtonOptions(
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: LightModeTheme().secondaryBackground,
                            textStyle: TypographyTheme().titleSmall.override(
                                  fontFamily: 'Roboto',
                                  color: _post.hasLiked
                                      ? LightModeTheme().orangePeel
                                      : LightModeTheme().primaryText,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        );
                      } else {
                        return ButtonWidget(
                          onPressed: () {
                            _toggleLike();
                          },
                          text: formatNumber(
                            _post.likeCount,
                            formatType: FormatType.compact,
                          ),
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 22.0,
                          ),
                          options: ButtonOptions(
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: LightModeTheme().secondaryBackground,
                            textStyle: TypographyTheme().titleSmall.override(
                                  fontFamily: 'Roboto',
                                  color: LightModeTheme().primaryText,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        );
                      }
                    },
                  ),
                  ButtonWidget(
                    onPressed: () {
                      if (_allowViewPost) {
                        widget.baseController.push(ViewPostWidget(key: Key(_post.postId), post: _post, userController: _userController,baseController: widget.baseController));
                      }
                    },
                    text: formatNumber(
                      _post.replyCount,
                      formatType: FormatType.compact,
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.comment,
                      size: 22.0,
                    ),
                    options: ButtonOptions(
                      height: 40.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: const Color(0x00F1F4F8),
                      textStyle: TypographyTheme().titleSmall.override(
                            fontFamily: 'Roboto',
                            color: LightModeTheme().primaryText,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  if (_post.username == _userController.user.username)
                    RambleIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.delete_outline,
                        color: LightModeTheme().primaryText,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        var success = await _userController.deletePost(postId: _post.postId);
                        if (success && widget.onDelete != null) {
                          widget.onDelete!();
                        }
                      },
                    ),
                ].divide(const SizedBox(width: 5.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
