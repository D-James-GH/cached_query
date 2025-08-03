//ignore_for_file: avoid_print

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/util/encode_key.dart';

/// {@template query_logging_observer}
/// An observer to log changes in queries and mutations.
/// {@endtemplate}
class QueryLoggingObserver implements QueryObserver {
  /// Whether to log when a mutation is created.
  final bool mutationCreation;

  /// Whether to log when a mutation is reused.
  final bool mutationReuse;

  /// Whether to log when a query is created.
  final bool queryCreation;

  /// Whether to log when a query is deleted.
  final bool queryDeletion;

  /// Whether to log when a query changes.
  final bool queryChange;

  /// Whether to log when a query errors.
  final bool queryError;

  /// Whether to log when a mutation errors.
  final bool mutationError;

  /// Whether to log when a mutation changes.
  final bool mutationChange;

  /// Whether to log with colors. Defaults to true.
  /// On IOS often colors are not supported.
  final bool colors;

  /// Whether to log the query change state data rather than the state status.
  /// Defaults to false.
  final bool verbose;

  /// {@macro query_logging_observer}
  const QueryLoggingObserver({
    this.colors = true,
    this.verbose = false,
    this.mutationCreation = true,
    this.mutationReuse = true,
    this.queryCreation = true,
    this.queryDeletion = true,
    this.queryChange = true,
    this.queryError = true,
    this.mutationError = true,
    this.mutationChange = true,
  });
  @override
  void onMutationCreation(
    Mutation<dynamic, dynamic> query,
  ) {
    if (!mutationCreation) return;
    _log(
      _AnsiColors("[MUTATION CREATED]", colors: colors).bold.magenta.toString(),
      key: query.key,
    );
  }

  @override
  void onMutationReuse(
    Mutation<dynamic, dynamic> query,
  ) {
    if (!mutationReuse) return;
    _log(
      _AnsiColors("[MUTATION REUSE]", colors: colors).bold.blue.toString(),
      key: query.key,
    );
  }

  @override
  void onQueryCreation(
    Cacheable<dynamic> query,
  ) {
    if (!queryCreation) return;
    _log(
      _AnsiColors("[QUERY CREATED] ", colors: colors).bold.magenta.toString(),
      key: query.key,
    );
  }

  @override
  void onQueryDeletion(Object? key) {
    _log(
      _AnsiColors("[QUERY DELETED]", colors: colors).bold.yellow.toString(),
      message: 'Query with key: "$key" was removed from the cache',
      key: key != null ? encodeKey(key) : null,
    );
  }

  @override
  void onChange(
    Cacheable<dynamic> query,
    QueryState<dynamic> nextState,
  ) {
    if (!queryChange) return;
    List<String> message;
    final currentState = switch (query) {
      InfiniteQuery() => query.state.toString(),
      Query() => query.state.toString(),
    };
    if (verbose) {
      message = [
        _AnsiColors("Prev State: $currentState", colors: colors)
            .green
            .toString(),
        _AnsiColors("", colors: colors).reset.toString(),
        _AnsiColors("Next State: $nextState", colors: colors).blue.toString(),
        _AnsiColors("", colors: colors).reset.toString(),
      ];
    } else {
      message = [
        "Prev State: $currentState",
        "Next State: $nextState",
      ];
    }
    _log(
      _AnsiColors("[QUERY CHANGE]", colors: colors).bold.green.toString(),
      message: message,
      key: query.key,
    );
  }

  @override
  Future<void> onError(
    Cacheable<dynamic> query,
    StackTrace stackTrace,
  ) async {
    if (!queryError) return;
    var error = "";
    switch (query) {
      case InfiniteQuery():
        if (query.state case InfiniteQueryError(error: final e)) {
          error = e.toString();
        }
      case Query():
        if (query.state case QueryError(error: final e)) {
          error = e.toString();
        }
        break;
    }
    _log(
      _AnsiColors("[ERROR]", colors: colors).bold.red.toString(),
      message: 'Error: $error',
      key: query.key,
      stackTrace: stackTrace,
    );
  }

  @override
  void onMutationError(
    Mutation<dynamic, dynamic> mutation,
    StackTrace stackTrace,
  ) {
    if (!mutationError) return;
    final state = mutation.state as MutationError<dynamic>;
    _log(
      _AnsiColors("[MUTATION ERROR]", colors: colors).bold.red.toString(),
      message: 'Error: ${state.error}',
      key: mutation.key,
      stackTrace: stackTrace,
    );
  }

  @override
  void onMutationChange(
    Mutation<dynamic, dynamic> mutation,
    MutationState<dynamic> nextState,
  ) {
    if (!mutationChange) return;

    List<String> message;
    if (verbose) {
      message = [
        _AnsiColors("Prev State: ${mutation.state}", colors: colors)
            .green
            .toString(),
        _AnsiColors("", colors: colors).reset.toString(),
        _AnsiColors("Next State: $nextState", colors: colors).blue.toString(),
        _AnsiColors("", colors: colors).reset.toString(),
      ];
    } else {
      message = [
        "Prev State: ${mutation.state}",
        "Next State: $nextState",
      ];
    }
    _log(
      _AnsiColors("[MUTATION CHANGE]", colors: colors).blue.bold.toString(),
      message: message,
      key: mutation.key,
    );
  }

  void _log(
    String event, {
    String? key,
    Object? message,
    StackTrace? stackTrace,
  }) {
    var formatKey = "";
    if (key != null) {
      formatKey = _AnsiColors(" key: $key", colors: colors).cyan.toString();
    }
    print("--------------------- Cached Query -------------------------");
    print("$event$formatKey");
    if (message is List) {
      for (final m in message) {
        print(m);
      }
    } else if (message != null) {
      print(message);
    }
    if (stackTrace != null) {
      print("StackTrace: $stackTrace");
    }
    print("------------------------------------------------------------");
  }
}

class _AnsiColors {
  final bool colors;
  String _value;

  _AnsiColors(String value, {required this.colors}) : _value = value;
  @override
  String toString() => _value;

  _AnsiColors get reset => _cloneWithStyles(0, 0);
  _AnsiColors get bold => _cloneWithStyles(1, 22);
// Text colors.
  _AnsiColors get red => _cloneWithStyles(31, 39);
  _AnsiColors get green => _cloneWithStyles(32, 39);
  _AnsiColors get yellow => _cloneWithStyles(33, 39);
  _AnsiColors get blue => _cloneWithStyles(34, 39);
  _AnsiColors get magenta => _cloneWithStyles(35, 39);
  _AnsiColors get cyan => _cloneWithStyles(36, 39);

  _AnsiColors _cloneWithStyles(int openCode, int closeCode) {
    if (colors) {
      _value = "\u001B[${openCode}m$_value\u001B[${closeCode}m";
      return this;
    }
    return this;
  }
}
