extension DurationExt on Duration {
  Duration operator /(num i) =>
      Duration(milliseconds: (inMilliseconds / i).floor());
}
