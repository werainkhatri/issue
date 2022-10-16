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

[![pub package](https://img.shields.io/pub/v/issue.svg)](https://pub.dev/packages/issue)
[![pub points](https://img.shields.io/pub/points/issue?color=2E8B57&label=pub%20points)](https://pub.dev/packages/issue/score)

A tool to help cli package authors make raising issues like bug reports more
interactive for their users.

## Features

- Interactive file based prompts for great UX.
- Ability to break the issue body into separate customizable user-prompts.
- Supports executing cli commands to collect system / project data, like `flutter doctor`.
- Customizable Issue Tracker. Supports GitHub out-of-the-box (obviously).

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
