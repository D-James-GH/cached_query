import 'dart:async';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:examples/models/joke_model.dart';
import 'package:examples/repos/joke_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';

part 'joke_event.dart';
part 'joke_state.dart';
part 'joke_bloc.freezed.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final _repo = JokeRepository();
  JokeBloc() : super(const JokeState()) {
    on<JokeFetched>(_onJokeFetched);
  }

  FutureOr<void> _onJokeFetched(
    JokeFetched event,
    Emitter<JokeState> emit,
  ) async {
    await emit.forEach<QueryState<JokeModel?>>(
      _repo.getJoke().stream,
      onData: (query) => state.copyWith(
        joke: query.data,
        status: query.status == QueryStatus.loading
            ? JokeStatus.loading
            : JokeStatus.success,
      ),
    );
  }
}
