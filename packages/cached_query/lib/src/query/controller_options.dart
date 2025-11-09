import 'package:cached_query/cached_query.dart';

/// Private options for the controller.
class ControllerOptions<Data> {
  ///
  const ControllerOptions({
    required this.storeQuery,
    required this.storageDuration,
    required this.cacheDuration,
    required this.ignoreCacheDuration,
    required this.storageSerializer,
    required this.storageDeserializer,
  });

  ///
  final bool storeQuery;

  ///
  final Duration cacheDuration;

  ///
  final bool ignoreCacheDuration;

  ///
  final Duration? storageDuration;

  ///
  final Serializer<Data>? storageSerializer;

  ///
  final Deserializer<Data>? storageDeserializer;
}
