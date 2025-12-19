// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(service)
const serviceProvider = ServiceProvider._();

final class ServiceProvider extends $FunctionalProvider<AsyncValue<VmService>,
        VmService, FutureOr<VmService>>
    with $FutureModifier<VmService>, $FutureProvider<VmService> {
  const ServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'serviceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$serviceHash();

  @$internal
  @override
  $FutureProviderElement<VmService> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<VmService> create(Ref ref) {
    return service(ref);
  }
}

String _$serviceHash() => r'a29d7280d3b0febc545a33476f49cacef0234eed';
