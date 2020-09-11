extension FindNearest on List<double> {
  bool containsNearest(double search) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      final int mid = ((low + high) / 2).floor();
      final value = this[mid];

      if (value + 0.0000251 >= search && value - 0.0000251 <= search) {
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
