// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queryDetailsHash() => r'967b9dd429b634e1c1a44e8b5db1ab62beae4ed0';

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

abstract class _$QueryDetails
    extends BuildlessAutoDisposeAsyncNotifier<QueryDetailsState> {
  late final QueryInstance instance;

  FutureOr<QueryDetailsState> build(
    QueryInstance instance,
  );
}

/// See also [QueryDetails].
@ProviderFor(QueryDetails)
const queryDetailsProvider = QueryDetailsFamily();

/// See also [QueryDetails].
class QueryDetailsFamily extends Family<AsyncValue<QueryDetailsState>> {
  /// See also [QueryDetails].
  const QueryDetailsFamily();

  /// See also [QueryDetails].
  QueryDetailsProvider call(
    QueryInstance instance,
  ) {
    return QueryDetailsProvider(
      instance,
    );
  }

  @override
  QueryDetailsProvider getProviderOverride(
    covariant QueryDetailsProvider provider,
  ) {
    return call(
      provider.instance,
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
  String? get name => r'queryDetailsProvider';
}

/// See also [QueryDetails].
class QueryDetailsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    QueryDetails, QueryDetailsState> {
  /// See also [QueryDetails].
  QueryDetailsProvider(
    QueryInstance instance,
  ) : this._internal(
          () => QueryDetails()..instance = instance,
          from: queryDetailsProvider,
          name: r'queryDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$queryDetailsHash,
          dependencies: QueryDetailsFamily._dependencies,
          allTransitiveDependencies:
              QueryDetailsFamily._allTransitiveDependencies,
          instance: instance,
        );

  QueryDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.instance,
  }) : super.internal();

  final QueryInstance instance;

  @override
  FutureOr<QueryDetailsState> runNotifierBuild(
    covariant QueryDetails notifier,
  ) {
    return notifier.build(
      instance,
    );
  }

  @override
  Override overrideWith(QueryDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: QueryDetailsProvider._internal(
        () => create()..instance = instance,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        instance: instance,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QueryDetails, QueryDetailsState>
      createElement() {
    return _QueryDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QueryDetailsProvider && other.instance == instance;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, instance.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QueryDetailsRef
    on AutoDisposeAsyncNotifierProviderRef<QueryDetailsState> {
  /// The parameter `instance` of this provider.
  QueryInstance get instance;
}

class _QueryDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QueryDetails,
        QueryDetailsState> with QueryDetailsRef {
  _QueryDetailsProviderElement(super.provider);

  @override
  QueryInstance get instance => (origin as QueryDetailsProvider).instance;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
