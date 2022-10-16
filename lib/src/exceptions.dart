import 'models/issue_section/issue_section.dart';

/// Thrown when a [IssueSection.command] fails to execute / returns non-zero
/// exit code.
class CommandFailureException implements Exception {
  CommandFailureException(this.stepPrompt, this.exitCode);
  final String stepPrompt;
  final int exitCode;

  String get message =>
      'Command failed to execute at $stepPrompt prompt with exit code '
      '$exitCode.';

  @override
  String toString() => message;
}

/// Thrown when an unexpected error occurs.
class UnexpectedException implements Exception {
  UnexpectedException(this.message);
  final String message;

  @override
  String toString() => 'Unexpected exception with message: $message';
}

/// Thrown when the user interrupts the process by emptying the file and
/// closing it.
class UserInterruptException implements Exception {
  UserInterruptException(this.stepTitle);
  final String stepTitle;

  String get message => 'User inturrupted the process at $stepTitle prompt.';

  @override
  String toString() => message;
}
