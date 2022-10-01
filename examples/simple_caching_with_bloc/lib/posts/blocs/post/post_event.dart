part of 'post_bloc.dart';

abstract class PostEvent {}

class PostFetched extends PostEvent {
  final int id;
  PostFetched(this.id);
}

class PostRefreshed extends PostEvent {}
