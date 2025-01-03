import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_caching_with_bloc/posts/blocs/post_with_builder/post_with_builder_bloc.dart';
import 'package:simple_caching_with_bloc/posts/view/post.dart';

import '../models/post_model.dart';

class PostWithBuilderPage extends StatelessWidget {
  const PostWithBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostWithBuilderBloc()..add(const PostWithBuilderFetched(50)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: BlocSelector<PostWithBuilderBloc, PostWithBuilderState,
                Query<PostModel>?>(
              selector: (state) => state.postQuery,
              builder: (context, query) {
                if (query == null) return const SizedBox();
                return QueryBuilder(
                  query: query,
                  builder: (context, state) {
                    return Text(
                      state.isLoading ? "loading..." : "",
                    );
                  },
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<PostWithBuilderBloc>()
                    .add(const PostWithBuilderRefreshed()),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                BlocBuilder<PostWithBuilderBloc, PostWithBuilderState>(
                  builder: (context, state) {
                    final currentId = state.currentId;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => context
                              .read<PostWithBuilderBloc>()
                              .add(PostWithBuilderFetched(currentId - 1)),
                          icon: const Icon(Icons.arrow_left),
                        ),
                        Text(currentId.toString()),
                        IconButton(
                          onPressed: () => context
                              .read<PostWithBuilderBloc>()
                              .add(PostWithBuilderFetched(currentId + 1)),
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    );
                  },
                ),
                BlocSelector<PostWithBuilderBloc, PostWithBuilderState,
                    Query<PostModel>>(
                  selector: (state) => state.postQuery,
                  builder: (context, query) {
                    return QueryBuilder(
                      query: query,
                      builder: (context, state) {
                        if (state.data == null) {
                          return const SizedBox();
                        }
                        return Post(post: state.data!);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
