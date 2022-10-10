import 'dart:io';

import 'package:ansi_styles/ansi_styles.dart';
import 'package:interact/interact.dart' as interact;
import 'package:issue/issue.dart';
import 'package:path/path.dart' as path;

Future<String> promptUserInputViaFile(
    String placeholder, String fileName) async {
  String currDir = Directory.current.absolute.path;

  File file = File(path.join(currDir, fileName));
  if (file.existsSync()) file.deleteSync();
  file.createSync();
  file.writeAsStringSync(placeholder);

  Process process = await Process.start(
    'code',
    ['--wait', file.path],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );

  int exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Failed to open editor');
  }

  String output = file.readAsStringSync();

  file.deleteSync();

  return output;
}

void assertFlutterApp(Directory directory) {
  if (!directory.existsSync()) {
    throw Exception('Directory does not exist: ${directory.path}');
  }

  final pubspec = File('${directory.path}/pubspec.yaml');
  if (!pubspec.existsSync()) {
    throw Exception('pubspec.yaml does not exist in ${directory.path}');
  }

  final pubspecContents = pubspec.readAsStringSync();
  if (!pubspecContents.contains('flutter:')) {
    throw Exception(
        'pubspec.yaml does not contain flutter: in ${directory.path}');
  }
}

void openInBrowser(String url) {
  switch (Platform.operatingSystem) {
    case 'macos':
      Process.run('open', [url]);
      break;
    case 'linux':
      Process.run('xdg-open', [url]);
      break;
    case 'windows':
      Process.run('cmd', ['/c', 'start', url]);
      break;
    default:
      throw UnsupportedError('Unsupported platform');
  }
}

bool promptBool(
  String prompt, {
  bool defaultValue = true,
}) {
  return interact.Confirm(
    prompt: prompt,
    defaultValue: defaultValue,
  ).interact();
}

interact.SpinnerState buildCommandSpinner() {
  return interact.Spinner(
    icon: AnsiStyles.green('✔'),
    rightPrompt: (done) => done ? 'Done' : 'Collecting system information',
  ).interact();
}

interact.ProgressState buildUserProgressState(IssueConfig config) {
  final userDrivenSections = config.template.sections
      .where((section) => section.isDrivenBy == DrivenBy.user)
      .toList();
  final padding = '  ';

  int totalSteps = userDrivenSections.length;
  List<String> prompts = [
    '${config.template.titlePrompt}$padding',
    for (final section in userDrivenSections) '${section.prompt}$padding',
  ];

  return interact.Progress(
    length: totalSteps,
    leftPrompt: (step) => prompts[step],
    rightPrompt: (step) => '${padding}Step: $step/$totalSteps',
  ).interact();
}

extension IsCase on String {
  bool get isUpperCase => this == toUpperCase();
  bool get isLowerCase => this == toLowerCase();
}
