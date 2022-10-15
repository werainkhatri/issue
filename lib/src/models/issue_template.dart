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

  /// Whether to add [CreditsIssueSection] at the end of the issue.
  ///
  /// Defaults to `false`, obviously.
  final bool credits;

  const IssueTemplate({
    this.assignees = const [],
    this.heading,
    this.labels = const [],
    this.sections = const [],
    this.requiresFlutterApp = false,
    this.titlePlaceholder = 'Please enter a suitable title.',
    this.titlePrompt = 'Issue title',
    this.credits = false,
  });
}

class SimpleBugReportIssueTemplate extends IssueTemplate {
  SimpleBugReportIssueTemplate({
    super.assignees,
    super.labels,
    super.titlePlaceholder,
    super.titlePrompt,
    super.credits,
  }) : super(
          heading: 'Bug Report',
          sections: [
            CombinedIssueSection(
              prompt: 'Issue Details',
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
          ],
        );
}

class FlutterBugReportIssueTemplate extends IssueTemplate {
  final bool isFlutterDoctorVerbose;

  FlutterBugReportIssueTemplate({
    super.assignees,
    super.heading,
    super.labels,
    super.titlePlaceholder,
    super.titlePrompt,
    this.isFlutterDoctorVerbose = false,
    super.credits,
  }) : super(
          sections: [
            CombinedIssueSection(
              prompt: 'Issue Details',
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
            FlutterDoctorIssueSection(verbose: isFlutterDoctorVerbose),
          ],
          requiresFlutterApp: true,
        );
}
