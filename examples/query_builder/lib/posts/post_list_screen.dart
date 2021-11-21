import 'package:flutter/material.dart';
import 'package:query_builder/jokes/joke.screen.dart';

import 'post_model/post_model.dart';

class PostListScreen extends StatefulWidget {
  static const routeName = '/';
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('posts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.create),
            onPressed: () {
              const post = PostModel(
                id: 1234,
                title: "new post",
                userId: 1,
                body: 'this is the body of the post',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, JokeScreen.routeName),
          )
        ],
      ),
      body: SizedBox(),
      // body: BlocBuilder<PostBloc, PostState>(
      //   builder: (context, state) {
      //     if (state.posts != null) {
      //       return CustomScrollView(
      //         controller: _scrollController,
      //         slivers: [
      //           SliverList(
      //             delegate: SliverChildBuilderDelegate(
      //                 (context, i) => _Post(
      //                       post: state.posts![i],
      //                       index: i,
      //                     ),
      //                 childCount: state.posts!.length),
      //           ),
      //           if (state.status == PostStatus.loading)
      //             const SliverToBoxAdapter(
      //               child: Center(
      //                 child: SizedBox(
      //                   height: 40,
      //                   width: 40,
      //                   child: CircularProgressIndicator(),
      //                 ),
      //               ),
      //             ),
      //           SliverPadding(
      //             padding: EdgeInsets.only(
      //                 bottom: MediaQuery.of(context).padding.bottom),
      //           )
      //         ],
      //       );
      //     }
      //     if (state.status == PostStatus.loading) {
      //       return const Center(
      //         child: SizedBox(
      //           height: 40,
      //           width: 40,
      //           child: CircularProgressIndicator(),
      //         ),
      //       );
      //     }
      //     return const Text("no posts found");
      //   },
      // ),
    );
  }

  void _onScroll() {
    // if (_isBottom) context.read<PostBloc>().add(PostsStreamNextPage());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}

class _Post extends StatelessWidget {
  final PostModel post;
  final int index;

  const _Post({Key? key, required this.post, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(index.toString()),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(post.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
