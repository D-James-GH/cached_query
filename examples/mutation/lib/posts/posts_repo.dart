import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:mutation/posts/posts_service.dart' as service;

import 'post_model.dart';

const queryKey = 'posts';

Query<List<PostModel>> getPostsQuery() {
  return Query(
    key: queryKey,
    queryFn: () async => PostModel.listFromJson(
      await service.getPosts(),
    ),
  );
}

Mutation<PostModel, PostModel> createPostMutation() {
  return Mutation(
    refetchQueries: [queryKey],
    mutationFn: (post) async => PostModel.fromJson(
      await service.createPost(post.toJson()),
    ),
    onStartMutation: (post) {
      final query =
          CachedQuery.instance.getQuery(queryKey) as Query<List<PostModel>>;
      final fallback = query.state.data;

      // optimistically set the data
      query.update((oldData) => [post, ...?oldData]);

      // return the previous data so that we can fallback to it if the
      // mutation fails.
      return fallback;
    },
    onError: (arg, error, fallback) {
      CachedQuery.instance.updateQuery(
          key: queryKey, updateFn: (_) => fallback as List<PostModel>);
    },
  );
}
