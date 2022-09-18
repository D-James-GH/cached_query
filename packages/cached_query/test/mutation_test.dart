import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mutation_test.mocks.dart';

@GenerateMocks([Query])
void main() {
  group("Creating a mutation", () {
    test("Can create a mutation object", () {
      final mutation = Mutation<String, void>(
        queryFn: (_) => Future.value(""),
      );
      expect(mutation, isA<Mutation<String, void>>());
    });
    test("Optional key should be serializable", () {
      final key = ["this is a key", 1];
      final mutation = Mutation<String, void>(
        queryFn: (_) => Future.value(""),
        key: key,
      );
      expect(mutation.key, jsonEncode(key));
    });
  });
  group("Using a mutation", () {
    test("Calling a mutation returns a future<T>", () {
      final mutation = Mutation<String, void>(
        queryFn: (_) => Future.value(""),
      );
      expect(mutation.mutate(), isA<Future<String?>>());
    });
    test("Mutation returns the value of the queryFn", () async {
      const returnString = "return string";
      final mutation = Mutation<String, void>(
        queryFn: (_) => Future.value(returnString),
      );
      final res = await mutation.mutate();
      expect(res, returnString);
    });
  });
  group("Listening to a mutation", () {
    test("Creating a mutation emits a mutation state", () async {
      final mutation = Mutation<String, void>(
        queryFn: (_) => Future.value(""),
      )..mutate();
      final stream = mutation.stream;
      final res = await stream.first;
      expect(res, isA<MutationState<String>>());
    });
    test("mutations with key are equal", () async {
      const key = "key";
      Future<String> query(void _) => Future.value("");
      final mutation = Mutation<String, void>(queryFn: query, key: key);

      final mutation2 = Mutation<String, void>(queryFn: query, key: key);
      expect(mutation, same(mutation2));
    });
    test("Loading is scoped to key", () async {
      const key = "loading";
      int count = 0;

      Future<String> query(void _) => Future.value("");

      final mutation = Mutation<String, void>(queryFn: query, key: key);
      final mutation2 = Mutation<String, void>(queryFn: query, key: key);

      mutation2.stream.listen(
        expectAsync1(
          (event) {
            if (count == 1) {
              expect(event.status, QueryStatus.loading);
            }
            count++;
          },
          max: 3,
          count: 2,
        ),
      );
      mutation.mutate();
    });

    test("Stream should emit mutation response", () async {
      const res = "response";
      int count = 0;

      Future<String> query(void _) => Future.value(res);

      final mutation = Mutation<String, void>(queryFn: query);

      mutation.stream.listen(
        expectAsync1(
          (event) {
            if (count == 2) {
              expect(event.data, res);
            }
            count++;
          },
          max: 3,
          count: 2,
        ),
      );
      mutation.mutate();
    });
  });
  group("Callbacks", () {
    test("onStartMutation should be called before the queryFn", () async {
      final responses = <String>[];
      const res = "response";
      const onStart = "onstart";

      Future<String> query(void _) async {
        responses.add(res);
        return Future.value(res);
      }

      final mutation = Mutation<String, void>(
        queryFn: query,
        onStartMutation: (_) {
          responses.add(onStart);
        },
      );
      await mutation.mutate();
      expect(responses.first, onStart);
    });
    test("Return object of onSuccess should be passed to onError", () async {
      var responses = <String>[];
      const res = "response";
      const onStart = "onstart";

      Future<String> query(void _) async {
        responses.add(res);
        throw "something went wrong";
      }

      final mutation = Mutation<String, void>(
        queryFn: query,
        onStartMutation: (_) {
          final initialData = [...responses];
          responses.add(onStart);
          return initialData;
        },
        onError: (arg, error, fallback) => responses = fallback as List<String>,
      );
      await mutation.mutate();
      expect(responses, <String>[]);
    });

    test("onSuccess should be called after the queryFn", () async {
      final responses = <String>[];
      const res = "response";
      const onSuccess = "onSuccess";

      Future<String> query(void _) async {
        responses.add(res);
        return Future.value(res);
      }

      final mutation = Mutation<String, void>(
        queryFn: query,
        onSuccess: (_, __) {
          responses.add(onSuccess);
        },
      );
      await mutation.mutate();
      expect(responses.last, onSuccess);
    });
    test("onError should be called if mutation fails", () async {
      int errorCount = 0;
      final mutation = Mutation<String, void>(
        queryFn: (_) async => throw "Should throw",
        onError: (_, __, ___) {
          errorCount++;
        },
      );
      await mutation.mutate();
      expect(errorCount, 1);
    });
  });
  group("Optional side effects", () {
    test("Queries should be re-fetched", () async {
      const key = "refetch";
      final query = MockQuery<String>();
      when(query.key).thenReturn(key);
      CachedQuery.instance.addQuery(query);
      final mutation = Mutation<String, void>(
        refetchQueries: [key],
        queryFn: (_) async => "",
      );
      await mutation.mutate();
      verify(query.refetch());
      // expect(errorCount, 1);
    });
    test("Queries should be invalidated", () async {
      const key = "invalidate";
      final query = MockQuery<String>();
      when(query.key).thenReturn(key);
      CachedQuery.instance.addQuery(query);

      final mutation = Mutation<String, void>(
        invalidateQueries: [key],
        queryFn: (_) async => "",
      );
      await mutation.mutate();
      verify(query.invalidateQuery());
    });
  });
}
