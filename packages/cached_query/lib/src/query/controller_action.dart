// ignore_for_file: public_member_api_docs
import 'package:cached_query/src/query/_query.dart';

sealed class ControllerAction {}

final class Fetch extends ControllerAction {
  final FetchOptions fetchOptions;
  final bool isInitialFetch;

  Fetch({required this.fetchOptions, required this.isInitialFetch});
}

final class FetchError extends ControllerAction {
  final dynamic error;
  final StackTrace stackTrace;
  FetchError({required this.error, required this.stackTrace});
}

final class StorageError extends ControllerAction {
  final dynamic error;
  final StackTrace stackTrace;
  StorageError({required this.error, required this.stackTrace});
}

final class DataUpdated<T> extends ControllerAction {
  final T data;
  DataUpdated({required this.data});
}

final class Success<T> extends ControllerAction {
  final T data;
  final DateTime timeCreated;
  Success({required this.data, required this.timeCreated});
}
