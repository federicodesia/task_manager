import 'package:collection/collection.dart';

T? enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhereOrNull((type) => type.toString().split(".").last.toUpperCase() == value.toUpperCase());
}