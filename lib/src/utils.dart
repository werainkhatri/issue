import 'dart:io';

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

extension IfNonNull on Object? {
  R? ifNonNull<T, R>(R Function(T) callback) {
    if (this != null) {
      return callback(this as T);
    }
    return null;
  }
}
