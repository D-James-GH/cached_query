part of 'post_stream_bloc.dart';

@immutable
abstract class PostStreamEvent extends Equatable {}

class PostsStreamFetched extends PostStreamEvent {
  @override
  List<Object?> get props => [];
}

class PostStreamUpdated extends PostStreamEvent {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final bool isFetching;

  PostStreamUpdated(
      {required this.isFetching,
      required this.posts,
      required this.hasReachedMax});

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostsStreamNextPage extends PostStreamEvent {
  @override
  List<Object?> get props => [];
}

class PostStreamCreated extends PostStreamEvent {
  final PostModel post;

  PostStreamCreated(this.post);
  @override
  List<Object?> get props => [];
}
