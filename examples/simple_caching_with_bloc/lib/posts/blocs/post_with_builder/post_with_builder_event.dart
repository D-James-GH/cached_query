part of 'post_with_builder_bloc.dart';

abstract class PostWithBuilderEvent extends Equatable {
  const PostWithBuilderEvent();
}

class PostWithBuilderFetched extends PostWithBuilderEvent {
  final int id;

  const PostWithBuilderFetched(this.id);
  @override
  List<Object?> get props => [id];
}

class PostWithBuilderRefreshed extends PostWithBuilderEvent {
  const PostWithBuilderRefreshed();
  @override
  List<Object?> get props => [];
}
