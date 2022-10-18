part of 'issue_section.dart';

class FlutterDoctorIssueSection extends DetailsIssueSection {
  FlutterDoctorIssueSection({
    super.heading = '### Flutter Doctor',
    this.verbose = false,
  }) : super.commandDriven(
          summary: 'flutter doctor${verbose ? ' -v' : ''}',
          command: [
            'flutter',
            'doctor',
            if (verbose) ...['-v']
          ],
          placeholder: kPlaceholder,
          details: '''
```bash
$kPlaceholder
```''',
        );

  /// Whether to run `flutter doctor` in verbose mode.
  ///
  /// Defaults to `false`.
  final bool verbose;

  static const kPlaceholder = 'PASTE FLUTTER DOCTOR OUTPUT HERE';

  @override
  List<Object?> get props => [super.props, verbose];
}
