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
    on<PostsRefreshed>(_onPostsRefreshed);
    on<PostCreated>(_onPostCreated);
  }

  FutureOr<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostState> emit,
  ) {
    // Subscribe to the stream from the infinite query.
    return emit.forEach<InfiniteQueryStatus<List<PostModel>, int>>(
      _repo.getPosts().stream,
      onData: (queryState) {
        return state.copyWith(
          posts: queryState.data?.pages.expand((page) => page).toList() ?? [],
          status:
              queryState.isLoading ? PostStatus.loading : PostStatus.success,
          //ignore
          hasReachedMax: _repo.getPosts().hasReachedMax(),
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
          isMutationLoading: mutationState.status == MutationStatus.loading,
        );
      },
    );
  }

  FutureOr<void> _onPostsRefreshed(
    PostsRefreshed event,
    Emitter<PostState> emit,
  ) async {
    await _repo.getPosts().refetch();
  }
}
