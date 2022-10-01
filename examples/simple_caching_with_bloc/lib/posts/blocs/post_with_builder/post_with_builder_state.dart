part of 'post_with_builder_bloc.dart';

class PostWithBuilderState extends Equatable {
  final int currentId;
  final Query<PostModel> postQuery;

  const PostWithBuilderState({
    required this.currentId,
    required this.postQuery,
  });

  @override
  List<Object?> get props => [postQuery, currentId];
}
