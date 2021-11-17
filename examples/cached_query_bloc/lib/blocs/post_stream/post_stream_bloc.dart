import 'dart:async';

import 'package:examples/repos/post_repo.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query/cached_query.dart';
import 'package:equatable/equatable.dart';
import 'package:examples/models/post_model.dart';
import 'package:meta/meta.dart';

part 'post_stream_event.dart';
part 'post_stream_state.dart';

class PostStreamBloc extends Bloc<PostStreamEvent, PostStreamState> {
  final _repo = PostRepository();
  InfiniteQuery<PostModel>? _infiniteQuery;
  StreamSubscription<InfiniteQuery<PostModel>>? _subscription;

  PostStreamBloc() : super(const PostStreamState()) {
    on<PostsStreamNextPage>(_onPostsNextPage,
        transformer: throttleDroppable(const Duration(milliseconds: 300)));
    on<PostStreamCreated>(_onPostCreated);
    on<PostStreamUpdated>(_onPostStreamUpdated);
    init();
  }
  void init() async {
    _infiniteQuery = await _repo.getPosts(listener: (query) {
      add(PostStreamUpdated(
          posts: query.data ?? [],
          hasReachedMax: query.hasReachedMax,
          isFetching: query.isFetching));
    });
  }

  FutureOr<void> _onPostStreamUpdated(
      PostStreamUpdated event, Emitter<PostStreamState> emit) {
    emit(state.copyWith(
      posts: event.posts,
      hasReachedMax: event.hasReachedMax,
      status: event.isFetching ? PostStatus.loading : PostStatus.success,
    ));
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
    _subscription?.cancel();
    _repo.close();
    return super.close();
  }
}
