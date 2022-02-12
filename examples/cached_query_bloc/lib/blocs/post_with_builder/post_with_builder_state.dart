part of 'post_with_builder_bloc.dart';

class PostWithBuilderState extends Equatable {
  final InfiniteQuery<List<PostModel>, int> postsQuery;

  const PostWithBuilderState({required this.postsQuery});

  @override
  List<Object?> get props => [postsQuery];

  PostWithBuilderState copyWith({
    InfiniteQuery<List<PostModel>, int>? postsQuery,
  }) {
    return PostWithBuilderState(
      postsQuery: postsQuery ?? this.postsQuery,
    );
  }
}
