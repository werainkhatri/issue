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

A CLI tool to help cli package authors make raising issues like bug reports more interactive for their users.

## Features

- Interactive file based prompts for great UX.
- Ability to break the issue body into separate customizable user-prompts.
- Customizable Issue Tracker. Supports GitHub out-of-the-box (obviously).
- Supports running cli commands to collect system data, like `flutter doctor`. 

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

Run `dart example/cli.dart` to experience `issue`, or checkout the following sample.

```dart
import 'package:issue/issue.dart';

void main(List<String> args) async {
  // configuration of the issue to be raised.
  IssueConfig config = IssueConfig(
    // template containing details like title, body, etc.
    template: FlutterBugReportIssueTemplate(isFlutterDoctorVerbose: true),
    // tracker to which the issue is to be raised.
    tracker: GitHubIssueTracker(
      organization: 'werainkhatri',
      repository: 'issue',
    ),
  );

  try {
    // builds and redirects the user to the pre-filled issue just for them to press the `Submit new issue` button.
    buildIssueAndOpen(config);
  } on UserInterruptException catch (e) {
    print(e);
  }
}

```

## TODO
- test entire flow in linux and windows.
- support for custom editor as per package user / end user's choice. use [this](https://www.kevinkuszyk.com/2016/03/08/git-tips-2-change-editor-for-interactive-git-rebase/) to get the commands for all.
    - feature for end user to select an editor from available editors from the terminal at runtime.
- add step to inform user to abort process by deleting all the contents of the file.
- add customizability for package user to choose if a section should have a choose prompt before the file prompt.
- customizability in prompt handler (file prompt), which will enable testing the code.
- add custom prompt text support for command driven issue sections.
- pretify using ansi_styles.
- find out and handle the max url length, if any.
- see if downloading and parsing a github issue template would work.
- move to [melos](https://melos.invertase.dev/getting-started).
- make publishable
