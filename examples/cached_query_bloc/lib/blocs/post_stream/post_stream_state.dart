part of 'post_stream_bloc.dart';

enum PostStatus { loading, initial, success }

class PostStreamState extends Equatable {
  final PostStatus status;
  final List<PostModel>? posts;
  final bool hasReachedMax;

  const PostStreamState(
      {this.status = PostStatus.initial,
      this.posts,
      this.hasReachedMax = false});

  @override
  List<Object?> get props => [posts, status, hasReachedMax];

  PostStreamState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
    bool? hasReachedMax,
  }) {
    return PostStreamState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
