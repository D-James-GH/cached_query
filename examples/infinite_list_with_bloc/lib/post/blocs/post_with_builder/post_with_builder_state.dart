part of 'post_with_builder_bloc.dart';

abstract class PostWithBuilderState extends Equatable {}

class PostWithBuilderInitial extends PostWithBuilderState {
  @override
  List<Object?> get props => [];
}

class PostWithBuilderSuccess extends PostWithBuilderState {
  final InfiniteQuery<List<PostModel>, int> postQuery;

  PostWithBuilderSuccess({required this.postQuery});

  @override
  List<Object?> get props => [postQuery];
}
