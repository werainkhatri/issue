import 'package:issue/src/models/issue_template.dart';

abstract class IssueTracker {
  final String website;
  final String endpoint;
  final Map<String, String> customParameters;

  const IssueTracker({
    required this.website,
    required this.endpoint,
    this.customParameters = const {},
  });
}

class GitHubIssueTracker extends IssueTracker {
  final String organization;
  final String repository;

  /// The name of the template file to use when creating a the issue.
  ///
  /// This is the name of the file in the `.github/ISSUE_TEMPLATE` directory.
  /// This is different from [IssueTemplate] as the organization can specify
  /// if a template is required to open the `/issues/new` page.
  final String? template;

  GitHubIssueTracker({
    required this.organization,
    required this.repository,
    this.template,
    Map<String, String> customParameters = const {},
  }) : super(
          website: 'github.com',
          endpoint: '$organization/$repository/issues/new',
          customParameters: template != null
              ? (customParameters..putIfAbsent('template', () => template))
              : customParameters,
        );
}
