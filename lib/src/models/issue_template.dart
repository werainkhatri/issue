import 'package:issue/src/models/issue_section/issue_section.dart';

abstract class IssueTemplate {
  final String titlePlaceholder;
  final List<String> labels;
  final List<String> assignees;

  /// Optional heading for the issue body.
  final String? heading;

  /// Sections of the issue.
  final List<IssueSection> sections;

  bool get requiresFlutterApp;

  const IssueTemplate({
    this.titlePlaceholder = 'Please enter a suitable title',
    this.labels = const [],
    this.assignees = const [],
    this.heading,
    required this.sections,
  });
}

class SimpleBugReportIssueTemplate extends IssueTemplate {
  const SimpleBugReportIssueTemplate({
    super.titlePlaceholder,
    super.labels = const [],
    super.assignees = const [],
  }) : super(
          heading: 'Bug Report',
          sections: const [
            DescriptionIssueSection(),
            CombinedIssueSection(sections: [
              StepsToReproduceIssueSection(),
              ExpectedBehaviorIssueSection(),
              ActualResultsIssueSection(),
            ]),
            SampleDartCodeIssueSection(),
            DividerIssueSection(),
            AdditionalContextIssueSection(),
          ],
        );

  @override
  bool get requiresFlutterApp => false;
}

class FlutterBugReportIssueTemplate extends IssueTemplate {
  final bool isFlutterDoctorVerbose;

  FlutterBugReportIssueTemplate({
    super.titlePlaceholder,
    super.heading,
    super.labels = const [],
    super.assignees = const [],
    this.isFlutterDoctorVerbose = false,
  }) : super(
          sections: [
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
            FlutterDoctorIssueSection(verbose: isFlutterDoctorVerbose),
          ],
        );

  @override
  bool get requiresFlutterApp => true;
}
