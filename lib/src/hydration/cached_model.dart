abstract class CachedModel<T> {
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

class CachedHydration {}
