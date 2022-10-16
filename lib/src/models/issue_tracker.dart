/// A customizable issue tracking website, like GitHub, GitLab, etc.
///
/// See also:
///
/// - [GitHubIssueTracker], implementation for for `github.com`.
class IssueTracker {
  const IssueTracker({
    required this.website,
    required this.endpoint,
    this.customParameters = const {},
  });

  /// The authority url of the issue tracking website (e.g. `'github.com'``).
  final String website;

  /// The endpoint of the issue tracker that'll be appended to the website
  /// (e.g. `'werainkhatri/issue/issues/new'`).
  final String endpoint;

  /// Custom parameters to be added to the issue tracker's URI.
  final Map<String, String> customParameters;
}

/// [IssueTracker] implementation for GitHub.
class GitHubIssueTracker extends IssueTracker {
  GitHubIssueTracker({
    required this.organization,
    required this.repository,
    this.template,
    Map<String, String>? customParameters,
  }) : super(
          website: 'github.com',
          endpoint: '$organization/$repository/issues/new',
          customParameters: (() {
            var value = customParameters ?? <String, String>{};
            return template != null
                ? (value..putIfAbsent('template', () => template))
                : value;
          })(),
        );

  /// GitHub organization / user name, eg: `'flutter'` / `'werainkhatri'`.
  final String organization;

  /// GitHub repository name, eg: `'flutter'` / `'issue'`.
  final String repository;

  /// The name of the template file to use when creating a the issue.
  ///
  /// This is the name of the file in the `.github/ISSUE_TEMPLATE` directory.
  /// This is different from [IssueTemplate] as the organization can specify if
  /// a template is required to open the `/issues/new` page.
  final String? template;
}
