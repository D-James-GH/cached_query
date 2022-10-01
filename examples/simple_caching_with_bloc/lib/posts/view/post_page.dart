import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_caching_with_bloc/posts/view/post.dart';

import '../blocs/post/post_bloc.dart';
import '../models/post_model.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc()..add(PostFetched(50)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: BlocSelector<PostBloc, PostState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) {
                return Text(
                  isLoading ? "loading..." : "",
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<PostBloc>().add(PostRefreshed()),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    final currentId = state.currentId;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => context
                              .read<PostBloc>()
                              .add(PostFetched(currentId - 1)),
                          icon: const Icon(Icons.arrow_left),
                        ),
                        Text(currentId.toString()),
                        IconButton(
                          onPressed: () => context
                              .read<PostBloc>()
                              .add(PostFetched(currentId + 1)),
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    );
                  },
                ),
                BlocSelector<PostBloc, PostState, PostModel?>(
                  selector: (state) => state.post,
                  builder: (context, post) {
                    if (post == null) {
                      return const SizedBox();
                    }
                    return Post(post: post);
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
