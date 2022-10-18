import 'package:issue/issue.dart';
import 'package:test/test.dart';

void main() {
  test(SimpleBugReportIssueTemplate, () {
    var template = SimpleBugReportIssueTemplate();
    expect(template.heading, 'Bug Report');
    expect(template.assignees, []);
    expect(template.labels, []);
    expect(template.sections, <IssueSection>[
      CombinedIssueSection(
        sections: [
          DescriptionIssueSection(),
          StepsToReproduceIssueSection(),
          ExpectedBehaviorIssueSection(),
          ActualResultsIssueSection(),
        ],
      ),
      SampleDartCodeIssueSection(),
      DividerIssueSection(),
      AdditionalContextIssueSection(),
    ]);
    expect(template.titleTemplate, 'Please enter a suitable title.');
    expect(template.titlePrompt, 'Issue title');
  });

  test(FlutterBugReportIssueTemplate, () {
    var template = FlutterBugReportIssueTemplate();
    expect(template.assignees, []);
    expect(template.heading, null);
    expect(template.labels, []);
    expect(template.sections, <IssueSection>[
      CombinedIssueSection(
        sections: [
          DescriptionIssueSection(),
          StepsToReproduceIssueSection(),
          ExpectedBehaviorIssueSection(),
          ActualResultsIssueSection(),
        ],
      ),
      SampleDartCodeIssueSection(),
      DividerIssueSection(),
      AdditionalContextIssueSection(),
      DividerIssueSection(),
      FlutterDoctorIssueSection(verbose: true),
    ]);
    expect(template.titleTemplate, 'Please enter a suitable title.');
    expect(template.titlePrompt, 'Issue title');
  });
}
