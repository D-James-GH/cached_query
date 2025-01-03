import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_caching_with_bloc/posts/service/post_service.dart';

import '../../models/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    /// !important: use the restartable transformer to automatically subscribe and
    /// unsubscribe when a new event comes in.
    on<PostFetched>(_onFetched, transformer: restartable());
    on<PostRefreshed>(_onRefresh);
  }

  FutureOr<void> _onFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) {
    return emit.forEach(
      getPostById(event.id).stream,
      onData: (queryState) {
        return PostState(
          currentId: event.id,
          post: queryState.data,
          isLoading: queryState.isLoading,
        );
      },
    );
  }

  FutureOr<void> _onRefresh(PostRefreshed event, Emitter<PostState> emit) {
    getPostById(state.currentId).refetch();
  }
}
