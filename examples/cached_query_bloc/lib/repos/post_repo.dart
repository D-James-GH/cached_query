import 'package:cached_query/cached_query.dart';
import 'package:examples/models/post_model.dart';
import 'package:examples/services/post.service.dart';

class PostRepository extends CachedQuery {
  final _service = PostService();

  InfiniteQuery<PostModel> getPosts({
    int initialPage = 1,
    int limit = 20,
  }) {
    return infiniteQuery<PostModel>(
      key: 'posts',
      queryFn: (page) async => PostModel.listFromJson(
          await _service.getPosts(page: page, limit: limit)),
    );
  }

  Future<void> createPost(PostModel post) async {
    await mutation<PostModel, PostModel>(
      key: ['posts', post.id],
      arg: post,
      queryFn: (post) async {
        final res = await _service.createPost(
            title: post.title, userId: post.userId, body: post.body);
        return PostModel.fromJson(res);
      },
      onSuccess: (args, newPost) {
        updateInfiniteQuery<PostModel>(
            key: "posts", updateFn: (old) => [newPost, ...?old]);
        invalidateQuery('posts');
      },
    );
    // get query and return after invalidation;
    // return getInfiniteQuery('posts');
  }

  Stream<List<PostModel>?> streamCreatePost(PostModel post) {
    return mutationStream<PostModel, List<PostModel>>(
        key: ['post'],
        queryFn: (p) async => PostModel.fromJson(
              await _service.createPost(
                  title: p!.title, userId: p.userId, body: p.body),
            ),
        arg: post,
        onStartMutation: (p) {
          updateInfiniteQuery<PostModel>(
              key: 'posts', updateFn: (List<PostModel>? old) => [p, ...?old]);
          return getInfiniteQuery('posts');
        },
        onSuccess: (post, res) {
          invalidateQuery('posts');
        });
  }
}
