import 'package:cached_query/cached_query.dart';
import 'package:examples/models/post_model.dart';
import 'package:examples/services/post.service.dart';

class PostRepository {
  final _service = PostService();

  InfiniteQuery<List<PostModel>, int> getPosts() {
    return InfiniteQuery<List<PostModel>, int>(
      key: 'posts',
      getNextArg: (state) {
        if (state.lastPage?.isEmpty ?? false) return null;
        return state.length + 1;
      },
      queryFn: (page) async => PostModel.listFromJson(
        await _service.getPosts(page: page, limit: 20),
      ),
    );
  }

  Mutation<PostModel, PostModel> createPost(PostModel post) {
    return Mutation<PostModel, PostModel>(
      key: ['posts', post.id],
      queryFn: (post) async {
        final res = await _service.createPost(
          title: post.title,
          userId: post.userId,
          body: post.body,
        );
        return PostModel.fromJson(res);
      },
      onSuccess: (args, newPost) {
        CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
          key: "posts",
          updateFn: (old) => [
            [newPost, ...old![0]],
            ...old.sublist(1).toList()
          ],
        );
        CachedQuery.instance.invalidateCache('posts');
      },
    );
    // get query and return after invalidation;
    // return getInfiniteQuery('posts');
  }
}
