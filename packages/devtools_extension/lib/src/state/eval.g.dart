// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eval.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cachedQueryEval)
const cachedQueryEvalProvider = CachedQueryEvalProvider._();

final class CachedQueryEvalProvider extends $FunctionalProvider<
        AsyncValue<CachedQueryEval>, CachedQueryEval, FutureOr<CachedQueryEval>>
    with $FutureModifier<CachedQueryEval>, $FutureProvider<CachedQueryEval> {
  const CachedQueryEvalProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cachedQueryEvalProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cachedQueryEvalHash();

  @$internal
  @override
  $FutureProviderElement<CachedQueryEval> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CachedQueryEval> create(Ref ref) {
    return cachedQueryEval(ref);
  }
}

String _$cachedQueryEvalHash() => r'17a4908224d4adbf444895b2ba426d09f551e529';

@ProviderFor(eventStream)
const eventStreamProvider = EventStreamProvider._();

final class EventStreamProvider extends $FunctionalProvider<
        AsyncValue<AppEvent>, AppEvent, Stream<AppEvent>>
    with $FutureModifier<AppEvent>, $StreamProvider<AppEvent> {
  const EventStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventStreamProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventStreamHash();

  @$internal
  @override
  $StreamProviderElement<AppEvent> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppEvent> create(Ref ref) {
    return eventStream(ref);
  }
}

String _$eventStreamHash() => r'5688e637bf592e64205ad350c251c68a127d6e28';
