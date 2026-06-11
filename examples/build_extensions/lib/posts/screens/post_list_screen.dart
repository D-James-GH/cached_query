import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:build_extensions/posts/services/post_service.dart' as service;
import '../../jokes/screens/joke_screen.dart';
import '../widgets/post_list_item.dart';
import '../post_model/post_model.dart';

class PostListScreen extends StatefulWidget {
  static const routeName = '/';

  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    service.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _Title(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => service.getPosts().refetch(),
          ),
          MutationBuilder<PostModel, PostModel>(
            mutation: service.createPost(),
            builder: (context, state, mutate) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (state.isLoading)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  IconButton(
                    icon: const Icon(Icons.create),
                    onPressed: () => mutate(
                      const PostModel(
                        id: 1234,
                        title: "new post",
                        userId: 1,
                        body: 'this is the body of the post',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, JokeScreen.routeName),
          ),
        ],
      ),
      body: Builder(
        builder: (state) {
          final state =
              context.watchInfiniteQuery<List<PostModel>, int>(key: "posts");
          if (state.data != null && state.data!.pages.isNotEmpty) {
            final allPosts = state.data!.pages.expand((e) => e).toList();

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state is InfiniteQueryError &&
                    (state as InfiniteQueryError).error is SocketException)
                  SliverToBoxAdapter(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text(
                        "No internet connection",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (state.isError &&
                    (state as InfiniteQueryError).error is! SocketException)
                  SliverToBoxAdapter(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(
                        "Error: ${(state as InfiniteQueryError).error}",
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: MutationBuilder<PostModel, PostModel>(
                    mutation: service.createPost(),
                    builder: (context, state, _) {
                      if (state.isLoading) {
                        return Container(
                          color: Colors.teal,
                          child: const Text(
                            "This will show when the mutation is loading.",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => PostListItem(
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
                ),
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
      ),
    );
  }

  void _onScroll() {
    final query = service.getPosts();
    if (_isBottom && !query.state.isLoading) {
      query.getNextPage();
    }
    if (_isTop && !query.state.isLoading && query.hasPreviousPage()) {
      query.getPreviousPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    return currentScroll < 10;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final state =
        context.watchInfiniteQuery<List<PostModel>, int>(key: "posts");
    return Row(
      children: [
        if (state.isLoading)
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        const Text('posts'),
      ],
    );
  }
}
