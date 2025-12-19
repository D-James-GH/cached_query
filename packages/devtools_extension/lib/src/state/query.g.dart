// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QueryList)
const queryListProvider = QueryListProvider._();

final class QueryListProvider
    extends $AsyncNotifierProvider<QueryList, QueryListState> {
  const QueryListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'queryListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$queryListHash();

  @$internal
  @override
  QueryList create() => QueryList();
}

String _$queryListHash() => r'ea408e262bdff1c21a42a737bb448649b3602020';

abstract class _$QueryList extends $AsyncNotifier<QueryListState> {
  FutureOr<QueryListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<QueryListState>, QueryListState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<QueryListState>, QueryListState>,
        AsyncValue<QueryListState>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(stale)
const staleProvider = StaleFamily._();

final class StaleProvider
    extends $FunctionalProvider<AsyncValue<bool?>, bool?, FutureOr<bool?>>
    with $FutureModifier<bool?>, $FutureProvider<bool?> {
  const StaleProvider._(
      {required StaleFamily super.from, required InstanceRef super.argument})
      : super(
          retry: null,
          name: r'staleProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$staleHash();

  @override
  String toString() {
    return r'staleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool?> create(Ref ref) {
    final argument = this.argument as InstanceRef;
    return stale(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StaleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$staleHash() => r'6b89d1f71c9d892febf5c3cf9735dc5a8a4c99e5';

final class StaleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool?>, InstanceRef> {
  const StaleFamily._()
      : super(
          retry: null,
          name: r'staleProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  StaleProvider call(
    InstanceRef instanceRef,
  ) =>
      StaleProvider._(argument: instanceRef, from: this);

  @override
  String toString() => r'staleProvider';
}

@ProviderFor(queryStatus)
const queryStatusProvider = QueryStatusFamily._();

final class QueryStatusProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  const QueryStatusProvider._(
      {required QueryStatusFamily super.from,
      required (
        InstanceRef,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'queryStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$queryStatusHash();

  @override
  String toString() {
    return r'queryStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as (
      InstanceRef,
      String,
    );
    return queryStatus(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QueryStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$queryStatusHash() => r'13ceaaf641458ba1d886e031b56b05f93170dc6a';

final class QueryStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<String?>,
            (
              InstanceRef,
              String,
            )> {
  const QueryStatusFamily._()
      : super(
          retry: null,
          name: r'queryStatusProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  QueryStatusProvider call(
    InstanceRef instanceRef,
    String queryKey,
  ) =>
      QueryStatusProvider._(argument: (
        instanceRef,
        queryKey,
      ), from: this);

  @override
  String toString() => r'queryStatusProvider';
}
