class InterruptException implements Exception {
  final String message;

  InterruptException(this.message);

  @override
  String toString() => 'InterruptException($message)';
}

class UnexpectedException implements Exception {
  final String message;

  UnexpectedException(this.message);

  @override
  String toString() => 'UnexpectedException($message)';
}
