part of 'post_with_builder_bloc.dart';

@immutable
abstract class PostWithBuilderEvent extends Equatable {}

class PostWithBuilderFetched extends PostWithBuilderEvent {
  @override
  List<Object?> get props => [];
}

class PostWithBuilderNextPage extends PostWithBuilderEvent {
  @override
  List<Object?> get props => [];
}

class PostWithBuilderCreated extends PostWithBuilderEvent {
  final PostModel post;

  PostWithBuilderCreated(this.post);
  @override
  List<Object?> get props => [post];
}
