class StringUtils {
  ///
  /// Divide la cadena dada [s] en fragmentos con el [chunkSize] dado.
  ///
  static List<String> chunk(String s, int chunkSize) {
    var chunked = <String>[];
    for (var i = 0; i < s.length; i += chunkSize) {
      var end = (i + chunkSize < s.length) ? i + chunkSize : s.length;
      chunked.add(s.substring(i, end));
    }
    return chunked;
  }

  static String convertPayloadToJson(String payloadString) {
    final jsonString = payloadString.replaceAllMapped(
      RegExp(r'(\w+):\s*([^,}]+)'),
      (match) => '"${match[1]}": "${match[2]}"',
    );
    return jsonString;
  }
}
