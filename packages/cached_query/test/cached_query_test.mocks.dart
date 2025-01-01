// Mocks generated by Mockito 5.4.4 from annotations
// in cached_query/test/cached_query_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:cached_query/cached_query.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeObject_0 extends _i1.SmartFake implements Object {
  _FakeObject_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQueryConfig_1 extends _i1.SmartFake implements _i2.QueryConfig {
  _FakeQueryConfig_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [StorageInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageInterface extends _i1.Mock implements _i2.StorageInterface {
  MockStorageInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.FutureOr<_i2.StoredQuery?> get(String? key) =>
      (super.noSuchMethod(Invocation.method(
        #get,
        [key],
      )) as _i3.FutureOr<_i2.StoredQuery?>);

  @override
  void delete(String? key) => super.noSuchMethod(
        Invocation.method(
          #delete,
          [key],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void put(_i2.StoredQuery? query) => super.noSuchMethod(
        Invocation.method(
          #put,
          [query],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void deleteAll() => super.noSuchMethod(
        Invocation.method(
          #deleteAll,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [Query].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuery<T> extends _i1.Mock implements _i2.Query<T> {
  MockQuery() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get key => (super.noSuchMethod(
        Invocation.getter(#key),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#key),
        ),
      ) as String);

  @override
  Object get unencodedKey => (super.noSuchMethod(
        Invocation.getter(#unencodedKey),
        returnValue: _FakeObject_0(
          this,
          Invocation.getter(#unencodedKey),
        ),
      ) as Object);

  @override
  _i2.QueryConfig get config => (super.noSuchMethod(
        Invocation.getter(#config),
        returnValue: _FakeQueryConfig_1(
          this,
          Invocation.getter(#config),
        ),
      ) as _i2.QueryConfig);

  @override
  _i2.QueryStatus<T> get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i4.dummyValue<_i2.QueryStatus<T>>(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.QueryStatus<T>);

  @override
  bool get stale => (super.noSuchMethod(
        Invocation.getter(#stale),
        returnValue: false,
      ) as bool);

  @override
  bool get hasListener => (super.noSuchMethod(
        Invocation.getter(#hasListener),
        returnValue: false,
      ) as bool);

  @override
  _i3.Stream<_i2.QueryStatus<T>> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i3.Stream<_i2.QueryStatus<T>>.empty(),
      ) as _i3.Stream<_i2.QueryStatus<T>>);

  @override
  _i3.Future<_i2.QueryStatus<T>> get result => (super.noSuchMethod(
        Invocation.getter(#result),
        returnValue: _i3.Future<_i2.QueryStatus<T>>.value(
            _i4.dummyValue<_i2.QueryStatus<T>>(
          this,
          Invocation.getter(#result),
        )),
      ) as _i3.Future<_i2.QueryStatus<T>>);

  @override
  _i3.Future<_i2.QueryStatus<T>> refetch() => (super.noSuchMethod(
        Invocation.method(
          #refetch,
          [],
        ),
        returnValue: _i3.Future<_i2.QueryStatus<T>>.value(
            _i4.dummyValue<_i2.QueryStatus<T>>(
          this,
          Invocation.method(
            #refetch,
            [],
          ),
        )),
      ) as _i3.Future<_i2.QueryStatus<T>>);

  @override
  void update(_i2.UpdateFunc<T>? updateFn) => super.noSuchMethod(
        Invocation.method(
          #update,
          [updateFn],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void invalidateQuery() => super.noSuchMethod(
        Invocation.method(
          #invalidateQuery,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void deleteQuery({bool? deleteStorage = false}) => super.noSuchMethod(
        Invocation.method(
          #deleteQuery,
          [],
          {#deleteStorage: deleteStorage},
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [InfiniteQuery].
///
/// See the documentation for Mockito's code generation for more information.
class MockInfiniteQuery<T, Arg> extends _i1.Mock
    implements _i2.InfiniteQuery<T, Arg> {
  MockInfiniteQuery() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get forceRevalidateAll => (super.noSuchMethod(
        Invocation.getter(#forceRevalidateAll),
        returnValue: false,
      ) as bool);

  @override
  bool get revalidateAll => (super.noSuchMethod(
        Invocation.getter(#revalidateAll),
        returnValue: false,
      ) as bool);

  @override
  _i3.Future<_i2.InfiniteQueryStatus<T, Arg>> get result => (super.noSuchMethod(
        Invocation.getter(#result),
        returnValue: _i3.Future<_i2.InfiniteQueryStatus<T, Arg>>.value(
            _i4.dummyValue<_i2.InfiniteQueryStatus<T, Arg>>(
          this,
          Invocation.getter(#result),
        )),
      ) as _i3.Future<_i2.InfiniteQueryStatus<T, Arg>>);

  @override
  String get key => (super.noSuchMethod(
        Invocation.getter(#key),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#key),
        ),
      ) as String);

  @override
  Object get unencodedKey => (super.noSuchMethod(
        Invocation.getter(#unencodedKey),
        returnValue: _FakeObject_0(
          this,
          Invocation.getter(#unencodedKey),
        ),
      ) as Object);

  @override
  _i2.QueryConfig get config => (super.noSuchMethod(
        Invocation.getter(#config),
        returnValue: _FakeQueryConfig_1(
          this,
          Invocation.getter(#config),
        ),
      ) as _i2.QueryConfig);

  @override
  _i2.InfiniteQueryStatus<T, Arg> get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i4.dummyValue<_i2.InfiniteQueryStatus<T, Arg>>(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.InfiniteQueryStatus<T, Arg>);

  @override
  bool get stale => (super.noSuchMethod(
        Invocation.getter(#stale),
        returnValue: false,
      ) as bool);

  @override
  bool get hasListener => (super.noSuchMethod(
        Invocation.getter(#hasListener),
        returnValue: false,
      ) as bool);

  @override
  _i3.Stream<_i2.InfiniteQueryStatus<T, Arg>> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i3.Stream<_i2.InfiniteQueryStatus<T, Arg>>.empty(),
      ) as _i3.Stream<_i2.InfiniteQueryStatus<T, Arg>>);

  @override
  _i3.Future<_i2.InfiniteQueryStatus<T, Arg>?> getNextPage() =>
      (super.noSuchMethod(
        Invocation.method(
          #getNextPage,
          [],
        ),
        returnValue: _i3.Future<_i2.InfiniteQueryStatus<T, Arg>?>.value(),
      ) as _i3.Future<_i2.InfiniteQueryStatus<T, Arg>?>);

  @override
  _i3.Future<_i2.InfiniteQueryStatus<T, Arg>> refetch() => (super.noSuchMethod(
        Invocation.method(
          #refetch,
          [],
        ),
        returnValue: _i3.Future<_i2.InfiniteQueryStatus<T, Arg>>.value(
            _i4.dummyValue<_i2.InfiniteQueryStatus<T, Arg>>(
          this,
          Invocation.method(
            #refetch,
            [],
          ),
        )),
      ) as _i3.Future<_i2.InfiniteQueryStatus<T, Arg>>);

  @override
  void update(_i2.UpdateFunc<List<T>>? updateFn) => super.noSuchMethod(
        Invocation.method(
          #update,
          [updateFn],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool hasReachedMax() => (super.noSuchMethod(
        Invocation.method(
          #hasReachedMax,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  void invalidateQuery() => super.noSuchMethod(
        Invocation.method(
          #invalidateQuery,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void deleteQuery({bool? deleteStorage = false}) => super.noSuchMethod(
        Invocation.method(
          #deleteQuery,
          [],
          {#deleteStorage: deleteStorage},
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
