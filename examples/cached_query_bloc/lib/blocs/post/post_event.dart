part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {}

class PostsStreamFetched extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostsStreamNextPage extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostStreamCreated extends PostEvent {
  final PostModel post;

  PostStreamCreated(this.post);
  @override
  List<Object?> get props => [];
}
