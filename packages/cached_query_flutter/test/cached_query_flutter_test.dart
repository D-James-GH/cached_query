import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cached_query_flutter_test.mocks.dart';

@GenerateMocks([Query, InfiniteQuery, CachedQuery])
void main() {
  group("Refetch current queries", () {
    test("Should refetch query if hasListeners", () async {
      final query = MockQuery<String>();
      when(query.hasListener).thenReturn(true);
      when(query.key).thenReturn("hasListeners");
      final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryState(timeCreated: DateTime.now(), data: "");
      });
      cachedQuery.refetchCurrentQueries();

      verify(query.refetch());
    });
    test("Should refetch infinite query if hasListeners", () async {
      final query = MockInfiniteQuery<String, int>();
      when(query.key).thenReturn("infinite");
      when(query.hasListener).thenReturn(true);
      final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

      when(query.refetch()).thenAnswer((realInvocation) async {
        return InfiniteQueryState(timeCreated: DateTime.now(), data: [""]);
      });
      cachedQuery.refetchCurrentQueries();

      verify(query.refetch());
    });
    test("Should ignore infinite query if !hasListeners", () async {
      final query = MockInfiniteQuery<String, int>();
      when(query.key).thenReturn("infinite");
      when(query.hasListener).thenReturn(false);
      final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

      when(query.refetch()).thenAnswer((realInvocation) async {
        return InfiniteQueryState(timeCreated: DateTime.now(), data: [""]);
      });
      cachedQuery.refetchCurrentQueries();

      verifyNever(query.refetch());
    });
    test("Should ignore queries that don't have listeners", () async {
      final query = MockQuery<String>();
      final query2 = MockQuery<String>();
      when(query.hasListener).thenReturn(true);
      when(query2.hasListener).thenReturn(false);
      when(query.key).thenReturn("hasListeners");
      when(query2.key).thenReturn("hasListeners2");
      when(query.refetch()).thenAnswer((realInvocation) async {
        return QueryState(timeCreated: DateTime.now(), data: "");
      });
      when(query2.refetch()).thenAnswer((realInvocation) async {
        return QueryState(timeCreated: DateTime.now(), data: "");
      });
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..refetchCurrentQueries();

      verify(query.refetch());
      verifyNever(query2.refetch());
    });
  });
}
