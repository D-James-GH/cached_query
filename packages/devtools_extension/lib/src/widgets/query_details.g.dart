// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DetailsExpanded)
const detailsExpandedProvider = DetailsExpandedProvider._();

final class DetailsExpandedProvider
    extends $NotifierProvider<DetailsExpanded, bool> {
  const DetailsExpandedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'detailsExpandedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$detailsExpandedHash();

  @$internal
  @override
  DetailsExpanded create() => DetailsExpanded();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$detailsExpandedHash() => r'6d39796c097482a846184e154fd161c6289f3dde';

abstract class _$DetailsExpanded extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
