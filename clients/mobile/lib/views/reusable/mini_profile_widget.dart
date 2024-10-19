import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/button.dart';

class MiniProfileWidget extends StatelessWidget {
  const MiniProfileWidget({
    super.key,
    String? displayName,
    String? userName,
    bool? isFollowing,
    String? biography,
    String? profileImageURL,
    required controller,
  })  : _biography = biography, _isFollowing = isFollowing, _displayName = displayName ?? 'Unknown User',
        _userName = userName ?? '@unknown',
        _profileImageURL = profileImageURL ??
            'https://static.vecteezy.com/system/resources/previews/001/840/618/original/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg',
        _controller = controller;

  final String _displayName;
  final String _userName;
  final bool? _isFollowing;
  final String? _biography;
  final String _profileImageURL;
  final UserController _controller;

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
                Row(
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
                        imageUrl: _profileImageURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayName,
                          style:
                              TypographyTheme().bodyMedium.override(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          _userName,
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
                ButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Follow',
                  options: ButtonOptions(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: _isFollowing!
                        ? LightModeTheme().orangePeel
                        : LightModeTheme().secondaryBackground,
                    textStyle: TypographyTheme().titleSmall.override(
                          fontFamily: 'Roboto',
                          color: _isFollowing
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
              if (_biography != null && _biography != '') {
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
                        valueOrDefault<String>(
                          _biography,
                          'Lorem Ipsum',
                        ),
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