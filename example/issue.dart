import 'dart:io';

import 'package:issue/issue.dart';

void main(List<String> args) async {
  IssueConfig config = IssueConfig(
    template: FlutterBugReportIssueTemplate(isFlutterDoctorVerbose: true),
    tracker: GitHubIssueTracker(
      organization: 'werainkhatri',
      repository: 'werainkhatri',
    ),
    issueFile: '.myissue.md',
  );

  try {
    buildIssueAndOpen(config);
  } on InterruptException catch (e) {
    stdout.add(('${e.message}\n').codeUnits);
  }
}
