const kIssueFile = '.issue.md';

const kIntroductoryHelpText = '''
Welcome to "issue" 👋!

This tool will help you create an issue in an interactive way and open a browser window for you to submit it.

There will be a series of steps each consisting of a file prompt and a progress indicator in the CLI. To proceed, enter the relavent information in the file, save and close it.

To cancel anytime, clear the contents of the file (Ctrl + A, then Backspace) and close it, OR press Ctrl + C in the CLI.
''';

const kClosingCommentsText = '''

A browser window will now open for you to press "Submit new issue".

Thank you for using "issue"! Hope you had fun. 😊
''';

const kTitleTemplateDefault = 'Please enter a suitable title.';
const kTitlePromptDefault = 'Issue title';
