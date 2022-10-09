import 'package:equatable/equatable.dart';

export 'user_driven_issue_section.dart';
export 'command_driven_issue_section.dart';
export 'none_issue_section.dart';

enum IssueSectionDrivenBy {
  user,
  command,
  none;
}

abstract class IssueSection extends Equatable {
  /// Optional heading for the section. Supports markdown formatting.
  ///
  /// Recommended to include markdown formatting like `### Issue` or `**Issue**`.
  final String? heading;

  /// Content of the section. Supports markdown formatting.
  final String content;

  final IssueSectionDrivenBy isDrivenBy;

  final String? placeholder;

  final List<String>? command;

  const IssueSection.userDriven({this.heading, required this.content})
      : isDrivenBy = IssueSectionDrivenBy.user,
        placeholder = null,
        command = null,
        assert(content != '', '[content] cannot be empty.');

  IssueSection.commandDriven(
      {this.heading,
      required this.content,
      required this.placeholder,
      required this.command})
      : isDrivenBy = IssueSectionDrivenBy.command,
        assert(placeholder != null && placeholder.isNotEmpty,
            'placeholder cannot be empty'),
        assert(command != null && command.isNotEmpty,
            '[command] must not be empty.'),
        assert(content.contains(placeholder!),
            '[content] must contain [placeholder].'),
        assert(
            content.indexOf(placeholder!) == content.lastIndexOf(placeholder),
            '[content] must contain [placeholder] only once.');

  const IssueSection.noneDriven({this.heading, required this.content})
      : isDrivenBy = IssueSectionDrivenBy.none,
        placeholder = null,
        command = null,
        assert(content != '', '[content] cannot be empty.');

  String build() => '${heading != null ? '$heading\n\n' : ''}$content\n\n';

  @override
  List<Object?> get props =>
      [heading, content, isDrivenBy, placeholder, command];

  @override
  bool? get stringify => true;
}

abstract class DetailsIssueSection extends IssueSection {
  final String summary;
  final String details;

  const DetailsIssueSection.userDriven({
    super.heading,
    required this.summary,
    required this.details,
  }) : super.userDriven(content: '''
<details>
<summary>$summary</summary>

$details
</details>''');

  DetailsIssueSection.commandDriven({
    super.heading,
    required super.command,
    required super.placeholder,
    required this.summary,
    required this.details,
  })  : assert(details.contains(placeholder!),
            '[details] must contain [placeholder].'),
        assert(
            details.indexOf(placeholder!) == details.lastIndexOf(placeholder),
            '[details] must contain [placeholder] only once.'),
        super.commandDriven(content: '''
<details>
<summary>$summary</summary>

$details
</details>''');
}
