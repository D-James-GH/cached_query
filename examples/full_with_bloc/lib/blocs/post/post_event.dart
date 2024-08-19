part of 'post_bloc.dart';

@immutable
sealed class PostEvent extends Equatable {}

class PostsFetched extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostsRefreshed extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostsNextPage extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostCreated extends PostEvent {
  final PostModel post;

  PostCreated(this.post);
  @override
  List<Object?> get props => [];
}
