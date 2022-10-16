part of 'issue.dart';

class _IssueBuilder {
  _IssueBuilder(this.config)
      : _userProgressState = buildUserProgressState(config);
  final IssueConfig config;
  final interact.ProgressState _userProgressState;

  /// Builds an issue from the given [config] and returns the URI of the issue.
  Future<Uri> build() async {
    if (config.template.requiresFlutterApp) {
      assertFlutterApp(Directory.current);
    }

    introductoryHelp();

    // without this, the progress bar will not be displayed, for some reason.
    _userProgressState.increase(0);

    var title = await buildIssueTitle();

    var body = await buildBody();

    closingComments();

    return Uri.http(
      config.tracker.website,
      config.tracker.endpoint,
      <String, String>{
        'assignees': config.template.assignees.join(','),
        'labels': config.template.labels.join(', '),
        'body': body,
        'title': title,
        ...config.tracker.customParameters,
      },
    );
  }

  Future<String> buildIssueTitle() async {
    var title = await promptUserInputViaFile(
      config.template.titleTemplate,
      config.issueFileName,
    );

    if (title.isEmpty) {
      throw UserInterruptException(
        'User inturrupted the process at title prompt.',
      );
    }

    // title built successfully.
    _userProgressState.increase(1);

    return title;
  }

  Future<String> buildBody() async {
    List<IssueSection> sections = [
      ...config.template.sections,
      if (config.template.credits) const CreditsIssueSection(),
    ];
    var bodySections = List<String>.filled(sections.length, '');

    Future<void> buildIssueSections({required bool onlyUserDriven}) async {
      for (int i = 0; i < sections.length; i++) {
        var section = sections[i];

        if ((section.isDrivenBy == DrivenBy.user) != onlyUserDriven) continue;

        var sectionBody = await buildIssueSection(section);

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

    // build user driven issue sections first.
    await buildIssueSections(onlyUserDriven: true);
    _userProgressState.done();

    // then build other (command and none driven) issue sections.
    var spinner = buildCommandSpinner();
    await buildIssueSections(onlyUserDriven: false);
    spinner.done();

    return joinBuiltIssueSections(bodySections);
  }

  Future<String> buildIssueSection(IssueSection section) async {
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
      return promptUserInputViaFile(
        section.build(),
        config.issueFileName,
      );
    } else {
      // none driven issue section.
      return section.build();
    }
  }

  void introductoryHelp() {
    stdout.writeln(kIntroductoryHelpText);
    interact.Confirm(prompt: 'Ready?').interact();
  }

  void closingComments() {
    stdout.writeln(kClosingCommentsText);
  }
}
