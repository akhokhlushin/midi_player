extension DurationExt on Duration {
  Duration operator /(num i) =>
      Duration(milliseconds: (inMilliseconds / i).floor());
}

extension DurationListExt on List<Duration> {
  bool containsNearest(Duration search) {
    int low = 0;
    int high = length - 1;

    const delta = Duration(milliseconds: 30);

    while (low <= high) {
      final int mid = ((low + high) / 2).floor();
      final value = this[mid];

      if (value - delta <= search && value + delta >= search) {
        return true;
      } else if (value > search) {
        high = mid - 1;
      } else {
        low = mid + 1;
      }
    }

    return false;
  }
}
