import 'dart:io';

import 'package:interact/interact.dart' as interact;

import 'constants.dart';
import 'exceptions.dart';
import 'models/models.dart';
import 'utils.dart';

part 'issue_builder.dart';

/// Builds an issue from the given [config] and returns the URI of the issue.
///
/// Throws
/// - [UserInterruptException] if the user interrupts the process.
/// - [CommandFailureException] if a [IssueSection.command] fails to execute.
/// - [UnexpectedException] if an unexpected error occurs.
Future<Uri> buildIssue(IssueConfig config) => _IssueBuilder(config).build();

/// Builds an issue from the given [config] and opens it in the browser.
///
/// Throws
/// - [UserInterruptException] if the user interrupts the process.
/// - [CommandFailureException] if a [IssueSection.command] fails to execute.
/// - [UnexpectedException] if an unexpected error occurs.
Future<void> buildIssueAndOpen(IssueConfig config) async {
  var uri = await buildIssue(config);

  openInBrowser(uri.toString());
}
