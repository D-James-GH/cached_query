import 'dart:convert';

import 'package:cached_query/cached_query.dart';

class InfiniteQueryTestRepository {
  static const key = "infiniteQuery";
  static const returnString = "infiniteQuery";

  Future<String> getPosts(int page) {
    return Future.value(returnString + page.toString());
  }
}
