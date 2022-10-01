part of 'post_bloc.dart';

class PostState extends Equatable {
  final PostModel? post;
  final int currentId;
  final bool isLoading;

  const PostState({this.isLoading = false, this.currentId = 1, this.post});

  @override
  List<Object?> get props => [post, isLoading, currentId];
}
