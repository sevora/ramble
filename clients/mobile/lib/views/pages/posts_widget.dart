import 'package:flutter/material.dart';

import '../../controllers/user_controller.dart';
import '../../themes/light_mode_theme.dart';
import '../../utilities/utilities.dart';

import '../reusable/post_widget.dart';
import '../reusable/post_creator_widget.dart';

class PostsWidget extends StatelessWidget {
  final UserController _controller;
  const PostsWidget({super.key, required controller }):
      _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
          child: PostCreatorWidget(controller: _controller)
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          decoration: BoxDecoration(
            color: LightModeTheme().secondaryBackground,
          ),
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: ListView(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                PostWidget(
                  userName: '@goodcat',
                  displayName: 'Smirkly',
                  imageURL:
                      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
                  content:
                      'Meow meow meow meow, meow, meow, meow meow meow. Meow meow meow meow.',
                  isLiked: true,
                  likeCount: 350,
                  commentCount: 20,
                  profileImageURL: 'https://i.imgflip.com/5qke6k.jpg',
                  controller: _controller,
                ),
                PostWidget(
                  userName: '@not_a_user',
                  displayName: 'Le Placeholder',
                  imageURL: 'https://picsum.photos/seed/632/600',
                  isLiked: false,
                  likeCount: 120,
                  commentCount: 10,
                  controller: _controller,
                ),
                PostWidget(
                  userName: '@fortnite_lover',
                  displayName: 'Victory Royale',
                  content:
                      'Number 1. Victory Royale,\nYeah Fortnite we bout to get down (get down)',
                  isLiked: false,
                  likeCount: 420,
                  commentCount: 50,
                  profileImageURL:
                      'https://th.bing.com/th/id/OIP.Bcxd6Lke-5RdH42mY-6uewAAAA?rs=1&pid=ImgDetMain',
                  controller: _controller,
                ),
                Divider(
                  thickness: 2.0,
                  color: LightModeTheme().alternate,
                ),
              ].divide(const SizedBox(height: 10.0)),
            ),
          ),
        ),
      ],
    );
  }
}
