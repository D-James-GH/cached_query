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
        title: QueryBuilder<InfiniteQueryStatus<dynamic, dynamic>>(
          queryKey: 'posts',
          builder: (context, state) {
            return Row(
              children: [
                if (state.isLoading)
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
      body: QueryBuilder<InfiniteQueryStatus<List<PostModel>, int>>(
          query: getPosts(),
          builder: (context, state) {
            final allPosts = state.data?.expand((e) => e).toList();
            final error = switch (state) {
              InfiniteQueryError(:final error) => error,
              _ => null,
            };
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state is InfiniteQueryError)
                  SliverToBoxAdapter(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error),
                      child: Text(
                        error is SocketException
                            ? "No internet connection"
                            : error.toString(),
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
                if (state.isLoading)
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
    if (_isBottom && !query.state.isLoading) {
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
