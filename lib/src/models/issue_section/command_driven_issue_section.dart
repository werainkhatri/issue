import 'issue_section.dart';

class FlutterDoctorIssueSection extends DetailsIssueSection {
  static const kPlaceholder = 'PASTE FLUTTER DOCTOR OUTPUT HERE';

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
```''');
}
