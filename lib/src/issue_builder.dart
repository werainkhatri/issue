import 'dart:io';

import 'package:interact/interact.dart' as interact;
import 'package:issue/src/constants.dart';

import 'exceptions.dart';
import 'models/models.dart';
import 'utils.dart';

class IssueBuilder {
  final IssueConfig config;
  final interact.ProgressState _userProgressState;

  IssueBuilder(this.config)
      : _userProgressState = buildUserProgressState(config);

  /// Builds an issue from the given [config] and returns the URI of the issue.
  Future<Uri> build() async {
    if (config.template.requiresFlutterApp) {
      assertFlutterApp(Directory.current);
    }

    _introductoryHelp();

    // without this, the progress bar will not be displayed, for some reason.
    _userProgressState.increase(0);

    final title = await _buildIssueTitle();

    final body = await _buildBody();

    _closingComments();

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

  Future<String> _buildIssueTitle() async {
    final title = await promptUserInputViaFile(
        config.template.titlePlaceholder, config.issueFileName);

    if (title.isEmpty) {
      throw UserInterruptException(
          'User inturrupted the process at title prompt.');
    }

    // title built successfully.
    _userProgressState.increase(1);

    return title;
  }

  Future<String> _buildBody() async {
    final List<String> bodySections =
        List.filled(config.template.sections.length, '');

    Future<void> buildIssueSections({required bool onlyUserDriven}) async {
      for (int i = 0; i < config.template.sections.length; i++) {
        final section = config.template.sections[i];

        if ((section.isDrivenBy == DrivenBy.user) != onlyUserDriven) continue;

        final String sectionBody = await _buildIssueSection(section);

        if (sectionBody.isEmpty) {
          throw UserInterruptException(section.prompt);
        }

        if (onlyUserDriven) {
          // section built successfully.
          _userProgressState.increase(1);
        }

        bodySections[i] = sectionBody;
      }
    }

    // build ueser driven issue sections first.
    await buildIssueSections(onlyUserDriven: true);
    _userProgressState.done();

    // then build other (command and none driven) issue sections.
    final spinner = buildCommandSpinner();
    await buildIssueSections(onlyUserDriven: false);
    spinner.done();

    return joinBuiltIssueSections(bodySections);
  }

  Future<String> _buildIssueSection(IssueSection section) async {
    String builtSection = section.build();

    if (builtSection.isEmpty) {
      throw UnexpectedException('Issue section $section built empty string.');
    }

    if (section.isDrivenBy == DrivenBy.command) {
      ProcessResult result = await Process.run(
        section.command!.first,
        section.command!.sublist(1),
      );

      if (result.exitCode != 0) {
        throw CommandFailureException(section.prompt, result.exitCode);
      }

      String output = result.stdout.toString();

      return section.build().replaceFirst(section.placeholder!, output);
    } else if (section.isDrivenBy == DrivenBy.user) {
      return await promptUserInputViaFile(
        section.build(),
        config.issueFileName,
      );
    } else {
      // none driven issue section.
      return section.build();
    }
  }

  void _introductoryHelp() {
    stdout.writeln(kIntroductoryHelpText);
    interact.Confirm(prompt: 'Ready?').interact();
  }

  void _closingComments() {
    stdout.writeln(kClosingCommentsText);
  }
}
