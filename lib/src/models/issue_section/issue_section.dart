import 'package:equatable/equatable.dart';
import 'package:issue/src/utils.dart';

export 'user_driven_issue_section.dart';
export 'command_driven_issue_section.dart';
export 'none_issue_section.dart';

enum DrivenBy {
  user,
  command,
  none;
}

/// A particular section of the issue body, defined by its structure.
///
/// The basic structure consists of an optional [heading] and [content].
///
/// For example:
/// ```dart
/// class SampleIssueSection extends IssueSection {
///   const SampleIssueSection() : super.userDriven(
///     heading: '### Sample Heading',
///     content: 'Sample Content',
///   );
/// }
/// ```
abstract class IssueSection extends Equatable {
  /// Optional heading for the section. Supports markdown formatting.
  ///
  /// Recommended to include markdown formatting like `### Issue` or `**Issue**`.
  final String? heading;

  /// Content of the section. Supports markdown formatting.
  final String content;

  final DrivenBy isDrivenBy;

  final String? placeholder;

  final List<String>? command;

  final String? _prompt;

  const IssueSection.userDriven({
    required this.content,
    this.heading,
    String? prompt,
  })  : _prompt = prompt,
        isDrivenBy = DrivenBy.user,
        placeholder = null,
        command = null,
        assert(content != '', '[content] cannot be empty.');

  IssueSection.commandDriven({
    required this.command,
    required this.content,
    this.heading,
    required this.placeholder,
  })  : _prompt = null,
        isDrivenBy = DrivenBy.command,
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
      : isDrivenBy = DrivenBy.none,
        placeholder = null,
        command = null,
        _prompt = null,
        assert(content != '', '[content] cannot be empty.');

  String build() => '${heading != null ? '$heading\n\n' : ''}$content\n\n';

  @override
  List<Object?> get props =>
      [heading, content, isDrivenBy, placeholder, command];

  @override
  bool? get stringify => true;

  /// To be displayed in the CLI when the user is prompted to enter the
  /// section's content in the file.
  ///
  /// If not provided, name of the extending class will be used. For example,
  /// `SampleCodeIssueSection` will have a prompt of `Sample Code`.
  ///
  /// Not prompted if [isDrivenBy] is [DrivenBy.command] or [DrivenBy.none],
  /// hence returns empty string.
  String get prompt {
    if (isDrivenBy != DrivenBy.user) {
      return '';
    } else if (_prompt != null) {
      return _prompt!;
    }

    String name = runtimeType.toString();

    name = name.substring(0, name.indexOf('IssueSection'));
    for (int i = 1; i < name.length; i++) {
      if (name[i].isUpperCase) {
        name = '${name.substring(0, i)}' /* previous string */
            ' ' /* separating words */
            '${name[i].toLowerCase()}' /* lowercasing the word's first letter */
            '${name.substring(i + 1)}' /* adding the rest of the word */;
        i++;
      }
    }

    return name;
  }
}

abstract class DetailsIssueSection extends IssueSection {
  final String summary;
  final String details;

  const DetailsIssueSection.userDriven({
    super.heading,
    required this.summary,
    required this.details,
    super.prompt,
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
