// ignore_for_file: public_member_api_docs
import 'package:cached_query/src/query/_query.dart';
import 'package:cached_query/src/util/option.dart';

/// {@template controllerState}
/// Internal state for the query controller.
/// {@endtemplate}
class ControllerState<T> {
  /// The data of the query.
  final Option<T> data;

  /// The time the query was last fetched.
  final DateTime timeCreated;

  /// {@macro controllerState}
  ControllerState({
    required this.data,
    required this.timeCreated,
  });
}

sealed class ControllerAction<T> {}

final class Fetch<T> extends ControllerAction<T> {
  final FetchOptions fetchOptions;
  final bool isInitialFetch;

  Fetch({required this.fetchOptions, required this.isInitialFetch});
}

final class FetchError<T> extends ControllerAction<T> {
  final dynamic error;
  final StackTrace stackTrace;
  FetchError({required this.error, required this.stackTrace});
}

final class StorageError<T> extends ControllerAction<T> {
  final dynamic error;
  final StackTrace stackTrace;
  StorageError({required this.error, required this.stackTrace});
}

final class DataUpdated<T> extends ControllerAction<T> {
  final T data;
  final DateTime timeCreated;
  DataUpdated({required this.data, required this.timeCreated});
}

/// Called when the fetch is successful.
final class Success<T> extends ControllerAction<T> {
  /// The user may have chosen not to fetch, so the data may be missing.
  /// However, the fetch has completed successfully.
  final Option<T> data;
  final DateTime timeCreated;
  Success({required this.data, required this.timeCreated});
}
