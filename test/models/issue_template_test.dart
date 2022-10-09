import 'package:issue/issue.dart';
import 'package:test/test.dart';

void main() {
  test(SimpleBugReportIssueTemplate, () {
    final template = SimpleBugReportIssueTemplate();
    expect(template.heading, 'Bug Report');
    expect(template.assignees, []);
    expect(template.labels, []);
    expect(template.sections, <IssueSection>[
      DescriptionIssueSection(),
      CombinedIssueSection(sections: [
        StepsToReproduceIssueSection(),
        ExpectedBehaviorIssueSection(),
        ActualResultsIssueSection(),
      ]),
      SampleDartCodeIssueSection(),
      DividerIssueSection(),
      AdditionalContextIssueSection(),
    ]);
    expect(template.requiresFlutterApp, false);
  });

  test(FlutterBugReportIssueTemplate, () {
    final template = FlutterBugReportIssueTemplate();
    expect(template.heading, null);
    expect(template.assignees, []);
    expect(template.labels, []);
    expect(template.sections, <IssueSection>[
      DescriptionIssueSection(),
      CombinedIssueSection(sections: [
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
  });
}
