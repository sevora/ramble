import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import '../../themes/typography_theme.dart';
import '../../themes/light_mode_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/ramble_icon_button.dart';

class PostCreatorWidget extends StatefulWidget {
  final String prompt;
  final UserController controller;
  final Function()? onPost;

  const PostCreatorWidget({super.key, required this.prompt, required this.controller, this.onPost });

  @override
  State<StatefulWidget> createState() => _PostCreatorWidgetState();
}

class _PostCreatorWidgetState extends State<PostCreatorWidget> {
  late String _prompt;
  late UserController _controller;
  String _content = "";
  final fieldText = TextEditingController();

  @override
  void initState() {
    _prompt = widget.prompt;
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
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
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  imageUrl: _controller.user.userProfilePicture ?? '',
                  placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                  errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        child: TextFormField(
                          controller: fieldText,
                          onChanged: (text) {
                            setState(() {
                              _content = text;
                            });
                          },
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: TypographyTheme().labelMedium,
                              hintText: _prompt,
                              hintStyle: TypographyTheme().labelMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.0),
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
                            cursorColor: LightModeTheme().primaryText),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RambleIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.image_outlined,
                                color: LightModeTheme().primaryText,
                                size: 24.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                            RambleIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.send,
                                color: LightModeTheme().primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                // make a post
                                var success = await _controller.createPost(content: _content);

                                if (success && widget.onPost != null) {
                                  widget.onPost!();
                                }

                                setState(() {
                                  _content = "";
                                  fieldText.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ].divide(const SizedBox(width: 5.0)),
          ),
        ),
      ),
    );
  }
}
