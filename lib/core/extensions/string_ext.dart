extension StringFormatExtension on String {
  String format(Map<String, dynamic> values) {
    var result = this;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
