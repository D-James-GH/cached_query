import 'dart:convert';

import 'package:devtools_extension/src/state/eval.dart';
import 'package:devtools_extension/src/state/query.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vm_service/vm_service.dart';

part 'query_details.g.dart';

part 'query_details.freezed.dart';

sealed class QueryStateDetails {
  String get status;
}

@freezed
class QueryStateDetailsJson extends QueryStateDetails
    with _$QueryStateDetailsJson {
  const factory QueryStateDetailsJson({
    required String dataRuntimeType,
    required String status,
    Map<String, dynamic>? data,
  }) = _QueryStateDetailsJson;
}

@freezed
class QueryStateDetailsString extends QueryStateDetails
    with _$QueryStateDetailsString {
  const factory QueryStateDetailsString({
    required String dataRuntimeType,
    required String status,
    String? data,
  }) = _QueryStateDetailsString;
}

@freezed
class InfiniteQueryDetailsJson extends QueryStateDetails
    with _$InfiniteQueryDetailsJson {
  const factory InfiniteQueryDetailsJson({
    required String status,
    required String dataRuntimeType,
    List<dynamic>? pages,
  }) = _InfiniteQueryDetailsJson;
}

@freezed
class QueryDetailsState with _$QueryDetailsState {
  const factory QueryDetailsState({
    required String key,
    required String type,
    bool? stale,
    required QueryStateDetails state,
  }) = _QueryDetailsState;
}

@riverpod
class QueryDetails extends _$QueryDetails {
  @override
  Future<QueryDetailsState> build(QueryInstance instance) async {
    final QueryInstance(:key, :valueRef, :type) = instance;
    ref.listen(eventStreamProvider, (prev, next) {
      if (next.value != null &&
          next.value!.type == EventType.queryChanged &&
          next.value!.data["key"] == key) {
        ref.invalidateSelf();
      }
    });
    final CachedQueryEval(:libraryEval, :disposable) =
        await ref.watch(cachedQueryEvalProvider.future);

    final status = ref.watch(queryStatusProvider(valueRef, key));
    final stale = ref.watch(staleProvider(valueRef));
    bool isJson = false;
    Instance data;
    try {
      data = await libraryEval.evalInstance(
        'json.encode(value.state.data)',
        isAlive: disposable,
        scope: {
          "value": instance.valueRef.id!,
        },
      );
      isJson = true;
    } catch (_) {
      data = await libraryEval.evalInstance(
        'value.state.data.toString()',
        isAlive: disposable,
        scope: {
          "value": instance.valueRef.id!,
        },
      );
    }
    final dataRuntimeType = await libraryEval.eval(
      'value.state.data.runtimeType',
      isAlive: disposable,
      scope: {
        "value": instance.valueRef.id!,
      },
    );

    if (type == "InfiniteQuery" && isJson) {
      return QueryDetailsState(
        key: key,
        type: type,
        stale: stale.value ?? false,
        state: InfiniteQueryDetailsJson(
          dataRuntimeType: dataRuntimeType?.valueAsString ?? "",
          status: status.value ?? "",
          pages: isJson ? jsonDecode(data.valueAsString ?? "") : null,
        ),
      );
    }
    if (isJson) {
      return QueryDetailsState(
        key: key,
        type: type,
        stale: stale.value ?? false,
        state: QueryStateDetailsJson(
          dataRuntimeType: dataRuntimeType?.valueAsString ?? "",
          data: jsonDecode(data.valueAsString ?? ""),
          status: status.value ?? "",
        ),
      );
    }

    return QueryDetailsState(
      key: key,
      type: type,
      stale: stale.value ?? false,
      state: QueryStateDetailsString(
        status: status.value ?? "",
        dataRuntimeType: dataRuntimeType?.valueAsString ?? "",
        data: data.valueAsString,
      ),
    );
  }

  void refresh() {
    final QueryInstance(:key, :valueRef) = instance;
    ref.invalidate(queryStatusProvider(valueRef, key));
    ref.invalidate(staleProvider(valueRef));
    ref.invalidateSelf();
  }
}
