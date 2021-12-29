import 'dart:io';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:query_builder/jokes/joke.screen.dart';
import 'package:query_builder/posts/post_service.dart';

import 'post_model/post_model.dart';

class PostListScreen extends StatefulWidget {
  static const routeName = '/';
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _scrollController = ScrollController();
  final _postService = PostService();

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
              _postService.createPost(const PostModel(
                id: 1234,
                title: "new post",
                userId: 1,
                body: 'this is the body of the post',
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, JokeScreen.routeName),
          )
        ],
      ),
      body: InfiniteQueryBuilder<List<PostModel>, int>(
        query: _postService.getPosts(),
        builder: (context, state, query) {
          if (state.data.isNotEmpty) {
            final allPosts = state.data.expand((e) => e).toList();

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state.status == QueryStatus.error &&
                    state.error is SocketException)
                  SliverToBoxAdapter(
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).errorColor),
                      child: const Text(
                        "No internet connection",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, i) => _Post(
                            post: allPosts[i],
                            index: i,
                          ),
                      childCount: allPosts.length),
                ),
                if (state.isFetching)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                )
              ],
            );
          }
          if (state.isFetching) {
            return const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Text("no posts found");
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) _postService.getPosts().getNextPage();
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
