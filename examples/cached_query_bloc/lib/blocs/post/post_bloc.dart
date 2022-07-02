import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:examples/models/post_model.dart';
import 'package:examples/repos/post_repo.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();

  PostBloc() : super(const PostState()) {
    on<PostsStreamFetched>(_onPostsFetched);
    on<PostsStreamNextPage>(
      _onPostsNextPage,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
    on<PostStreamCreated>(_onPostCreated);
  }

  FutureOr<void> _onPostsFetched(
    PostsStreamFetched event,
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

  void _onPostCreated(PostStreamCreated event, Emitter<PostState> _) {
    _repo.createPost(event.post);
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }
}
