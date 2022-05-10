class ApiException implements Exception {
  final List<String> _errors = List.empty(growable: true);

  List<String> get errors => List.unmodifiable(_errors);

  ApiException._();

  factory ApiException.fromJsonContentKey(dynamic content) {
    final ApiException exception = ApiException._();

    // `content` will be String or List<String>.
    if (content is String) {
      exception._errors.add(content);
    } else if (content is List<dynamic>) {
      for (var element in content) {
        exception._errors.add(element);
      }
    }
    return exception;
  }

  @override
  String toString() {
    return errors.toString();
  }
}
