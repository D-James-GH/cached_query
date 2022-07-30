class TitleWithEquality {
  final String title;

  TitleWithEquality(this.title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TitleWithEquality &&
          runtimeType == other.runtimeType &&
          title == other.title;

  @override
  int get hashCode => title.hashCode;
}
