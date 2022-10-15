<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# issue

A tool to help cli package authors make raising issues like bug reports more
interactive for their users.

## Features

- Interactive file based prompts for great UX.
- Ability to break the issue body into separate customizable user-prompts.
- Customizable Issue Tracker. Supports GitHub out-of-the-box (obviously).
- Supports running cli commands to collect system data, like `flutter doctor`.

## Demo

https://user-images.githubusercontent.com/44755140/195989524-01e523be-4b6d-4894-aa95-80bd5f162450.mp4

## Usage

Run `dart example/issue.dart` to experience `issue`, or checkout the following sample.

```dart
import 'package:issue/issue.dart';

void main(List<String> args) async {
  IssueConfig config = IssueConfig(
    template: SimpleBugReportIssueTemplate(
      assignees: ['werainkhatri'],
      labels: ['bug'],
      giveCredits: true,
    ),
    tracker: GitHubIssueTracker(
      organization: 'werainkhatri',
      repository: 'issue',
    ),
  );

  try {
    await buildIssueAndOpen(config);
  } on UserInterruptException catch (e) {
    print(e);
  }
}
```

<details>
<summary>WIP</summary>

- test entire flow in linux and windows.
- support for custom editor as per package user / end user's choice. use [this](https://www.kevinkuszyk.com/2016/03/08/git-tips-2-change-editor-for-interactive-git-rebase/) to get the commands for all.
    - feature for end user to select an editor from available editors from the terminal at runtime.
- add customizability for package user to choose if a section should have a interact.Choose prompt before the file prompt.
- find out if the prompt handler function (that uses Process) can be mocked so that it can be tested e2e.
- add custom prompt text support for command driven issue sections.
- pretify using ansi_styles.
- find out and handle the max url length, if any.
- see if downloading and parsing a github issue template would work.
- find how to handle exceptions with nice stdout w/o stacktrace.
- make publishable
  - document public APIs.
- rename titlePlaceholder to titleTemplate and document difference b/w it and titlePrompt.
- add customizability for which template to be used based on user choice. User can choose which type of issue is to be raised (bug, feature request, etc) and the the template is decided.
- "Steps to reproduce" should mention if there's a Code Sample step coming up.
- move to [melos](https://melos.invertase.dev/getting-started)?.
</details>