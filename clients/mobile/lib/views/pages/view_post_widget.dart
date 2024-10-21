import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/views/pages/base_widget.dart';
import '../../controllers/user_controller.dart';
import '../../models/post_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../reusable/post_widget.dart';
import '../reusable/ramble_icon_button.dart';
import '../reusable/post_creator_widget.dart';


class ViewPostWidget extends StatefulWidget {
  final UserController userController;
  final PostModel post;
  final BaseController baseController;

  const ViewPostWidget({super.key, required this.userController, required this.post, required this.baseController});

  @override
  State<StatefulWidget> createState() => _ViewPostWidgetState();
}

class _ViewPostWidgetState extends State<ViewPostWidget> {
  late UserController _userController;
  late PostModel _post;
  // List<PostModel> _comments = [];
  final PagingController<int, PostModel> _pageController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _userController = widget.userController;
    _post = widget.post;
    _pageController.addPageRequestListener((pageKey) {
      _loadPosts(pageKey);
    });
    super.initState();
  }

  Future<void> _loadPosts(int pageKey) async {
    var newPosts = await _userController.getPosts(page: pageKey, parentId: _post.postId);
    if (newPosts.isNotEmpty) {
      _pageController.appendPage(newPosts, pageKey+1);
    } else {
      _pageController.appendLastPage([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          borderRadius: BorderRadius.circular(6.0),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 10.0),
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
                      widget.baseController.pop();
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
              PostWidget(post: _post, userController: _userController, onDelete: () {
                widget.baseController.pop();
              }, baseController: widget.baseController,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: PostCreatorWidget(
                  prompt: 'Share your thoughts...',
                  controller: _userController,
                  post: _post,
                  onPost: () {
                    _pageController.refresh();
                  },
                ),
              ),
      
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: PagedListView(
                    pagingController: _pageController,
                    builderDelegate: PagedChildBuilderDelegate<PostModel>(
                        itemBuilder: (context, item, index) {
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: PostWidget(post: item, userController: _userController, allowViewPost: true, onDelete: () {
                                _pageController.refresh();
                              }, baseController: widget.baseController)
                          );
                        }
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}