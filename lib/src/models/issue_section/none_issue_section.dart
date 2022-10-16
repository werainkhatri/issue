part of 'issue_section.dart';

/// A section that credits the issue package.
class CreditsIssueSection extends IssueSection {
  const CreditsIssueSection()
      : super.noneDriven(
          content: '''
###### This issue was created using [issue](https://pub.dev/packages/issue).''',
        );
}

/// A section that contains a markdown divider.
class DividerIssueSection extends IssueSection {
  const DividerIssueSection() : super.noneDriven(content: '---');
}
