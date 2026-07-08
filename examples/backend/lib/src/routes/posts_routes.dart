import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:backend/src/data/data_store.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shared_models/shared_models.dart';

/// Routes for post resources.
class PostsRoutes {
  PostsRoutes(this._dataStore);

  final DataStore _dataStore;

  Router get router {
    final router = Router();

    router.get('/posts', _listPosts);
    router.post('/posts', _createPost);
    router.get('/posts/<id>', _getPost);

    return router;
  }

  Response _listPosts(Request request) {
    final limit = parseQueryInt(
      request.url.queryParameters['limit'],
      defaultValue: 10,
    );
    final skip = parseQueryInt(
      request.url.queryParameters['skip'],
      defaultValue: 0,
    );
    final page = paginate(_dataStore.posts, skip: skip, limit: limit);

    return jsonResponse(
      PostsResponse(
        posts: page,
        total: _dataStore.posts.length,
        skip: skip,
        limit: limit,
      ).toJson(),
    );
  }

  Future<Response> _createPost(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final createRequest = CreatePostRequest.fromJson(json);
    final post = _dataStore.createPost(createRequest);
    return jsonResponse(post.toJson(), statusCode: HttpStatus.created);
  }

  Response _getPost(Request request, String id) {
    final postId = int.tryParse(id);
    if (postId == null) {
      return jsonResponse(
        {'message': 'Post not found'},
        statusCode: HttpStatus.notFound,
      );
    }

    for (final post in _dataStore.posts) {
      if (post.id == postId) {
        return jsonResponse(post.toJson());
      }
    }

    return jsonResponse(
      {'message': 'Post not found'},
      statusCode: HttpStatus.notFound,
    );
  }
}
