import 'dart:io';

import 'models/models.dart';
import 'utils.dart';

Future<void> buildIssueAndOpen(IssueConfig config) async {
  final uri = await buildIssue(config);

  openInBrowser(uri.toString());
}

Future<Uri> buildIssue(IssueConfig config) async {
  if (config.template.requiresFlutterApp) {
    assertFlutterApp(Directory.current);
  }

  final title = await buildTitle(
    config.template.titlePlaceholder,
    config.issueFile,
  );

  if (title.isEmpty) {
    throw InterruptException('User inturrupted the process at title prompt.');
  }

  final String body = await buildIssueBody(config.template, config.issueFile);

  return Uri.http(
    config.tracker.website,
    config.tracker.endpoint,
    <String, String>{
      'labels': config.template.labels.join(', '),
      'body': body,
      'title': title,
      ...config.tracker.customParameters,
    },
  );
}

Future<String> buildTitle(String placeholder, String filename) async {
  stdout.add('Please enter a suitable title according to the placeholder in '
          'the opened file (named .issue.txt) and then close it.\n'
      .codeUnits);
  return await promptUserInputViaFile(placeholder, filename);
}

Future<String> buildIssueBody(IssueTemplate template, String filename) async {
  String body = '';

  for (IssueSection section in template.sections) {
    final String sectionBody = await buildIssueSection(section, filename);
    if (sectionBody.isEmpty) {
      throw InterruptException(
          'User inturrupted the process at $section prompt.');
    }
    body += sectionBody;
  }

  return body;
}

Future<String> buildIssueSection(IssueSection section, String filename) async {
  String builtSection = section.build();

  if (builtSection.isEmpty) {
    throw UnexpectedException('Issue section $section built empty string.');
  }

  if (section.isDrivenBy == IssueSectionDrivenBy.none) {
    return section.build();
  }
  if (section.isDrivenBy == IssueSectionDrivenBy.command) {
    ProcessResult result = await Process.run(
      section.command!.first,
      section.command!.sublist(1),
    );

    if (result.exitCode != 0) {
      throw Exception(
        'Command failed with exit code: ${result.exitCode} at $section prompt.',
      );
    }

    String output = result.stdout.toString();

    return section.build().replaceFirst(section.placeholder!, output);
  } else {
    return await promptUserInputViaFile(section.build(), filename);
  }
}
