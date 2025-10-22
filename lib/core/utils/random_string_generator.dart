import 'dart:math';

abstract class RandomStringGenerator {
  String generateAlphanumeric(int len);
}

class RandomStringGeneratorImpl implements RandomStringGenerator {
  @override
  String generateAlphanumeric(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }
}
