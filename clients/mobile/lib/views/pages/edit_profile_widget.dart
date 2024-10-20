import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:ramble_mobile/views/pages/base_widget.dart';
import 'package:ramble_mobile/views/pages/following_widget.dart';
import 'package:ramble_mobile/views/reusable/tab_filter.dart';
import '../../controllers/user_controller.dart';
import '../../models/follow_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/button.dart';
import '../reusable/post_widget.dart';
import 'loading_screen.dart';

class EditProfileWidget extends StatefulWidget {
  final UserController userController;
  final BaseController baseController;
  const EditProfileWidget({super.key, required this.userController, required this.baseController});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late UserController _userController;

  final _picker = ImagePicker();
  late String _userCommonName;
  late String _biography;
  File? _profilePicture;
  File? _bannerPicture;

  Future<void> _openProfileImage() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profilePicture = File(pickedImage.path);
      });
    }
  }

  Future<void> _openBannerImage() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _bannerPicture = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    _userController = widget.userController;
    _userCommonName = widget.userController.user.userCommonName;
    _biography = widget.userController.user.userBiography ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
            () async {

            },
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                constraints: const BoxConstraints(
                  minHeight: 300.0,
                ),
                decoration: BoxDecoration(
                  color: LightModeTheme().secondaryBackground,
                ),
                child: InkWell(
                  onTap: () {
                    _openBannerImage();
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        child:  _bannerPicture != null ? Image.file(_bannerPicture!, fit: BoxFit.cover) : CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeOutDuration: const Duration(milliseconds: 500),
                          imageUrl: _userController.user.userBannerPicture ?? "",
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
                                          child: TextFormField(
                                            onChanged: (text) {
                                              setState(() {
                                                _userCommonName = text;
                                              });
                                            },
                                            initialValue: _userCommonName,
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
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle: TypographyTheme().labelMedium,
                                              hintText: "",
                                              hintStyle: TypographyTheme().labelMedium,

                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 1.0),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
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
                                          ),
                                        ),
                                        Text(
                                          '@${_userController.user.username}',
                                          style: TypographyTheme()
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Roboto',
                                            color: const Color(0xFFEE8B60),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        TextFormField(
                                          onChanged: (text) {
                                            setState(() {
                                              _biography = text;
                                            });
                                          },
                                          initialValue: _biography,
                                          style: TypographyTheme()
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.0,
                                          ),
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle: TypographyTheme().labelMedium,
                                            hintText: "Enter biography here",
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
                                        ),

                                      ],
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
                                                      2.0, 0.0),
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
                                                    DateFormat("MMMM yyyy").format(_userController.user.userCreatedAt),
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
                        child: InkWell(
                          onTap: () {
                            _openProfileImage();
                          },
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: _profilePicture != null ? Image.file(_profilePicture!, fit: BoxFit.cover) :
                            CachedNetworkImage(
                              placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                              errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration: const Duration(milliseconds: 500),
                              imageUrl:
                              _userController.user.userProfilePicture ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
        
                      Row(
                        children: [
                          Spacer(),
                          ButtonWidget(
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadingScreen()));
                              await _userController.updateAccount(
                                  userCommonName: _userCommonName,
                                  biography: _biography,
                                  profilePicture: _profilePicture,
                                  bannerPicture: _bannerPicture
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                widget.baseController.pop();
                              }
                            },
                            text: 'Save',
                            options: ButtonOptions(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                              iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: LightModeTheme().orangePeel,
                              textStyle: TypographyTheme().titleSmall.override(
                                fontFamily: 'Roboto',
                                color:  Colors.white,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: LightModeTheme().orangePeel,
                              ),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
        
                          SizedBox(
                            width: 5,
                          ),
                          ButtonWidget(
                            onPressed: () async {
                              widget.baseController.pop();
                            },
                            text: 'Cancel',
                            options: ButtonOptions(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                              iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: Colors.white,
                              textStyle: TypographyTheme().titleSmall.override(
                                fontFamily: 'Roboto',
                                color:  LightModeTheme().orangePeel,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: LightModeTheme().orangePeel,
                              ),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
