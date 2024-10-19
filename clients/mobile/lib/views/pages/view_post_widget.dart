import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/user_controller.dart';
import '../../models/post_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/ramble_icon_button.dart';
import '../reusable/post_creator_widget.dart';


class ViewPostWidget extends StatelessWidget {
  final UserController _controller;
  final PostModel _post;
  const ViewPostWidget({super.key, required controller, required post}):
      _post = post,
       _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Align(
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
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
            borderRadius: BorderRadius.circular(6.0),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      RambleIconButton(
                        borderRadius: 8.0,
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: LightModeTheme().primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Post',
                        style: TypographyTheme()
                            .titleLarge
                            .override(
                          fontFamily: 'Roboto',
                          letterSpacing: 0.0,
                        ),
                      ),
                    ].divide(const SizedBox(width: 10.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                fadeInDuration: const Duration(milliseconds: 500),
                                fadeOutDuration:
                                const Duration(milliseconds: 500),
                                imageUrl: _post.userProfilePicture ?? "",
                                placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                                errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _post.userCommonName,
                                  style: TypographyTheme()
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Align(
                                  alignment:
                                  const AlignmentDirectional(-1.0, 0.0),
                                  child: Text(
                                    '@${_post.username}',
                                    style: TypographyTheme()
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ].divide(const SizedBox(width: 10.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(-1.0, 0.0),
                              child: Text(
                                _post.postContent,
                                style: TypographyTheme()
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            if (_post.postMedia != null)
                              Container(
                              decoration: BoxDecoration(
                                color: LightModeTheme()
                                    .secondaryText,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: _post.postMedia ?? '',
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(height: 10.0)),
                        ),
                      ].divide(const SizedBox(height: 15.0)),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RambleIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.favorite_border,
                            color: LightModeTheme().primaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                        RambleIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.keyboard_control,
                            color: LightModeTheme().primaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2.0,
                    color: LightModeTheme().alternate,
                  ),
                  PostCreatorWidget(
                    prompt: 'Share your thoughts...',
                    controller: _controller,
                  ),
                ].divide(const SizedBox(height: 5.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}