import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'joke_event.dart';
part 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  JokeBloc() : super(JokeInitial());

  @override
  Stream<JokeState> mapEventToState(
    JokeEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
