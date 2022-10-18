import 'package:issue/issue.dart';

void main(List<String> args) async {
  IssueConfig config = IssueConfig(
    template: FlutterBugReportIssueTemplate(
      assignees: ['werainkhatri'],
      labels: ['bug'],
      credits: true,
    ),
    tracker: GitHubIssueTracker(
      organization: 'werainkhatri',
      repository: 'issue',
    ),
  );

  try {
    await buildIssueAndOpen(config);
  } on UserInterruptException catch (e) {
    print(e);
  }
}
