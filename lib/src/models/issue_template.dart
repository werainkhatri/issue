import 'package:issue/src/models/issue_section/issue_section.dart';

abstract class IssueTemplate {
  final String titlePlaceholder;
  final String titlePrompt;
  final List<String> labels;
  final List<String> assignees;

  /// Optional heading for the issue body.
  final String? heading;

  /// Sections of the issue.
  final List<IssueSection> sections;

  final bool requiresFlutterApp;

  const IssueTemplate({
    this.assignees = const [],
    this.heading,
    this.labels = const [],
    this.sections = const [],
    this.requiresFlutterApp = false,
    this.titlePlaceholder = 'Please enter a suitable title.',
    this.titlePrompt = 'Issue title',
  });
}

class SimpleBugReportIssueTemplate extends IssueTemplate {
  SimpleBugReportIssueTemplate({
    super.assignees = const [],
    super.labels = const [],
    super.titlePlaceholder,
    super.titlePrompt,
  }) : super(
          heading: 'Bug Report',
          sections: [
            CombinedIssueSection(sections: [
              DescriptionIssueSection(),
              StepsToReproduceIssueSection(),
              ExpectedBehaviorIssueSection(),
              ActualResultsIssueSection(),
            ]),
            SampleDartCodeIssueSection(),
            DividerIssueSection(),
            AdditionalContextIssueSection(),
          ],
        );
}

class FlutterBugReportIssueTemplate extends IssueTemplate {
  final bool isFlutterDoctorVerbose;

  FlutterBugReportIssueTemplate({
    super.assignees = const [],
    super.heading,
    super.labels = const [],
    super.titlePlaceholder,
    super.titlePrompt,
    this.isFlutterDoctorVerbose = false,
  }) : super(
          sections: [
            CombinedIssueSection(
              sections: [
                DescriptionIssueSection(),
                StepsToReproduceIssueSection(),
                ExpectedBehaviorIssueSection(),
                ActualResultsIssueSection(),
              ],
              prompt: 'Issue Details',
            ),
            SampleDartCodeIssueSection(),
            DividerIssueSection(),
            AdditionalContextIssueSection(),
            DividerIssueSection(),
            FlutterDoctorIssueSection(verbose: isFlutterDoctorVerbose),
          ],
          requiresFlutterApp: true,
        );
}
