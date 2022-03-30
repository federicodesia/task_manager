extension MapExtension on Map<dynamic, int> {

  int increment(dynamic key) {
    return update(
      key,
      (value) => ++value,
      ifAbsent: () => 1
    );
  }
}