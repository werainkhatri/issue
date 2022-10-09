import 'package:issue/src/models/issue_section/issue_section.dart';
import 'package:test/test.dart';

void main() {
  test(DividerIssueSection, () {
    const section = DividerIssueSection();
    expect(section.heading, null);
    expect(section.content, '---');
    expect(section.isDrivenBy, IssueSectionDrivenBy.none);
  });
}
