import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import 'package:ramble_mobile/models/follow_model.dart';
import 'package:ramble_mobile/views/pages/base_widget.dart';
import '../../models/user_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/button.dart';
import '../pages/view_profile_widget.dart';

class MiniProfileWidget extends StatefulWidget {
  const MiniProfileWidget({
    super.key,
    required this.user,
    required this.userController,
    required this.baseController
  });

  final UserModel user;
  final UserController userController;
  final BaseController baseController;
  @override
  State<MiniProfileWidget> createState() => _MiniProfileWidgetState();
}

class _MiniProfileWidgetState extends State<MiniProfileWidget> {
  late UserModel _user;
  late UserController _userController;

  FollowModel _follow = FollowModel.named(isFollower: false, isFollowing: false, followerCount: 0, followCount: 0);

  @override
  void initState() {
    _user = widget.user;
    _userController = widget.userController;
    _loadFollow();
    super.initState();
  }

  Future<void> _loadFollow() async {
    var updatedFollow = await _userController.getFollowContextStatistics(username: _user.username);

    setState(() {
      _follow = updatedFollow;
    });
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
              0.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                onTap: () async {
                  widget.baseController.push(ViewProfileWidget(userController: _userController, user: _user, baseController: widget.baseController, key: Key(_user.username)));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                          errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeOutDuration: const Duration(milliseconds: 500),
                          imageUrl: _user.userProfilePicture ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user.userCommonName,
                            style:
                                TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Text(
                            _user.username,
                            style:
                                TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ].divide(const SizedBox(width: 10.0)),
                  ),
                ),
                if (_userController.user.username != _user.username)
                ButtonWidget(
                  onPressed: () async {
                    if (_follow.isFollowing) {
                      await _userController.unfollowAccount(username: _user.username);
                    } else {
                      await _userController.followAccount(username: _user.username);
                    }

                    await _loadFollow();
                  },
                  text: _follow.isFollowing ? 'Unfollow' : 'Follow',
                  options: ButtonOptions(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: _follow.isFollowing
                        ? LightModeTheme().orangePeel
                        : LightModeTheme().secondaryBackground,
                    textStyle: TypographyTheme().titleSmall.override(
                          fontFamily: 'Roboto',
                          color: _follow.isFollowing
                              ? Colors.white
                              : LightModeTheme().orangePeel,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: LightModeTheme().orangePeel,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              if (_user.userBiography != null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                      child: Text(
                        _user.userBiography!,
                        maxLines: 3,
                        style: TypographyTheme().bodyMedium.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 0.0,
                  height: 0.0,
                  decoration: BoxDecoration(
                    color: LightModeTheme().secondaryBackground,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}