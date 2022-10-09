import 'package:issue/src/models/issue_section/issue_section.dart';
import 'package:test/test.dart';

void main() {
  test(DescriptionIssueSection, () {
    const section = DescriptionIssueSection();
    expect(section.heading, '### Describe the bug');
    expect(
        section.content, 'A clear and concise description of what the bug is.');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test(StepsToReproduceIssueSection, () {
    const section = StepsToReproduceIssueSection();
    expect(section.heading, '### Steps to reproduce');
    expect(section.content, '''
<!-- Please include full steps to reproduce the issue. -->

1. ... <!-- describe the situation, like a code sample or package -->
2. ... <!-- describe steps to demonstrate the bug -->
3. ... <!-- for example: "Tap on X and see the crash" -->''');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test(ExpectedBehaviorIssueSection, () {
    const section = ExpectedBehaviorIssueSection();
    expect(section.heading, '### Expected behavior');
    expect(section.content, '<!-- what did you want to see? -->');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test(ActualResultsIssueSection, () {
    const section = ActualResultsIssueSection();
    expect(section.heading, '### Actual results');
    expect(section.content, '<!-- what did you see? -->');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test(SampleDartCodeIssueSection, () {
    const section = SampleDartCodeIssueSection(heading: '### Sample Code');
    expect(section.heading, '### Sample Code');
    expect(section.content, '''
<details>
<summary>Sample Code</summary>

<!-- Please include a minimal code sample that demonstrates the issue. -->

```dart

```
</details>''');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test(AdditionalContextIssueSection, () {
    const section = AdditionalContextIssueSection();
    expect(section.heading, '### Additional context');
    expect(section.content,
        '<!-- Add any other context about the problem here. -->');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test('CodeDetailsIssueSection with comment', () {
    final section = CodeDetailsIssueSection(
      heading: '### Code',
      language: 'dart',
      summary: 'code',
      comment: 'comment',
    );
    expect(section.heading, '### Code');
    expect(section.content, '''
<details>
<summary>code</summary>

<!-- comment -->

```dart

```
</details>''');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });

  test('CodeDetailsIssueSection without comment', () {
    final section = CodeDetailsIssueSection(
      heading: '### Code',
      language: 'dart',
      summary: 'code',
    );
    expect(section.heading, '### Code');
    expect(section.content, '''
<details>
<summary>code</summary>

```dart

```
</details>''');
    expect(section.isDrivenBy, IssueSectionDrivenBy.user);
  });
}
