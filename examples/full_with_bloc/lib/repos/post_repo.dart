import 'package:cached_query/cached_query.dart';

import '../models/post_model.dart';
import '../services/post.service.dart';

class PostRepository {
  final _service = PostService();

  InfiniteQuery<List<PostModel>, int> getPosts() {
    return InfiniteQuery<List<PostModel>, int>(
      key: 'posts',
      getNextArg: (state) {
        final len = state?.pages.length ?? 0;
        if (len > 5) return null;
        if (state?.lastPage?.isEmpty ?? false) return null;
        return len + 1;
      },
      queryFn: (page) async {
        return PostModel.listFromJson(
          await _service.getPosts(page: page, limit: 10),
        );
      },
    );
  }

  Mutation<PostModel, PostModel> createPostMutation() {
    return Mutation<PostModel, PostModel>(
      mutationFn: (post) async {
        final res = await _service.createPost(
          title: post.title,
          userId: post.userId,
          body: post.body,
        );
        return PostModel.fromJson(res);
      },
      onStartMutation: (postArg) {
        final query = CachedQuery.instance
            .getQuery<InfiniteQuery<List<PostModel>, int>>("posts");
        if (query == null) return null;
        final fallback = query.state.data;

        query.update((old) {
          return InfiniteQueryData(
            args: old?.args ?? [],
            pages: [
              [postArg, ...?old?.pages.first],
              ...?old?.pages.sublist(1),
            ],
          );
        });
        return fallback;
      },
      onSuccess: (args, newPost) {
        CachedQuery.instance.invalidateCache(key: "posts");
      },
      onError: (arg, error, fallback) {
        if (fallback != null) {
          (CachedQuery.instance.getQuery("posts")
                  as InfiniteQuery<List<PostModel>, int>)
              .update(
            (old) => fallback as InfiniteQueryData<List<PostModel>, int>,
          );
        }
      },
    );
  }
}
