// ignore_for_file: public_member_api_docs

import 'package:cached_query/src/query/_query.dart';
import 'package:cached_query/src/query_state.dart';

/// The fetch direction of an infinite query.
enum InfiniteQueryDirection {
  ///
  forward,

  ///
  backward;

  /// Fetch forward
  bool get isForward => this == InfiniteQueryDirection.forward;

  /// Fetch backward
  bool get isBackward => this == InfiniteQueryDirection.backward;
}

/// {@template infiniteFetchOptions}
/// Options for fetching an infinite query.
/// {@endtemplate}
class InfiniteFetchOptions extends FetchOptions {
  /// The direction of the fetch. Currently only forward is supported.
  final InfiniteQueryDirection? direction;

  /// The number of pages to prefetch.
  final int? prefetchPages;

  /// {@macro infiniteFetchOptions}
  InfiniteFetchOptions({
    this.prefetchPages,
    this.direction,
  });
}

/// Merge the refetch result with the current result.
/// Use to have full control over how many pages are refetched.
///
/// Returning a value will replace the cache with that data and prevent further pages being
/// refetched.
///
/// EG.
/// 1. If the first page is different only return the first page
///
/// ```dart
/// final OnPageRefetched<T, Arg> onPageRefetched = (
///   T page,
///   InfiniteQueryData<T, Arg> currentResult,
///   InfiniteQueryData<T, Arg> cachedData,
/// ) {
///   if (page != cachedData.pages.firstOrNull && currentResult.pages.length == 1) {
///     return currentResult;
///   }
///   return null;
/// }
///
/// ```
/// 2. If you have a list that is only added to in one direction you could skip refetching the data
/// if the first page is the same as the cached. Below only refetches the whole list if the first pages are different.
///
/// ```dart
/// final OnPageRefetched<T, Arg> onPageRefetched = (
///   T page,
///   InfiniteQueryData<T, Arg> currentResult,
///   InfiniteQueryData<T, Arg> cachedData,
/// ) {
///   if (page == cachedData.pages.firstOrNull && currentResult.pages.length == 1) {
///     return cachedData;
///   }
///   return null;
/// }
///
/// ```
///
typedef OnPageRefetched<T, Arg> = InfiniteQueryData<T, Arg>? Function(
  T page,
  InfiniteQueryData<T, Arg> currentResult,
  InfiniteQueryData<T, Arg> cachedData,
);

/// Function to fetch and refetch an infinite query.
typedef InfiniteFetchFunc<T, Arg> = Future<InfiniteQueryData<T, Arg>> Function({
  required FetchOptions options,
  InfiniteQueryData<T, Arg>? state,
});

/// {@template infiniteFetch}
/// Function to fetch and refetch an infinite query.
/// {@endtemplate}
/// Function to fetch and refetch an infinite query.
class InfiniteFetch<T, Arg>
    implements FetchFunction<InfiniteQueryData<T, Arg>> {
  final GetNextArg<T, Arg> getNextArg;
  final OnPageRefetched<T, Arg>? onPageRefetched;
  final InfiniteQueryFunc<T, Arg> queryFn;
  final Arg? initialArg;

  /// {@macro infiniteFetch}
  InfiniteFetch({
    required this.getNextArg,
    required this.onPageRefetched,
    required this.queryFn,
    required this.initialArg,
  });

  ///
  @override
  Future<InfiniteQueryData<T, Arg>> call({
    required FetchOptions options,
    InfiniteQueryData<T, Arg>? state,
  }) async {
    assert(
      options is InfiniteFetchOptions,
      "Options must be of type InfiniteFetchOptions, but was ${options.runtimeType}. Please report this issue.",
    );
    final InfiniteFetchOptions(:direction, :prefetchPages) =
        options as InfiniteFetchOptions;
    state ??= InfiniteQueryData(pages: [], args: []);
    final InfiniteQueryData<T, Arg>(
      pages: currentPages,
      args: currentPageParams
    ) = state;

    if (direction == null) {
      final totalPages = prefetchPages ?? currentPages.length;
      var result = InfiniteQueryData<T, Arg>(
        pages: [],
        args: [],
      );
      var i = 0;
      do {
        final arg = i == 0
            ? currentPageParams.firstOrNull ?? initialArg
            : getNextArg(result);
        if (arg == null) {
          break;
        }

        final res = await queryFn(arg);
        result = InfiniteQueryData(
          pages: [...result.pages, res],
          args: [...result.args, arg],
        );

        if (onPageRefetched != null) {
          final continueFetching = onPageRefetched!(res, result, state);
          if (continueFetching != null) {
            result = continueFetching;
            break;
          }
        }

        i++;
      } while (i < totalPages);

      return result;
    }

    // ======================================================================

    final arg = (direction.isForward ? getNextArg(state) : null);
    if (arg == null) {
      return state;
    }

    final res = await queryFn(arg);

    return switch (direction) {
      InfiniteQueryDirection.forward => InfiniteQueryData(
          pages: [...state.pages, res],
          args: [...state.args, arg],
        ),
      InfiniteQueryDirection.backward => InfiniteQueryData(
          pages: [res, ...state.pages],
          args: [arg, ...state.args],
        ),
    };
  }
}
