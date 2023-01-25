import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/post_model.dart';
import '../../repos/post_repo.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();

  PostBloc() : super(const PostState()) {
    on<PostsFetched>(
      _onPostsFetched,
      transformer: restartable(),
    );
    on<PostsNextPage>(_onPostsNextPage);
    on<PostCreated>(_onPostCreated);
  }

  FutureOr<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostState> emit,
  ) {
    // Subscribe to the stream from the infinite query.
    return emit.forEach<InfiniteQueryState<List<PostModel>>>(
      _repo.getPosts().stream,
      onData: (queryState) {
        return state.copyWith(
          posts: queryState.data?.expand((page) => page).toList() ?? [],
          status: queryState.status == QueryStatus.loading
              ? PostStatus.loading
              : PostStatus.success,
          hasReachedMax: queryState.hasReachedMax,
        );
      },
    );
  }

  void _onPostsNextPage(PostEvent _, Emitter<PostState> __) {
    // No need to store the query in a variable as calling getPosts() again will
    // retrieve the same instance of infinite query.
    _repo.getPosts().getNextPage();
  }

  Future<void> _onPostCreated(
    PostCreated event,
    Emitter<PostState> emit,
  ) async {
    final mutation = _repo.createPostMutation()..mutate(event.post);
    return emit.forEach<MutationState<PostModel>>(
      mutation.stream,
      onData: (mutationState) {
        return state.copyWith(
          isMutationLoading: mutationState.status == QueryStatus.loading,
        );
      },
    );
  }
}
