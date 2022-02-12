import 'package:cached_query/cached_query.dart';
import 'package:examples/models/post_model.dart';
import 'package:examples/services/post.service.dart';

class PostRepository extends CachedQuery {
  final _service = PostService();

  InfiniteQuery<List<PostModel>, int> getPosts() {
    return infiniteQuery<List<PostModel>, int>(
      key: 'posts',
      getNextArg: (currentPage, lastPage) {
        if (lastPage == null) return 1;
        if (lastPage.isNotEmpty) {
          return currentPage + 1;
        }
        return null;
      },
      queryFn: (page) async => PostModel.listFromJson(
          await _service.getPosts(page: page, limit: 20)),
    );
  }

  Mutation<PostModel, PostModel> createPost(PostModel post) {
    return Mutation<PostModel, PostModel>(
      key: ['posts', post.id],
      queryFn: (post) async {
        final res = await _service.createPost(
            title: post.title, userId: post.userId, body: post.body);
        return PostModel.fromJson(res);
      },
      onSuccess: (args, newPost) {
        updateInfiniteQuery<PostModel, int>(
            key: "posts", updateFn: (old) => [newPost, ...?old]);
        invalidateQuery('posts');
      },
    );
    // get query and return after invalidation;
    // return getInfiniteQuery('posts');
  }
}
