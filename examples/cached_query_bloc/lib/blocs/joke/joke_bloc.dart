import 'dart:async';
import 'package:cached_query/cached_query.dart';
import 'package:examples/models/joke.model.dart';
import 'package:examples/repos/joke_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'joke_event.dart';
part 'joke_state.dart';
part 'joke_bloc.freezed.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final _repo = JokeRepository();
  StreamSubscription<Query<JokeModel?>>? _subscription;
  JokeBloc() : super(const JokeState()) {
    on<JokeFetched>(_onJokeFetched);
    on<JokeUpdated>(_onJokeUpdated);
  }
  FutureOr<void> _onJokeUpdated(JokeUpdated event, Emitter<JokeState> emit) {
    emit(state.copyWith(
      joke: event.joke,
      status: event.isFetching ? JokeStatus.loading : JokeStatus.success,
    ));
  }

  FutureOr<void> _onJokeFetched(
      JokeFetched event, Emitter<JokeState> emit) async {
    final res = await _repo.getJokeFuture();
    _subscription = res.getStream().listen((event) {
      add(JokeUpdated(joke: event.data, isFetching: event.isFetching));
    });
    // _subscription = res.
    // wait for the whole stream to finish
    // await emit.forEach<Query<JokeModel>>(
    //   _repo.getJoke(),
    //   onData: (query) => state.copyWith(
    //       joke: query.data,
    //       status: query.isFetching ? JokeStatus.loading : JokeStatus.success),
    // );
  }

  // example using cached query with a mixin in the bloc
  // FutureOr<void> _onJokeFetched(
  //   JokeFetched event,
  //   Emitter<JokeState> emit,
  // ) async {
  //   await emit.forEach<QueryState<JokeModel>>(
  //     queryStream(key: 'joke', queryFn: _repo.getJokeNoCache),
  //     onData: (query) => state.copyWith(
  //         joke: query.data,
  //         status: query.isFetching ? JokeStatus.loading : JokeStatus.success),
  //   );
  // }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _repo.dispose();
    return super.close();
  }
}
