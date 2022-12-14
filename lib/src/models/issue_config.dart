import '../../issue.dart';
import '../constants.dart';

class IssueConfig {
  const IssueConfig({
    required this.template,
    required this.tracker,
    this.issueFileName = kIssueFile,
  });

  /// The issue template that will be used to build the issue.
  final IssueTemplate template;

  /// The issue tracker where the user will be directed once
  /// the issue is built.
  final IssueTracker tracker;

  /// The name of the file that will be used as prompt to get user input.
  final String issueFileName;
}
