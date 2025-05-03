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

class InfiniteFetchOptions extends FetchOptions {
  final InfiniteQueryDirection? direction;
  final int? prefetchPages;
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
/// final MergeRefetchResult<T, Arg> mergeRefetchResult = (
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
/// final MergeRefetchResult<T, Arg> mergeRefetchResult = (
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
typedef MergeRefetchResult<T, Arg> = InfiniteQueryData<T, Arg>? Function(
  T page,
  InfiniteQueryData<T, Arg> currentResult,
  InfiniteQueryData<T, Arg> cachedData,
);

/// Function to fetch and refetch an infinite query.
typedef InfiniteFetchFunc<T, Arg> = Future<InfiniteQueryData<T, Arg>> Function({
  required FetchOptions options,
  InfiniteQueryData<T, Arg>? state,
});

/// Function to fetch and refetch an infinite query.
InfiniteFetchFunc<T, Arg> infiniteFetch<T, Arg>({
  required GetNextArg<T, Arg> getNextArg,
  required MergeRefetchResult<T, Arg>? mergeRefetchResult,
  required InfiniteQueryFunc<T, Arg> queryFn,
  required Arg? initialArg,
}) {
  return ({
    required options,
    state,
  }) async {
    assert(
      options is InfiniteFetchOptions,
      "Options must be of type InfiniteFetchOptions, but was ${options.runtimeType}. Please report this issue.",
    );
    final InfiniteFetchOptions(:direction, :prefetchPages) =
        options as InfiniteFetchOptions;
    state ??= InfiniteQueryData(pages: [], pageParams: []);
    final InfiniteQueryData<T, Arg>(
      pages: currentPages,
      pageParams: currentPageParams
    ) = state;

    if (direction == null) {
      final totalPages = prefetchPages ?? currentPages.length;
      var result = InfiniteQueryData<T, Arg>(
        pages: [],
        pageParams: [],
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
          pageParams: [...result.pageParams, arg],
        );

        if (mergeRefetchResult != null) {
          final continueFetching = mergeRefetchResult(res, result, state);
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
          pageParams: [...state.pageParams, arg],
        ),
      InfiniteQueryDirection.backward => InfiniteQueryData(
          pages: [res, ...state.pages],
          pageParams: [arg, ...state.pageParams],
        ),
    };
  };
}
