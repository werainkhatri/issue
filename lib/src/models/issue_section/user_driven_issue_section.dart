part of 'issue_section.dart';

class ActualResultsIssueSection extends IssueSection {
  const ActualResultsIssueSection({super.prompt})
      : super.userDriven(
          heading: '### Actual results',
          content: '<!-- what did you see? -->',
        );
}

class AdditionalContextIssueSection extends IssueSection {
  const AdditionalContextIssueSection({super.prompt})
      : super.userDriven(
          heading: '### Additional context',
          content: '<!-- Add any other context about the problem here. -->',
        );
}

class CodeDetailsIssueSection extends DetailsIssueSection {
  CodeDetailsIssueSection({
    super.heading,
    this.comment,
    required super.summary,
    required this.language,
    super.prompt,
  }) : super.userDriven(
          details: '''
${_comment(comment)}```$language

```''',
        );
  final String language;
  final String? comment;

  static String _comment(String? comment) =>
      comment == null ? '' : '<!-- $comment -->\n\n';
}

/// Combined user driven issue sections will be shown in one file prompt.
///
/// This is to reduce the number of prompts to the user and hence
/// speed up the process.
class CombinedIssueSection extends IssueSection {
  CombinedIssueSection({required this.sections, String? prompt})
      : _combinedPrompt = prompt,
        assert(sections.isNotEmpty, 'Cannot combine empty [sections].'),
        assert(
          sections.every((element) => element.isDrivenBy == DrivenBy.user),
          'Cannot combine non-user driven sections.',
        ),
        super.userDriven(
          content: joinBuiltIssueSections(sections.map((e) => e.build())),
        );
  final List<IssueSection> sections;
  final String? _combinedPrompt;

  @override
  String get prompt =>
      _combinedPrompt ?? sections.map((e) => e.prompt).join(', ');
}

class DescriptionIssueSection extends IssueSection {
  const DescriptionIssueSection({super.prompt})
      : super.userDriven(
          heading: '### Describe the bug',
          content: 'A clear and concise description of what the bug is.',
        );
}

class ExpectedBehaviorIssueSection extends IssueSection {
  const ExpectedBehaviorIssueSection({super.prompt})
      : super.userDriven(
          heading: '### Expected behavior',
          content: '<!-- what did you want to see? -->',
        );
}

class SampleDartCodeIssueSection extends DetailsIssueSection {
  const SampleDartCodeIssueSection({super.heading, super.prompt})
      : super.userDriven(
          summary: 'Sample Code',
          details: '''
<!-- Please include a minimal code sample that demonstrates the issue. -->

```dart

```''',
        );
}

class StepsToReproduceIssueSection extends IssueSection {
  const StepsToReproduceIssueSection({super.prompt})
      : super.userDriven(
          heading: '### Steps to reproduce',
          content: '''
<!-- Please include full steps to reproduce the issue. -->

1. ... <!-- describe the situation, like a code sample or package -->
2. ... <!-- describe steps to demonstrate the bug -->
3. ... <!-- for example: "Tap on X and see the crash" -->''',
        );
}
