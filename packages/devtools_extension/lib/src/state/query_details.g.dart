// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QueryDetails)
const queryDetailsProvider = QueryDetailsFamily._();

final class QueryDetailsProvider
    extends $AsyncNotifierProvider<QueryDetails, QueryDetailsState> {
  const QueryDetailsProvider._(
      {required QueryDetailsFamily super.from,
      required QueryInstance super.argument})
      : super(
          retry: null,
          name: r'queryDetailsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$queryDetailsHash();

  @override
  String toString() {
    return r'queryDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QueryDetails create() => QueryDetails();

  @override
  bool operator ==(Object other) {
    return other is QueryDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$queryDetailsHash() => r'1b16c4263665acf398cb7ea4913e42b7a5c9206a';

final class QueryDetailsFamily extends $Family
    with
        $ClassFamilyOverride<QueryDetails, AsyncValue<QueryDetailsState>,
            QueryDetailsState, FutureOr<QueryDetailsState>, QueryInstance> {
  const QueryDetailsFamily._()
      : super(
          retry: null,
          name: r'queryDetailsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  QueryDetailsProvider call(
    QueryInstance instance,
  ) =>
      QueryDetailsProvider._(argument: instance, from: this);

  @override
  String toString() => r'queryDetailsProvider';
}

abstract class _$QueryDetails extends $AsyncNotifier<QueryDetailsState> {
  late final _$args = ref.$arg as QueryInstance;
  QueryInstance get instance => _$args;

  FutureOr<QueryDetailsState> build(
    QueryInstance instance,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref =
        this.ref as $Ref<AsyncValue<QueryDetailsState>, QueryDetailsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<QueryDetailsState>, QueryDetailsState>,
        AsyncValue<QueryDetailsState>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
