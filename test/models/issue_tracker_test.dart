import 'package:issue/src/models/issue_tracker.dart';
import 'package:test/test.dart';

void main() {
  test('GitHubIssueTracker adds template to customParameters', () {
    GitHubIssueTracker tracker = GitHubIssueTracker(
      organization: 'firebase',
      repository: 'flutterfire',
      template: '--bug-report.md',
    );

    expect(tracker.customParameters, {'template': '--bug-report.md'});

    tracker = GitHubIssueTracker(
      organization: 'firebase',
      repository: 'flutterfire',
      customParameters: {'sample': 'parameter'},
      template: '--bug-report.md',
    );

    expect(
      tracker.customParameters,
      {'sample': 'parameter', 'template': '--bug-report.md'},
    );
  });
}
