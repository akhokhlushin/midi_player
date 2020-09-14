extension FindNearest on List<double> {
  bool containsNearest(num search, double delta) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      final int mid = ((low + high) / 2).floor();
      final value = this[mid];

      if (value >= search && value - delta <= search) {
        return true;
      } else if (value > search) {
        high = mid - 1;
      } else {
        low = mid + 1;
      }
    }

    return false;
  }

  bool contains(int search) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      final int mid = ((low + high) / 2).floor();
      final value = this[mid];

      if (value == search) {
        return true;
      } else if (value > search) {
        high = mid - 1;
      } else {
        low = mid + 1;
      }
    }

    return false;
  }

  // double nearest(int search) {
  //   int low = 0;
  //   int high = length - 1;

  //   while (low <= high) {
  //     final int mid = ((low + high) / 2).floor();
  //     final value = this[mid];
  //     final next = this[mid + 1];

  //     if (search <= next && search >= value) {
  //       return next;
  //     } else if (value > search) {
  //       high = mid - 1;
  //     } else {
  //       low = mid + 1;
  //     }
  //   }

  //   return null;
  // }
}
