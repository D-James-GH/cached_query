import 'dart:async';

import 'package:examples/repos/post_repo.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query/cached_query.dart';
import 'package:equatable/equatable.dart';
import 'package:examples/models/post.model.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();
  InfiniteQuery<PostModel>? _infiniteQuery;

  PostBloc() : super(const PostState()) {
    on<PostsFetched>(_onPostsFetched);
    on<PostsNextPage>(_onPostsNextPage,
        transformer: throttleDroppable(const Duration(milliseconds: 300)));
    on<PostCreated>(_onPostCreated);
  }

  FutureOr<void> _onPostsFetched(
      PostsFetched event, Emitter<PostState> emit) async {
    await emit.forEach<InfiniteQuery<PostModel>>(_repo.streamPosts(),
        onData: (query) {
      _infiniteQuery = query;
      return state.copyWith(
        posts: query.data,
        status: query.isFetching ? PostStatus.loading : PostStatus.success,
        hasReachedMax: query.hasReachedMax,
      );
    });
  }

  FutureOr<void> _onPostsNextPage(
      PostsNextPage event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    emit(state.copyWith(status: PostStatus.loading));

    final newQuery = await _infiniteQuery!.getNextPage();
    emit(state.copyWith(
        status: PostStatus.success,
        posts: newQuery.data,
        hasReachedMax: newQuery.hasReachedMax));
  }

  FutureOr<void> _onPostCreated(
      PostCreated event, Emitter<PostState> emit) async {
    // without optimistic updates
    // emit(state.copyWith(posts: await _repo.createPost(event.post)));

    // with optimistic updates
    await emit.forEach<List<PostModel>?>(_repo.streamCreatePost(event.post),
        onData: (data) => state.copyWith(
              status: PostStatus.success,
              posts: data as List<PostModel>,
            ));
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  @override
  Future<void> close() {
    _repo.dispose();
    return super.close();
  }
}
