import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import 'package:ramble_mobile/models/post_model.dart';
import '../../themes/typography_theme.dart';
import '../../themes/light_mode_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/ramble_icon_button.dart';

class PostCreatorWidget extends StatefulWidget {
  final String prompt;
  final UserController controller;
  final PostModel? post;
  final Function()? onPost;

  const PostCreatorWidget({super.key, required this.prompt, required this.controller, this.post, this.onPost });

  @override
  State<StatefulWidget> createState() => _PostCreatorWidgetState();
}

class _PostCreatorWidgetState extends State<PostCreatorWidget> {
  late String _prompt;
  late UserController _controller;
  String _content = "";
  PostModel? _post;

  File? _image;
  final _picker = ImagePicker();
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _buffering = false;

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _formKey.currentState?.reset();
      });
    }
  }

  @override
  void initState() {
    _prompt = widget.prompt;
    _controller = widget.controller;
    _post = widget.post;
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child:
      Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
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
                    fit: BoxFit.cover,
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
                            controller: _textController,
                              validator:  (text) {
                                if ((text == null || text.isEmpty) && _image == null) {
                                  return 'Please provide something to post.';
                                } else if (text != null && text.length > 200) {
                                  return 'Text cannot be greater than 200 characters.';
                                }
                                return null;
                              },
                            onChanged: (text) {
                              setState(() {
                                _content = text;
                              });
                            },
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                labelStyle: TypographyTheme().labelMedium,
                                hintText: _prompt,
                                hintStyle: TypographyTheme().labelMedium,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: InputBorder.none,
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

                        if (_buffering)
                          CircularProgressIndicator(
                          color: LightModeTheme().orangePeel,
                          backgroundColor: LightModeTheme().primaryBackground,
                        ),

                        if (!_buffering)
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
                                  _openImagePicker();
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
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _buffering = true;
                                    });
                                    // make a post
                                    var success = await _controller.createPost(content: _content, parentId: _post?.postId, image: _image);

                                    if (success && widget.onPost != null) {
                                      widget.onPost!();
                                    }

                                    setState(() {
                                      _content = "";
                                      _image = null;
                                      _textController.clear();
                                      _buffering = false;
                                    });
                                  }
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
            if (_image != null && !_buffering)
              SizedBox(
                  height: 200,
                  child: Stack(children: [
                    Image.file(_image!),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder()
                      ),
                        child: Icon(Icons.close,
                          color: LightModeTheme().primaryText,
                          size: 24.0
                        )
                    )
                  ])
              ),
        ]
        ),
      ),
    );
  }
}
