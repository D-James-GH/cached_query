import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:query_builder/jokes/joke_screen.dart';
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
  late final InfiniteQuery<List<PostModel>, int> query;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    query = _postService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InfiniteQueryBuilder(
          query: query,
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
        actions: [
          MutationBuilder<PostModel, PostModel>(
            mutation: _postService.createPost(),
            builder: (context, state, mutate) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (state.isFetching)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          )
        ],
      ),
      body: InfiniteQueryBuilder<List<PostModel>, int>(
        query: query,
        builder: (context, state, query) {
          if (state.data != null && state.data!.isNotEmpty) {
            final allPosts = state.data!.expand((e) => e).toList();

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state.status == QueryStatus.error &&
                    state.error is SocketException)
                  SliverToBoxAdapter(
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: Theme.of(context).errorColor),
                      child: const Text(
                        "No internet connection",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: MutationBuilder<PostModel, PostModel>(
                    mutation: _postService.createPost(),
                    builder: (context, state, _) {
                      if (state.isFetching) {
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
                    (context, i) => _Post(
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
          }
          if (state.status == QueryStatus.loading) {
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
    final query = _postService.getPosts();
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
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
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
                Text(post.id.toString()),
                Text(post.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
