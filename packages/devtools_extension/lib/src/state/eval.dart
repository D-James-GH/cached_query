import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extension/src/state/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vm_service/vm_service.dart';

part 'eval.freezed.dart';
part 'eval.g.dart';

class CachedQueryEval {
  final EvalOnDartLibrary libraryEval;
  final Disposable disposable;
  CachedQueryEval(this.libraryEval, this.disposable);
}

@Riverpod(keepAlive: true)
Future<CachedQueryEval> cachedQueryEval(Ref ref) async {
  final service = await ref.watch(serviceProvider.future);
  final eval = EvalOnDartLibrary(
    'package:cached_query/src/cached_query.dart',
    service,
    serviceManager: serviceManager,
  );
  return CachedQueryEval(eval, Disposable());
}

enum EventType {
  queryCreated,
  queryDeleted,
  queryChanged,
  queryError,
  mutationCreated,
  mutationChanged,
  mutationReused;

  static EventType? fromString(String value) {
    final eventString = value.split(':').lastOrNull;
    return switch (eventString) {
      "query_changed" => EventType.queryChanged,
      "query_created" => EventType.queryCreated,
      "query_deleted" => EventType.queryDeleted,
      "query_error" => EventType.queryError,
      "mutation_created" => EventType.mutationCreated,
      "mutation_changed" => EventType.mutationChanged,
      "mutation_reused" => EventType.mutationReused,
      _ => null,
    };
  }
}

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent({
    required String name,
    required Map<String, dynamic> data,
    required EventType type,
  }) = _AppEvent;
}

@Riverpod(keepAlive: true)
Stream<AppEvent> eventStream(Ref ref) async* {
  final service = await ref.watch(serviceProvider.future);

  final stream = service.onExtensionEvent;

  await for (final event in stream) {
    final Event(extensionKind: name, extensionData: data) = event;
    final type = EventType.fromString(name ?? "");
    if (name != null && data != null && type != null) {
      final event = AppEvent(
        type: type,
        name: name,
        data: data.data,
      );
      yield event;
    }
  }
}
