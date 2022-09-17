part of 'joke_bloc.dart';

@immutable
abstract class JokeEvent {}

class JokeFetched extends JokeEvent {}

class JokeUpdated extends JokeEvent {
  final JokeModel? joke;
  final bool isFetching;

  JokeUpdated({required this.joke, required this.isFetching});
}
