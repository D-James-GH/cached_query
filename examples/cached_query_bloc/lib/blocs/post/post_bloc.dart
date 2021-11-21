import 'dart:async';

import 'package:examples/repos/post_repo.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query/cached_query.dart';
import 'package:equatable/equatable.dart';
import 'package:examples/models/post_model.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();
  InfiniteQuery<PostModel>? _infiniteQuery;

  PostBloc() : super(const PostState()) {
    on<PostsStreamFetched>(_onPostsFetched);
    on<PostsStreamNextPage>(_onPostsNextPage,
        transformer: throttleDroppable(const Duration(milliseconds: 300)));
    on<PostStreamCreated>(_onPostCreated);
  }

  FutureOr<void> _onPostsFetched(
      PostsStreamFetched event, Emitter<PostState> emit) async {
    _infiniteQuery = _repo.getPosts();
    await emit.forEach<InfiniteQueryState<PostModel>>(_infiniteQuery!.stream,
        onData: (query) {
      return state.copyWith(
        posts: query.data,
        status: query.isFetching ? PostStatus.loading : PostStatus.success,
        hasReachedMax: query.hasReachedMax,
      );
    });
  }

  void _onPostsNextPage(_, __) {
    _infiniteQuery?.getNextPage();
  }

  void _onPostCreated(PostStreamCreated event, _) {
    _repo.createPost(event.post);
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  @override
  Future<void> close() {
    _repo.close();
    return super.close();
  }
}
