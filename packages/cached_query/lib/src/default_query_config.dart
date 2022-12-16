// import 'package:cached_query/src/cached_query.dart';
// import 'package:cached_query/src/query_config.dart';
//
// /// {@template defaultQueryConfig}
// /// Creates a default config for all queries.
// /// {@endtemplate}
// class DefaultQueryConfig {
//   @override
//   Duration cacheDuration;
//
//   @override
//   Duration refetchDuration;
//
//   @override
//   Serializer? serializer;
//
//   @override
//   bool shouldRethrow;
//
//   @override
//   bool storeQuery;
//
//   @override
//   bool ignoreCacheDuration;
//
//   /// {@macro defaultQueryConfig}
//   DefaultQueryConfig({
//     this.ignoreCacheDuration = false,
//     this.serializer,
//     this.storeQuery = true,
//     this.refetchDuration = const Duration(seconds: 4),
//     this.cacheDuration = const Duration(minutes: 5),
//     this.shouldRethrow = false,
//   });
//
//   /// Merges a different QueryConfig with this.
//   DefaultQueryConfig merge([QueryConfig? other]) {
//     if (other == null) {
//       return this;
//     }
//     return copyWith(
//       ignoreCacheDuration: other.ignoreCacheDuration,
//       cacheDuration: other.cacheDuration,
//       serializer: other.serializer,
//       refetchDuration: other.refetchDuration,
//       shouldRethrow: other.shouldRethrow,
//       storeQuery: other.storeQuery,
//     );
//   }
//
//   /// Creates a copy of the config with the given fields replaced by new ones.
//   DefaultQueryConfig copyWith({
//     bool? storeQuery,
//     Duration? cacheDuration,
//     Duration? refetchDuration,
//     Serializer? serializer,
//     bool? shouldRethrow,
//     bool? ignoreCacheDuration,
//   }) {
//     return DefaultQueryConfig(
//       ignoreCacheDuration: ignoreCacheDuration ?? this.ignoreCacheDuration,
//       storeQuery: storeQuery ?? this.storeQuery,
//       cacheDuration: cacheDuration ?? this.cacheDuration,
//       refetchDuration: refetchDuration ?? this.refetchDuration,
//       serializer: serializer ?? this.serializer,
//       shouldRethrow: shouldRethrow ?? this.shouldRethrow,
//     );
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DefaultQueryConfig &&
//           runtimeType == other.runtimeType &&
//           cacheDuration == other.cacheDuration &&
//           refetchDuration == other.refetchDuration &&
//           serializer == other.serializer &&
//           shouldRethrow == other.shouldRethrow &&
//           storeQuery == other.storeQuery &&
//           ignoreCacheDuration == other.ignoreCacheDuration;
//
//   @override
//   int get hashCode =>
//       cacheDuration.hashCode ^
//       refetchDuration.hashCode ^
//       serializer.hashCode ^
//       shouldRethrow.hashCode ^
//       storeQuery.hashCode ^
//       ignoreCacheDuration.hashCode;
// }
