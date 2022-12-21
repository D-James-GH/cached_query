import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_list/posts/post_service.dart';
import 'package:infinite_list/posts/view/post.dart';

import '../post_model/post_model.dart';

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
        title: InfiniteQueryBuilder(
          queryKey: 'posts',
          builder: (context, state, _) {
            return Row(
              children: [
                if (state.status == QueryStatus.loading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                const Text('posts'),
              ],
            );
          },
        ),
        centerTitle: true,
      ),
      body: InfiniteQueryBuilder<List<PostModel>, int>(
          query: getPosts(),
          builder: (context, state, query) {
            final allPosts = state.data?.expand((e) => e).toList();
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state.status == QueryStatus.error)
                  SliverToBoxAdapter(
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: Theme.of(context).errorColor),
                      child: Text(
                        state.error is SocketException
                            ? "No internet connection"
                            : state.error.toString(),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (allPosts != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Post(
                        post: allPosts[i],
                        index: i,
                      ),
                      childCount: allPosts.length,
                    ),
                  ),
                if (state.status == QueryStatus.loading)
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
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                )
              ],
            );
          }),
    );
  }

  void _onScroll() {
    final query = getPosts();
    if (_isBottom && query.state.status != QueryStatus.loading) {
      query.getNextPage();
    }
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
