part of 'joke_bloc.dart';

enum JokeStatus { loading, success, initial, error }

@freezed
class JokeState with _$JokeState {
  const factory JokeState({
    @Default(JokeStatus.initial) JokeStatus status,
    JokeModel? joke,
  }) = _JokeState;
}
