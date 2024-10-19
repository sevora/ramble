import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/models/post_model.dart';
import '../../controllers/user_controller.dart';
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
  final PagingController<int, PostModel> _page = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _controller = widget.controller;
    _page.addPageRequestListener((pageKey) {
      _loadPosts(pageKey);
    });
    super.initState();
  }

  Future<void> _loadPosts(int pageKey) async {
    var newPosts = await _controller.getPosts(page: pageKey, category: "trending");
    if (newPosts.isNotEmpty) {
      _page.appendPage(newPosts, pageKey+1);
    } else {
      _page.appendLastPage([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
          child: PostCreatorWidget(prompt: "What's new?", controller: _controller,
            onPost: () async {
              _page.refresh();
            }
          )
        ),
        Expanded(
          child: PagedListView(
              pagingController: _page,
              builderDelegate: PagedChildBuilderDelegate<PostModel>(
                  itemBuilder: (context, item, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: PostWidget(post: item, controller: _controller)
                    );
                  }
              )
          )
        ),
      ],
    );
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }
}
