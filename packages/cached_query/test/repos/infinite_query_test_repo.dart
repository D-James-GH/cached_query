class InfiniteQueryTestRepository {
  static const key = "infiniteQuery";
  static const returnString = "infiniteQuery";

  Future<String> getPosts(int page) {
    return Future.value(returnString + page.toString());
  }

  Future<int> getPage(int page) {
    return Future.value(page);
  }
}
