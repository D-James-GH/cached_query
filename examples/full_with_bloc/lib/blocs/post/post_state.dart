part of 'post_bloc.dart';

enum PostStatus { loading, initial, success }

class PostState extends Equatable {
  final PostStatus status;
  final List<PostModel>? posts;
  final bool hasReachedMax;
  final bool isMutationLoading;

  const PostState({
    this.isMutationLoading = false,
    this.status = PostStatus.initial,
    this.posts,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [posts, status, hasReachedMax, isMutationLoading];

  PostState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
    bool? hasReachedMax,
    bool? isMutationLoading,
  }) {
    return PostState(
      isMutationLoading: isMutationLoading ?? this.isMutationLoading,
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
