import 'package:equatable/equatable.dart';
import '../../utils.dart';

part 'command_driven_issue_section.dart';
part 'none_issue_section.dart';
part 'user_driven_issue_section.dart';

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
class IssueSection extends Equatable {
  const IssueSection.userDriven({
    required this.content,
    this.heading,
    String? prompt,
  })  : _prompt = prompt,
        isDrivenBy = DrivenBy.user,
        placeholder = null,
        command = null,
        requiresFlutterProject = false,
        assert(content != '', '[content] cannot be empty.');

  const IssueSection.noneDriven({this.heading, required this.content})
      : isDrivenBy = DrivenBy.none,
        placeholder = null,
        command = null,
        _prompt = null,
        requiresFlutterProject = false,
        assert(content != '', '[content] cannot be empty.');

  IssueSection.commandDriven({
    required this.command,
    required this.content,
    this.heading,
    required this.placeholder,
    this.requiresFlutterProject = false,
  })  : _prompt = null,
        isDrivenBy = DrivenBy.command,
        assert(
          placeholder != null && placeholder.isNotEmpty,
          'placeholder cannot be empty',
        ),
        assert(
          command != null && command.isNotEmpty,
          '[command] must not be empty.',
        ),
        assert(
          content.contains(placeholder!),
          '[content] must contain [placeholder].',
        ),
        assert(
          content.indexOf(placeholder!) == content.lastIndexOf(placeholder),
          '[content] must contain [placeholder] only once.',
        );

  /// Optional heading for the section. Supports markdown formatting.
  ///
  /// Recommended to include markdown formatting like `### Issue`, `**Issue**`.
  final String? heading;

  /// List of executable and arguments to execute.
  ///
  /// Replaces [placeholder] with the output of this command in [content].
  final List<String>? command;

  /// Content of the section. Supports markdown formatting.
  final String content;

  /// Who is responsible for populating the section.
  final DrivenBy isDrivenBy;

  /// Text that is contained in the [content] exactly once and is to be
  /// replaced by the output of the [command].
  ///
  /// For example:
  /// ```dart
  /// class SampleIssueSection extends IssueSection {
  ///  const SampleIssueSection() : super.commandDriven(
  ///   heading: '### Sample Heading',
  ///   content: 'Sample Content',
  ///   command: ['echo', "'Hello World!'"],
  ///   commandPlaceholder: 'Sample Command Output',
  ///  );
  /// }
  /// ```
  ///
  /// The above [SampleIssueSection] will be rendered as:
  /// ```markdown
  /// ### Sample Heading
  /// Sample Content
  /// ```
  ///
  /// This will be ignored if [isDrivenBy] is **not** [DrivenBy.command].
  final String? placeholder;

  /// Whether the [command] requires a Flutter project to be present in the
  /// current working directory, like `flutter analyze`.
  ///
  /// Defaults to `false` and is ignored if [isDrivenBy] is **not**
  /// [DrivenBy.command].
  final bool requiresFlutterProject;

  final String? _prompt;

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

  @override
  List<Object?> get props =>
      [heading, content, isDrivenBy, placeholder, command];

  @override
  bool? get stringify => true;

  /// Builds the section with heading, if present, and content.
  ///
  /// This is what will be shown to the user.
  String build() => '${heading != null ? '$heading\n\n' : ''}$content';
}

class DetailsIssueSection extends IssueSection {
  const DetailsIssueSection.userDriven({
    super.heading,
    required this.summary,
    required this.details,
    super.prompt,
  }) : super.userDriven(
          content: '''
<details>
<summary>$summary</summary>

$details
</details>''',
        );

  DetailsIssueSection.commandDriven({
    super.heading,
    required super.command,
    required super.placeholder,
    required this.summary,
    required this.details,
  })  : assert(
          details.contains(placeholder!),
          '[details] must contain [placeholder].',
        ),
        assert(
          details.indexOf(placeholder!) == details.lastIndexOf(placeholder),
          '[details] must contain [placeholder] only once.',
        ),
        super.commandDriven(
          content: '''
<details>
<summary>$summary</summary>

$details
</details>''',
        );

  /// Title of the section that'll go into the <summary> tag.
  final String summary;

  /// Content of the section that'll go into the <details> tag.
  final String details;
}

/// Who is responsible for populating this section.
enum DrivenBy {
  /// Specifies that the user will be responsible for populating this section.
  ///
  /// This implies that the user will be prompted to enter and will affect the
  /// progress bar of the issue build process.
  user,

  /// Specifies that a command will be responsible for populating this section.
  ///
  /// This implies that the user will not be prompted to enter and will not
  /// affect the progress of the issue build process, rather will be executed
  /// in a separate loading step.
  command,

  /// Specifies that no one will be responsible for populating this section. In
  /// other words, this section will be pre-populated.
  ///
  /// It can be used as a cosmetic section, containing a markdown comment
  /// (<!-- -->) or divider (---), etc.
  none;
}
