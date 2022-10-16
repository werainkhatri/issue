part of 'issue_section.dart';

class FlutterDoctorIssueSection extends DetailsIssueSection {
  FlutterDoctorIssueSection({
    super.heading = '### Flutter Doctor',
    bool verbose = false,
  }) : super.commandDriven(
          summary: 'Flutter Doctor',
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

  static const kPlaceholder = 'PASTE FLUTTER DOCTOR OUTPUT HERE';
}
