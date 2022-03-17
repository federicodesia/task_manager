extension StringExtension on String {
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get toLowerSnakeCase => toLowerCase().replaceAll(" ", "_");
}