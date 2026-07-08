import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:backend/src/data/data_store.dart';
import 'package:backend/src/middleware/delay_middleware.dart';
import 'package:backend/src/routes/movies_routes.dart';
import 'package:backend/src/routes/posts_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> startServer() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final dataStore = await DataStore.load();
  final postsRouter = PostsRoutes(dataStore).router;
  final moviesRouter = MoviesRoutes(dataStore).router;
  final router = Router()
    ..mount('/', postsRouter.call)
    ..mount('/', moviesRouter.call);

  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(delayMiddleware)
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.loopbackIPv4,
    port,
  );

  // ignore: avoid_print
  print('Mock API listening on http://${server.address.host}:${server.port}');
}

Response jsonResponse(Object body, {int statusCode = HttpStatus.ok}) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
}

final Random random = Random();

int parseQueryInt(String? value, {required int defaultValue}) {
  if (value == null) {
    return defaultValue;
  }
  final parsed = int.tryParse(value);
  if (parsed == null || parsed < 0) {
    return defaultValue;
  }
  return parsed;
}

List<T> paginate<T>(List<T> items, {required int skip, required int limit}) {
  if (skip >= items.length) {
    return [];
  }
  final end = (skip + limit).clamp(0, items.length);
  return items.sublist(skip, end);
}
