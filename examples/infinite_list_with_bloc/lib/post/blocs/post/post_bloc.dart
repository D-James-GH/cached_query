import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model.dart';
import '../../repos/post_repo.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();

  PostBloc() : super(const PostState()) {
    // use restartable
    on<PostsFetched>(_onPostsFetched, transformer: restartable());
    on<PostsNextPage>(_onPostsNextPage);
  }

  FutureOr<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostState> emit,
  ) {
    final query = _repo.getPosts();
    // Subscribe to the stream from the infinite query.
    return emit.forEach<InfiniteQueryStatus<List<PostModel>, int>>(
      query.stream,
      onData: (queryState) {
        return state.copyWith(
          posts: queryState.data?.expand((page) => page).toList() ?? [],
          status:
              queryState.isLoading ? PostStatus.loading : PostStatus.success,
          hasReachedMax: query.hasReachedMax(),
        );
      },
    );
  }

  void _onPostsNextPage(PostEvent _, Emitter<PostState> __) {
    // No need to store the query in a variable as calling getPosts() again will
    // retrieve the same instance of infinite query.
    _repo.getPosts().getNextPage();
  }
}
