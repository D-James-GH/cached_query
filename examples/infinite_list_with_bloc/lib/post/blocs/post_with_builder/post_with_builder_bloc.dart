import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model.dart';
import '../../repos/post_repo.dart';

part 'post_with_builder_event.dart';
part 'post_with_builder_state.dart';

class PostWithBuilderBloc
    extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {
  final _repo = PostRepository();

  PostWithBuilderBloc() : super(PostWithBuilderInitial()) {
    on<PostsWithBuilderFetched>(_onPostsFetched);
    on<PostsWithBuilderNextPage>(_onPostsNextPage);
  }

  FutureOr<void> _onPostsFetched(
    PostsWithBuilderFetched _,
    Emitter<PostWithBuilderState> emit,
  ) {
    final query = _repo.getPosts();
    emit(PostWithBuilderSuccess(postQuery: query));
  }

  void _onPostsNextPage(
      PostWithBuilderEvent _, Emitter<PostWithBuilderState> __) {
    // No need to store the query in a variable as calling getPosts() again will
    // retrieve the same instance of infinite query.
    _repo.getPosts().getNextPage();
  }
}
