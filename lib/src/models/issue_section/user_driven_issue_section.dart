import 'issue_section.dart';

class DescriptionIssueSection extends IssueSection {
  const DescriptionIssueSection()
      : super.userDriven(
            heading: '### Describe the bug',
            content: 'A clear and concise description of what the bug is.');
}

class StepsToReproduceIssueSection extends IssueSection {
  const StepsToReproduceIssueSection()
      : super.userDriven(heading: '### Steps to reproduce', content: '''
<!-- Please include full steps to reproduce the issue. -->

1. ... <!-- describe the situation, like a code sample or package -->
2. ... <!-- describe steps to demonstrate the bug -->
3. ... <!-- for example: "Tap on X and see the crash" -->''');
}

class ExpectedBehaviorIssueSection extends IssueSection {
  const ExpectedBehaviorIssueSection()
      : super.userDriven(
            heading: '### Expected behavior',
            content: '<!-- what did you want to see? -->');
}

class ActualResultsIssueSection extends IssueSection {
  const ActualResultsIssueSection()
      : super.userDriven(
            heading: '### Actual results',
            content: '<!-- what did you see? -->');
}

class AdditionalContextIssueSection extends IssueSection {
  const AdditionalContextIssueSection()
      : super.userDriven(
            heading: '### Additional context',
            content: '<!-- Add any other context about the problem here. -->');
}

class CodeDetailsIssueSection extends DetailsIssueSection {
  final String language;
  final String? comment;

  CodeDetailsIssueSection({
    super.heading,
    this.comment,
    required super.summary,
    required this.language,
  }) : super.userDriven(details: '''
${_comment(comment)}```$language

```''');

  static String _comment(String? comment) =>
      comment == null ? '' : '<!-- $comment -->\n\n';
}

class SampleDartCodeIssueSection extends DetailsIssueSection {
  const SampleDartCodeIssueSection({super.heading})
      : super.userDriven(summary: 'Sample Code', details: '''
<!-- Please include a minimal code sample that demonstrates the issue. -->

```dart

```''');
}

/// Combined issue sections will be shown in one user prompt.
///
/// This is to reduce the number of prompts to the user and hence
/// speed up the process.
class CombinedIssueSection extends IssueSection {
  final List<IssueSection> sections;

  const CombinedIssueSection({required this.sections})
      : super.userDriven(heading: '', content: ' ');

  @override
  String build() => sections.map((e) => e.build()).join();
}
