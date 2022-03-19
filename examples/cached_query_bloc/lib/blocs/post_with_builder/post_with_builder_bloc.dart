import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:examples/models/post_model.dart';
import 'package:examples/repos/post_repo.dart';
import 'package:meta/meta.dart';

part 'post_with_builder_event.dart';
part 'post_with_builder_state.dart';

class PostWithBuilderBloc
    extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {
  final _repo = PostRepository();

  PostWithBuilderBloc()
      : super(PostWithBuilderState(postsQuery: PostRepository().getPosts())) {
    on<PostWithBuilderNextPage>(
      _onPostsNextPage,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
    on<PostWithBuilderCreated>(_onPostCreated);
  }

  void _onPostsNextPage(
    PostWithBuilderEvent _,
    Emitter<PostWithBuilderState> __,
  ) {
    _repo.getPosts().getNextPage();
  }

  void _onPostCreated(
    PostWithBuilderCreated event,
    Emitter<PostWithBuilderState> _,
  ) {
    _repo.createPost(event.post);
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }
}
