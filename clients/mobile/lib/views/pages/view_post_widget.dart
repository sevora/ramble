import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/ramble_icon_button.dart';
import '../reusable/post_creator_widget.dart';


class ViewPostWidget extends StatelessWidget {
  const ViewPostWidget({super.key});

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
                                imageUrl:
                                'https://images.unsplash.com/photo-1517242027094-631f8c218a0f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxsZWdvfGVufDB8fHx8MTcyNTUyNTYwMnww&ixlib=rb-4.0.3&q=80&w=1080',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User A',
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
                                    '@user_a',
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
                                'Lorem ipsum odor amet, consectetuer adipiscing elit. Montes quisque sem pulvinar fames; luctus tristique. Varius dictumst fringilla imperdiet primis primis. Ligula vehicula dictum potenti cursus sapien. Laoreet egestas feugiat morbi mauris felis scelerisque netus ex. Tincidunt parturient dictumst lacus felis placerat congue laoreet enim. Primis imperdiet mattis sem platea diam hendrerit eros. Mauris velit tempor inceptos interdum ut condimentum pulvinar? Iaculis libero morbi adipiscing nam consectetur vestibulum posuere.',
                                style: TypographyTheme()
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: LightModeTheme()
                                    .secondaryText,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/sample-thumbnail.jpg',
                                  width: MediaQuery.sizeOf(context).width *
                                      1.0,
                                  fit: BoxFit.contain,
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
                  const PostCreatorWidget(
                    prompt: 'Share your thoughts...',
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