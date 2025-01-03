import 'package:cached_query/cached_query.dart';

import '../models/post_model.dart';
import '../services/post.service.dart';

class PostRepository {
  final _service = PostService();

  InfiniteQuery<List<PostModel>, int> getPosts() {
    return InfiniteQuery<List<PostModel>, int>(
      key: 'posts',
      getNextArg: (state) {
        final len = state.data?.length ?? 0;
        if (len > 5) return null;
        if (state.lastPage?.isEmpty ?? false) return null;
        return (state.data?.length ?? 0) + 1;
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
      refetchQueries: ["posts"],
      queryFn: (post) async {
        final res = await _service.createPost(
          title: post.title,
          userId: post.userId,
          body: post.body,
        );
        return PostModel.fromJson(res);
      },
      onStartMutation: (postArg) {
        CachedQuery.instance.updateQuery(
          key: "posts",
          updateFn: (dynamic old) {
            if (old is List<List<PostModel>>) {
              return <List<PostModel>>[
                [postArg, ...old[0]],
                ...old.sublist(1).toList(),
              ];
            }
          },
        );
      },
    );
  }
}
