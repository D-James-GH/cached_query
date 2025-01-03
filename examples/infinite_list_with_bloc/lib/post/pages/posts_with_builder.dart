import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list_with_bloc/post/blocs/post_with_builder/post_with_builder_bloc.dart';
import 'package:infinite_list_with_bloc/post/pages/post_list_page.dart';

import '../models/post_model.dart';
import '../widgets/post.dart';

class PostListWithBuilderPage extends StatelessWidget {
  static const routeName = 'postWithBuilderList';
  const PostListWithBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostWithBuilderBloc()..add(PostsWithBuilderFetched()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Posts With Builder"),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_right_alt),
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                PostListPage.routeName,
              ),
            )
          ],
        ),
        body: const _List(),
      ),
    );
  }
}

class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostWithBuilderBloc, PostWithBuilderState>(
      builder: (context, state) {
        if (state is PostWithBuilderSuccess) {
          return QueryBuilder<InfiniteQueryStatus<List<PostModel>, int>>(
            query: state.postQuery,
            builder: (context, state) {
              if (state.data != null && state.data!.isNotEmpty) {
                final allPosts = state.data!.expand((e) => e).toList();
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (state.isError &&
                        (state as InfiniteQueryError).error is SocketException)
                      SliverToBoxAdapter(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error),
                          child: const Text(
                            "No internet connection",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Post(post: allPosts[i]),
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
              }
              if (state.isLoading) {
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
          );
        }
        return const Text("No query");
      },
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostWithBuilderBloc>().add(PostsWithBuilderNextPage());
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
