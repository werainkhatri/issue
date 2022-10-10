import 'package:issue/issue.dart';

void main(List<String> args) async {
  IssueConfig config = IssueConfig(
    template: FlutterBugReportIssueTemplate(isFlutterDoctorVerbose: true),
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
