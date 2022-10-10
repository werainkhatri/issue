import 'exceptions.dart';
import 'issue_builder.dart';
import 'models/models.dart';
import 'utils.dart';

/// Builds an issue from the given [config] and opens it in the browser.
///
/// Throws
/// - [UserInterruptException] if the user interrupts the process.
/// - [CommandFailureException] if a [IssueSection.command] fails to execute.
/// - [UnexpectedException] if an unexpected error occurs.
Future<void> buildIssueAndOpen(IssueConfig config) async {
  final uri = await buildIssue(config);

  openInBrowser(uri.toString());
}

/// Builds an issue from the given [config] and returns the URI of the issue.
///
/// Throws
/// - [UserInterruptException] if the user interrupts the process.
/// - [CommandFailureException] if a [IssueSection.command] fails to execute.
/// - [UnexpectedException] if an unexpected error occurs.
Future<Uri> buildIssue(IssueConfig config) => IssueBuilder(config).build();
