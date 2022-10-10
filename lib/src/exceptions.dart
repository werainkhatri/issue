import 'models/issue_section/issue_section.dart';

/// Thrown when the user interrupts the process by emptying the file and
/// closing it.
class UserInterruptException implements Exception {
  final String stepTitle;

  UserInterruptException(this.stepTitle);

  String get message => 'User inturrupted the process at $stepTitle prompt.';

  @override
  String toString() => message;
}

/// Thrown when a [IssueSection.command] fails to execute / returns non-zero
/// exit code.
class CommandFailureException implements Exception {
  final String stepPrompt;
  final int exitCode;

  CommandFailureException(this.stepPrompt, this.exitCode);

  String get message =>
      'Command failed to execute at $stepPrompt prompt with exit code $exitCode.';

  @override
  String toString() => message;
}

/// Thrown when an unexpected error occurs.
class UnexpectedException implements Exception {
  final String message;

  UnexpectedException(this.message);

  @override
  String toString() => 'Unexpected exception with message: $message';
}
