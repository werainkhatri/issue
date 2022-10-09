import 'package:issue/src/models/issue_section/issue_section.dart';
import 'package:test/test.dart';

void main() {
  group(FlutterDoctorIssueSection, () {
    test('', () {
      final section = FlutterDoctorIssueSection();
      expect(section.content, '''
<details>
<summary>Flutter Doctor</summary>

```bash
PASTE FLUTTER DOCTOR OUTPUT HERE
```
</details>''');
      expect(section.command, ['flutter', 'doctor']);
    });

    test('verbose', () {
      final section = FlutterDoctorIssueSection(verbose: true);
      expect(section.content, '''
<details>
<summary>Flutter Doctor</summary>

```bash
PASTE FLUTTER DOCTOR OUTPUT HERE
```
</details>''');
      expect(section.command, ['flutter', 'doctor', '-v']);
    });
  });
}
