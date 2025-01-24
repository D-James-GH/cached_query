import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cached_query_flutter_test.mocks.dart';

@GenerateMocks([
  Query,
  InfiniteQuery,
  CachedQuery,
])
void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    provideDummy(QueryStatus<String>.initial(timeCreated: DateTime.now()));
    provideDummy(
      InfiniteQueryStatus<String, int>.initial(
        timeCreated: DateTime.now(),
        data: [],
      ),
    );
  });
  tearDown(CachedQuery.instance.reset);
  group("Refetch current queries", () {
    test("Should refetch query if hasListeners", () async {
      final query = MockQuery<String>();
      when(query.config).thenReturn(QueryConfigFlutter());
      when(query.hasListener).thenReturn(true);
      when(query.key).thenReturn("hasListeners");
      final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryStatus.initial(timeCreated: DateTime.now());
      });
      cachedQuery.refetchCurrentQueries();

      verify(query.refetch());
    });
    test("Should refetch infinite query if hasListeners", () async {
      final query = MockInfiniteQuery<String, int>();
      when(query.config).thenReturn(QueryConfigFlutter());
      when(query.key).thenReturn("infinite");
      when(query.hasListener).thenReturn(true);
      final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

      when(query.refetch()).thenAnswer((realInvocation) async {
        return InfiniteQueryStatus<String, int>.initial(
          timeCreated: DateTime.now(),
          data: [""],
        );
      });
      cachedQuery.refetchCurrentQueries();

      verify(query.refetch());
    });
    test("Should ignore infinite query if !hasListeners", () async {
      final query = MockInfiniteQuery<String, int>();
      when(query.config).thenReturn(QueryConfigFlutter());
      when(query.key).thenReturn("infinite");
      when(query.hasListener).thenReturn(false);
      final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

      when(query.refetch()).thenAnswer((realInvocation) async {
        return InfiniteQueryStatus<String, int>.initial(
          timeCreated: DateTime.now(),
          data: [""],
        );
      });
      cachedQuery.refetchCurrentQueries();

      verifyNever(query.refetch());
    });
    test("Should ignore queries that don't have listeners", () async {
      final query = MockQuery<String>();
      final query2 = MockQuery<String>();
      when(query.config).thenReturn(QueryConfigFlutter());
      when(query2.config).thenReturn(QueryConfigFlutter());
      when(query.hasListener).thenReturn(true);
      when(query2.hasListener).thenReturn(false);
      when(query.key).thenReturn("hasListeners");
      when(query2.key).thenReturn("hasListeners2");
      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryStatus<String>.initial(
          timeCreated: DateTime.now(),
          data: "",
        );
      });
      when(query2.refetch()).thenAnswer((realInvocation) async {
        return QueryStatus.initial(timeCreated: DateTime.now(), data: "");
      });
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..refetchCurrentQueries();

      verify(query.refetch());
      verifyNever(query2.refetch());
    });
    test("Can set refetch config per query", () async {
      final query = MockQuery<String>();
      when(query.config).thenReturn(
        QueryConfigFlutter(),
      );
      when(query.hasListener).thenReturn(true);
      when(query.key).thenReturn("hasListeners");
      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryStatus.initial(timeCreated: DateTime.now(), data: "");
      });
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..refetchCurrentQueries()
        ..refetchCurrentQueries(RefetchReason.connectivity);

      verify(query.refetch()).called(2);
    });

    test("Can set refetch to false per query", () async {
      final query = MockQuery<String>();
      when(query.config).thenReturn(
        QueryConfigFlutter(
          refetchOnResume: false,
          refetchOnConnection: false,
        ),
      );
      when(query.hasListener).thenReturn(true);
      when(query.key).thenReturn("hasListeners");
      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryStatus.initial(timeCreated: DateTime.now(), data: "");
      });
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..refetchCurrentQueries(RefetchReason.resume)
        ..refetchCurrentQueries(RefetchReason.connectivity);

      verifyNever(query.refetch());
    });
    test(
        "Can prevent refetchOnResume and refetchOnConnection using shouldRefetch",
        () async {
      final query = MockQuery<String>();
      when(query.config).thenReturn(
        QueryConfigFlutter(
          shouldRefetch: (query, fromStorage) => false,
        ),
      );
      when(query.hasListener).thenReturn(true);
      when(query.key).thenReturn("hasListeners");
      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryInitial(timeCreated: DateTime.now(), data: "");
      });
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..refetchCurrentQueries(RefetchReason.resume)
        ..refetchCurrentQueries(RefetchReason.connectivity);

      verifyNever(query.refetch());
    });
    test("Can override global config", () {
      CachedQuery.instance.configFlutter(
        config: QueryConfigFlutter(refetchOnResume: false),
      );
      final q = Query<String>(
        key: "global",
        queryFn: () async => "",
        config: QueryConfigFlutter(),
      );
      expect((q.config as QueryConfigFlutter).refetchOnResume, true);
    });
  });
}
