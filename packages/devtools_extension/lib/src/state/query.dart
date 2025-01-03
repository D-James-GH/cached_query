import 'package:devtools_extension/src/state/eval.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vm_service/vm_service.dart';

part "query.freezed.dart";
part "query.g.dart";

@freezed
class QueryInstance with _$QueryInstance {
  const factory QueryInstance({
    required String key,
    required String type,
    required InstanceRef valueRef,
  }) = _QueryItem;
}

@freezed
class QueryListState with _$QueryListState {
  const factory QueryListState({
    String? selectedKey,
    required List<QueryInstance> queries,
  }) = _QueryState;
}

@riverpod
class QueryList extends _$QueryList {
  @override
  Future<QueryListState> build() async {
    ref.listen(eventStreamProvider, (_, next) {
      final value = next.value;
      if (value != null &&
          (value.type == EventType.queryCreated ||
              value.type == EventType.queryDeleted)) {
        ref.invalidateSelf();
      }
    });

    final queries = await _queries();

    if (state.value != null &&
        state.value!.selectedKey != null &&
        queries.every((element) => element.key != state.value!.selectedKey)) {
      return state.value!.copyWith(selectedKey: null, queries: queries);
    }

    return state.value?.copyWith(queries: queries) ??
        QueryListState(queries: queries);
  }

  void selectQuery(String key) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedKey: key));
  }

  Future<List<QueryInstance>> _queries() async {
    final CachedQueryEval(:libraryEval, :disposable) =
        await ref.watch(cachedQueryEvalProvider.future);

    final cacheRef = await libraryEval.eval(
      'CachedQuery.instance._queryCache',
      isAlive: disposable,
    );

    if (cacheRef == null) return [];

    final cache = await libraryEval.getInstance(
      cacheRef,
      disposable,
    );

    final fields = cache?.associations;

    if (fields == null) return [];

    final queries = <QueryInstance>[];

    for (var MapAssociation(key: keyRef as InstanceRef?, value: valueRef)
        in fields) {
      final key = keyRef?.valueAsString;
      final instanceRef = (await libraryEval.getInstance(
        valueRef,
        disposable,
      ));

      if (instanceRef != null && key != null) {
        final value = await libraryEval
            .eval('value.runtimeType', isAlive: disposable, scope: {
          "value": instanceRef.id!,
        });
        queries.add(
          QueryInstance(
            key: key,
            type: value?.name ?? "",
            valueRef: valueRef,
          ),
        );
      }
    }
    return queries;
  }
}

@Riverpod(keepAlive: true)
Future<bool?> stale(
  Ref ref,
  InstanceRef instanceRef,
) async {
  final CachedQueryEval(:libraryEval, :disposable) =
      await ref.watch(cachedQueryEvalProvider.future);
  ref.listen(eventStreamProvider, (_, __) {
    ref.invalidateSelf();
  });

  final stale = await libraryEval.eval(
    'value.stale',
    isAlive: disposable,
    scope: {
      "value": instanceRef.id!,
    },
  );
  if (stale == null) return null;
  return stale.valueAsString == "true";
}

@riverpod
Future<String?> queryStatus(
  Ref ref,
  InstanceRef instanceRef,
  String queryKey,
) async {
  ref.listen(eventStreamProvider, (prev, next) {
    if (next.value != null &&
        next.value!.type == EventType.queryChanged &&
        next.value!.data["key"] == queryKey) {
      ref.invalidateSelf();
    }
  });
  final CachedQueryEval(:libraryEval, :disposable) =
      await ref.watch(cachedQueryEvalProvider.future);

  final status = await libraryEval
      .eval('value.state.runtimeType', isAlive: disposable, scope: {
    "value": instanceRef.id!,
  });
  return status?.typeClass?.name;
}
