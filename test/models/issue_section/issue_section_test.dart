import 'package:issue/src/models/issue_section/issue_section.dart';
import 'package:test/test.dart';

void main() {
  test('IssueSection.userDriven with null prompt', () {
    const section = TestUserDrivenIssueSection();
    expect(section.heading, 'test heading');
    expect(section.content, 'test content');
    expect(section.build(), '''
test heading

test content

''');
    expect(section.isDrivenBy, DrivenBy.user);
    expect(section.placeholder, isNull);
    expect(section.command, isNull);
    expect(section.prompt, 'Test user driven');
  });

  test('IssueSection.userDriven with non-null prompt', () {
    const section = TestUserDrivenIssueSection('prompt');

    expect(section.prompt, 'prompt');
  });

  group('IssueSection.commandDriven', () {
    test('happy case', () {
      final section = TestCommandDrivenIssueSection(
        placeholder: 'placeholder',
        content: 'this is a placeholder',
      );
      expect(section.content, 'this is a placeholder');
      expect(section.placeholder, 'placeholder');
      expect(section.command, ['command']);
      expect(section.prompt, '');
    });

    test('throws when placeholder is empty', () {
      expect(
          () => TestCommandDrivenIssueSection(
                placeholder: '',
                content: 'this is a placeholder',
              ),
          throwsA(isA<AssertionError>()));
    });

    test('throws when command is empty', () {
      expect(
          () => TestCommandDrivenIssueSection(
                placeholder: 'placeholder',
                content: 'this is a placeholder',
                command: [],
              ),
          throwsA(isA<AssertionError>()));
    });

    test('throws when content does not contain placeholder', () {
      expect(
          () => TestCommandDrivenIssueSection(
                placeholder: 'placeholder',
                content: 'this is a content',
              ),
          throwsA(isA<AssertionError>()));
    });

    test('throws when content contains placeholder more than once', () {
      expect(
          () => TestCommandDrivenIssueSection(
                placeholder: 'placeholder',
                content: 'this is a placeholder placeholder',
              ),
          throwsA(isA<AssertionError>()));
    });
  });

  test('IssueSection.noneDriven', () {
    const section = TestNoneDrivenIssueSection();
    expect(section.heading, 'test heading');
    expect(section.content, 'test content');
    expect(section.build(), '''
test heading

test content

''');
    expect(section.isDrivenBy, DrivenBy.none);
    expect(section.placeholder, isNull);
    expect(section.command, isNull);
    expect(section.prompt, '');
  });

  test('DetailsIssueSection.userDriven with null prompt', () {
    const section = TestUserDrivenDetailsIssueSection();
    expect(section.isDrivenBy, DrivenBy.user);
    expect(section.content, '''
<details>
<summary>test summary</summary>

test details
</details>''');
    expect(section.build(), '''
<details>
<summary>test summary</summary>

test details
</details>

''');
    expect(section.placeholder, isNull);
    expect(section.command, isNull);
    expect(section.prompt, 'Test user driven details');
  });

  test('DetailsIssueSection.userDriven with non-null prompt', () {
    const section = TestUserDrivenDetailsIssueSection('prompt');

    expect(section.prompt, 'prompt');
  });

  test('DetailsIssueSection.commandDriven', () {
    final section = TestCommandDrivenDetailsIssueSection();
    expect(section.isDrivenBy, DrivenBy.command);
    expect(section.content, '''
<details>
<summary>test summary</summary>

this is a placeholder
</details>''');
    expect(section.build(), '''
<details>
<summary>test summary</summary>

this is a placeholder
</details>

''');
    expect(section.placeholder, 'placeholder');
    expect(section.command, ['command']);
    expect(section.prompt, '');
  });
}

class TestUserDrivenIssueSection extends IssueSection {
  const TestUserDrivenIssueSection([String? prompt])
      : super.userDriven(
          heading: 'test heading',
          content: 'test content',
          prompt: prompt,
        );
}

class TestCommandDrivenIssueSection extends IssueSection {
  TestCommandDrivenIssueSection({
    required super.placeholder,
    required super.content,
    super.command = const ['command'],
  }) : super.commandDriven();
}

class TestNoneDrivenIssueSection extends IssueSection {
  const TestNoneDrivenIssueSection()
      : super.noneDriven(heading: 'test heading', content: 'test content');
}

class TestUserDrivenDetailsIssueSection extends DetailsIssueSection {
  const TestUserDrivenDetailsIssueSection([String? prompt])
      : super.userDriven(
          summary: 'test summary',
          details: 'test details',
          prompt: prompt,
        );
}

class TestCommandDrivenDetailsIssueSection extends DetailsIssueSection {
  TestCommandDrivenDetailsIssueSection()
      : super.commandDriven(
          summary: 'test summary',
          details: 'this is a placeholder',
          placeholder: 'placeholder',
          command: ['command'],
        );
}
