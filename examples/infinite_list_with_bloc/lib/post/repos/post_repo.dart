import 'package:cached_query_flutter/cached_query_flutter.dart';

import '../models/post_model.dart';
import '../services/post.service.dart';

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
        await _service.getPosts(page: page, limit: 10),
      ),
    );
  }
}
