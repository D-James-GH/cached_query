const returnString = "I am a return string";

Future<String> fetchFunction([Duration duration = Duration.zero]) {
  return Future.delayed(
    duration,
    () => returnString,
  );
}
