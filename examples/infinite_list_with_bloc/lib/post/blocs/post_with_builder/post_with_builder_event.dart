part of 'post_with_builder_bloc.dart';

@immutable
abstract class PostWithBuilderEvent {}

class PostsWithBuilderFetched extends PostWithBuilderEvent {}

class PostsWithBuilderNextPage extends PostWithBuilderEvent {}
