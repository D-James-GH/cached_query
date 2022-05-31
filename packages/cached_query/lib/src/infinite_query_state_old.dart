// import 'package:cached_query/cached_query.dart';
//
// /// {@template infiniteQueryState}
// /// [InfiniteQueryState] holds the current state of an [InfiniteQuery]
// /// {@endTemplate}
// class InfiniteQueryState<T> extends StateBase<List<T>> {
//   /// Current page index
//   final int currentPage;
//
//   /// True if there are no more pages available to fetch.
//   ///
//   /// Set to true if [GetNextArg] has returned null.
//   final bool hasReachedMax;
//
//   /// Get the last infinite_query_state.dartpage in the [data]
//   T? get lastPage => data.isNotNullOrEmpty ? data[data.length - 1] : null;
//
//   /// {@macro infiniteQueryState}
//   const InfiniteQueryState({
//     this.hasReachedMax = false,
//     required this.data,
//     this.status = QueryStatus.initial,
//     this.error,
//     required this.timeCreated,
//     required this.currentPage,
//   });
//
//   /// Creates a copy of the current [InfiniteQueryState] with the given filed
//   /// replaced.
//   InfiniteQueryState<T> copyWith({
//     List<T>? data,
//     QueryStatus? status,
//     bool? hasReachedMax,
//     DateTime? timeCreated,
//     dynamic error,
//   }) {
//     return InfiniteQueryState(
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//       error: error ?? this.error,
//       data: data ?? this.data,
//       status: status ?? this.status,
//       currentPage: currentPage,
//       timeCreated: timeCreated ?? this.timeCreated,
//     );
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is InfiniteQueryState &&
//           runtimeType == other.runtimeType &&
//           data == other.data &&
//           timeCreated == other.timeCreated &&
//           error == other.error &&
//           hasReachedMax == other.hasReachedMax &&
//           currentPage == other.currentPage &&
//           status == other.status;
//
//   @override
//   int get hashCode =>
//       runtimeType.hashCode ^
//       data.hashCode ^
//       status.hashCode ^
//       error.hashCode ^
//       currentPage.hashCode ^
//       hasReachedMax.hashCode;
// }
