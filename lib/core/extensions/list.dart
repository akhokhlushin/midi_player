extension FindNearest on List<double> {
  bool containsNearest(double search) {
    for (final value in this) {
      if (value + 0.000051 >= search && value - 0.000051 <= search) {
        return true;
      }
    }

    return false;
  }
}
