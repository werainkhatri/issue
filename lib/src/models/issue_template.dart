import '../constants.dart';
import 'issue_section/issue_section.dart';

/// A customizable template of an issue.
///
/// See also:
///
/// - [SimpleBugReportIssueTemplate], which uses a conventional template.
/// - [FlutterBugReportIssueTemplate], which is same as
///    [SimpleBugReportIssueTemplate] but adds [FlutterDoctorIssueSection].
class IssueTemplate {
  /// Creates a new [IssueTemplate].
  ///
  /// [credits] detault to `false`.
  const IssueTemplate({
    this.assignees = const [],
    this.heading,
    this.labels = const [],
    this.sections = const [],
    this.titleTemplate = kTitleTemplateDefault,
    this.titlePrompt = kTitlePromptDefault,
    this.credits = false,
  });

  /// Acts as a template for the issue title, displayed in the file prompt.
  ///
  /// See also:
  ///
  /// - [IssueTemplate.titlePrompt]
  final String titleTemplate;

  /// To be displayed in the CLI when the user is prompted to enter the
  /// issue title in the file.
  ///
  /// See also:
  ///
  /// - [IssueTemplate.titleTemplate]
  final String titlePrompt;

  /// List of labels to be applied to the issue when it is submitted.
  final List<String> labels;

  /// List of assignees to be assigned to the issue when it is submitted.
  final List<String> assignees;

  /// Optional heading for the issue body.
  final String? heading;

  /// Sections of the issue.
  final List<IssueSection> sections;

  /// Whether to add [CreditsIssueSection] at the end of the issue.
  ///
  /// Defaults to `false`, obviously.
  final bool credits;
}

/// A simple bug report issue template.
///
/// See also:
///
/// - [IssueTemplate], which is the base class for all issue templates.
/// - [FlutterBugReportIssueTemplate], which is same as this along with
///   [FlutterDoctorIssueSection].
class SimpleBugReportIssueTemplate extends IssueTemplate {
  SimpleBugReportIssueTemplate({
    super.assignees,
    super.labels,
    super.titleTemplate,
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

/// A bug report issue template for Flutter apps. Along with the conventional
/// issue template, it also attaches the output for `flutter doctor -v`.
///
/// See also:
///
/// - [IssueTemplate], which is the base class for all issue templates.
/// - [SimpleBugReportIssueTemplate], which is same as this but without
///   [FlutterDoctorIssueSection].
class FlutterBugReportIssueTemplate extends IssueTemplate {
  /// Creates a new [FlutterBugReportIssueTemplate].
  ///
  /// [isFlutterDoctorVerbose] defaults to `true`.
  FlutterBugReportIssueTemplate({
    super.assignees,
    super.heading,
    super.labels,
    super.titleTemplate,
    super.titlePrompt,
    this.isFlutterDoctorVerbose = true,
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
        );

  /// If `flutter doctor` should be run in verbose mode.
  ///
  /// Defaults to `false`.
  final bool isFlutterDoctorVerbose;
}
