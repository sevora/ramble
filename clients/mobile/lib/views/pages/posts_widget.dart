import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/models/post_model.dart';
import '../../controllers/user_controller.dart';
import '../../themes/light_mode_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/post_widget.dart';
import '../reusable/post_creator_widget.dart';

class PostsWidget extends StatefulWidget {
  final UserController controller;
  const PostsWidget({super.key, required this.controller });

  @override
  State<StatefulWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  late UserController _controller;
  List<PostModel> posts = [];

  //final PagingController<int, PostModel> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _controller = widget.controller;
    _loadPosts(0);
    // _pagingController.addPageRequestListener((pageKey) {
    //   _loadPosts(pageKey);
    // });
    super.initState();
  }

  Future<void> _loadPosts(int pageKey) async {
    var newPosts = await _controller.getPosts(page: pageKey, category: "trending");
    setState(() {
      posts = newPosts;
    });
    // _pagingController.appendPage(newPosts, pageKey+1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
          child: PostCreatorWidget(prompt: "What's new?", controller: _controller,
            onPost: () async {
              await _loadPosts(0);
            }
          )
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
                var post = posts[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: PostWidget(
                      key: Key(post.postId),
                      post: post,
                      controller: _controller
                  ),
                );
            },
          ),
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   _pagingController.dispose();
  //   super.dispose();
  // }
}
