import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_caching_with_bloc/posts/service/post_service.dart';

import '../../models/post_model.dart';

part 'post_with_builder_event.dart';
part 'post_with_builder_state.dart';

class PostWithBuilderBloc
    extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {
  PostWithBuilderBloc()
      : super(PostWithBuilderState(currentId: 50, postQuery: getPostById(50))) {
    on<PostWithBuilderFetched>(_onPostFetched);
    on<PostWithBuilderRefreshed>(_onPostRefreshed);
  }

  FutureOr<void> _onPostFetched(
    PostWithBuilderFetched event,
    Emitter<PostWithBuilderState> emit,
  ) {
    final res = getPostById(event.id);
    emit(PostWithBuilderState(currentId: event.id, postQuery: res));
  }

  FutureOr<void> _onPostRefreshed(
    PostWithBuilderRefreshed event,
    Emitter<PostWithBuilderState> emit,
  ) {
    getPostById(state.currentId).refetch();
  }
}
