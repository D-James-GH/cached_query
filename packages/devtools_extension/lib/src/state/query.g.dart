// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$staleHash() => r'6b89d1f71c9d892febf5c3cf9735dc5a8a4c99e5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [stale].
@ProviderFor(stale)
const staleProvider = StaleFamily();

/// See also [stale].
class StaleFamily extends Family<AsyncValue<bool?>> {
  /// See also [stale].
  const StaleFamily();

  /// See also [stale].
  StaleProvider call(
    InstanceRef instanceRef,
  ) {
    return StaleProvider(
      instanceRef,
    );
  }

  @override
  StaleProvider getProviderOverride(
    covariant StaleProvider provider,
  ) {
    return call(
      provider.instanceRef,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'staleProvider';
}

/// See also [stale].
class StaleProvider extends FutureProvider<bool?> {
  /// See also [stale].
  StaleProvider(
    InstanceRef instanceRef,
  ) : this._internal(
          (ref) => stale(
            ref as StaleRef,
            instanceRef,
          ),
          from: staleProvider,
          name: r'staleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$staleHash,
          dependencies: StaleFamily._dependencies,
          allTransitiveDependencies: StaleFamily._allTransitiveDependencies,
          instanceRef: instanceRef,
        );

  StaleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.instanceRef,
  }) : super.internal();

  final InstanceRef instanceRef;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(StaleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StaleProvider._internal(
        (ref) => create(ref as StaleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        instanceRef: instanceRef,
      ),
    );
  }

  @override
  FutureProviderElement<bool?> createElement() {
    return _StaleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StaleProvider && other.instanceRef == instanceRef;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, instanceRef.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StaleRef on FutureProviderRef<bool?> {
  /// The parameter `instanceRef` of this provider.
  InstanceRef get instanceRef;
}

class _StaleProviderElement extends FutureProviderElement<bool?> with StaleRef {
  _StaleProviderElement(super.provider);

  @override
  InstanceRef get instanceRef => (origin as StaleProvider).instanceRef;
}

String _$queryStatusHash() => r'13ceaaf641458ba1d886e031b56b05f93170dc6a';

/// See also [queryStatus].
@ProviderFor(queryStatus)
const queryStatusProvider = QueryStatusFamily();

/// See also [queryStatus].
class QueryStatusFamily extends Family<AsyncValue<String?>> {
  /// See also [queryStatus].
  const QueryStatusFamily();

  /// See also [queryStatus].
  QueryStatusProvider call(
    InstanceRef instanceRef,
    String queryKey,
  ) {
    return QueryStatusProvider(
      instanceRef,
      queryKey,
    );
  }

  @override
  QueryStatusProvider getProviderOverride(
    covariant QueryStatusProvider provider,
  ) {
    return call(
      provider.instanceRef,
      provider.queryKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'queryStatusProvider';
}

/// See also [queryStatus].
class QueryStatusProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [queryStatus].
  QueryStatusProvider(
    InstanceRef instanceRef,
    String queryKey,
  ) : this._internal(
          (ref) => queryStatus(
            ref as QueryStatusRef,
            instanceRef,
            queryKey,
          ),
          from: queryStatusProvider,
          name: r'queryStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$queryStatusHash,
          dependencies: QueryStatusFamily._dependencies,
          allTransitiveDependencies:
              QueryStatusFamily._allTransitiveDependencies,
          instanceRef: instanceRef,
          queryKey: queryKey,
        );

  QueryStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.instanceRef,
    required this.queryKey,
  }) : super.internal();

  final InstanceRef instanceRef;
  final String queryKey;

  @override
  Override overrideWith(
    FutureOr<String?> Function(QueryStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QueryStatusProvider._internal(
        (ref) => create(ref as QueryStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        instanceRef: instanceRef,
        queryKey: queryKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _QueryStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QueryStatusProvider &&
        other.instanceRef == instanceRef &&
        other.queryKey == queryKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, instanceRef.hashCode);
    hash = _SystemHash.combine(hash, queryKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QueryStatusRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `instanceRef` of this provider.
  InstanceRef get instanceRef;

  /// The parameter `queryKey` of this provider.
  String get queryKey;
}

class _QueryStatusProviderElement
    extends AutoDisposeFutureProviderElement<String?> with QueryStatusRef {
  _QueryStatusProviderElement(super.provider);

  @override
  InstanceRef get instanceRef => (origin as QueryStatusProvider).instanceRef;
  @override
  String get queryKey => (origin as QueryStatusProvider).queryKey;
}

String _$queryListHash() => r'ea408e262bdff1c21a42a737bb448649b3602020';

/// See also [QueryList].
@ProviderFor(QueryList)
final queryListProvider =
    AutoDisposeAsyncNotifierProvider<QueryList, QueryListState>.internal(
  QueryList.new,
  name: r'queryListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$queryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QueryList = AutoDisposeAsyncNotifier<QueryListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
