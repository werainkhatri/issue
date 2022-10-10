import 'package:issue/issue.dart';
import 'package:test/test.dart';

void main() {
  test(SimpleBugReportIssueTemplate, () {
    final template = SimpleBugReportIssueTemplate();
    expect(template.heading, 'Bug Report');
    expect(template.assignees, []);
    expect(template.labels, []);
    expect(template.sections, <IssueSection>[
      CombinedIssueSection(sections: [
        DescriptionIssueSection(),
        StepsToReproduceIssueSection(),
        ExpectedBehaviorIssueSection(),
        ActualResultsIssueSection(),
      ]),
      SampleDartCodeIssueSection(),
      DividerIssueSection(),
      AdditionalContextIssueSection(),
    ]);
    expect(template.requiresFlutterApp, false);
    expect(template.titlePlaceholder, 'Please enter a suitable title.');
    expect(template.titlePrompt, 'Issue title');
  });

  test(FlutterBugReportIssueTemplate, () {
    final template = FlutterBugReportIssueTemplate();
    expect(template.assignees, []);
    expect(template.heading, null);
    expect(template.labels, []);
    expect(template.sections, <IssueSection>[
      CombinedIssueSection(sections: [
        DescriptionIssueSection(),
        StepsToReproduceIssueSection(),
        ExpectedBehaviorIssueSection(),
        ActualResultsIssueSection(),
      ]),
      SampleDartCodeIssueSection(),
      DividerIssueSection(),
      AdditionalContextIssueSection(),
      DividerIssueSection(),
      FlutterDoctorIssueSection(),
    ]);
    expect(template.requiresFlutterApp, true);
    expect(template.titlePlaceholder, 'Please enter a suitable title.');
    expect(template.titlePrompt, 'Issue title');
  });
}
