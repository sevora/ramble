import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import 'package:ramble_mobile/views/reusable/post_widget.dart';

import '../../models/post_model.dart';

class PostsListsWidget extends StatefulWidget {
  final UserController userController;
  final String? username;
  final String? parentId;
  final String? category;

  const PostsListsWidget({super.key, required this.userController, this.username, this.parentId, this.category});

  @override
  State<StatefulWidget> createState() => _PostsListsWidgetState();
}

class _PostsListsWidgetState extends State<PostsListsWidget> {
  late UserController _userController;
  late String? _username;
  late String? _parentId;
  late String? _category;

  final PagingController<int, PostModel> _listController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _userController = widget.userController;
    _username = widget.username;
    _parentId = widget.parentId;
    _category = widget.category;
    _listController.addPageRequestListener((pageKey) {
      _loadPosts(pageKey);
    });
    super.initState();
  }

  Future<void> _loadPosts(int pageKey) async {
    var newPosts = await _userController.getPosts(page: pageKey, username: _username, category: _category, parentId: _parentId);
    if (newPosts.isNotEmpty) {
      _listController.appendPage(newPosts, pageKey+1);
    } else {
      _listController.appendLastPage([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
        pagingController: _listController,
        builderDelegate: PagedChildBuilderDelegate<PostModel>(
            itemBuilder: (context, item, index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: PostWidget(post: item, userController: _userController)
              );
            }
        )
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }
}