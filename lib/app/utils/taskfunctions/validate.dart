void validateTaskDescription(String description) {
  if (description.isEmpty) {
    throw FormatException(
      'Empty description will provoke a server error.',
      description,
      0,
    );
  } else if (description.endsWith(r'\')) {
    throw FormatException(
      'Trailing backslashes may corrupt your Taskserver account.',
      description,
      description.length - 1,
    );
  }
}

void validateTaskProject(String project) {
  if (project.endsWith(r'\')) {
    throw FormatException(
      'Trailing backslashes may corrupt your Taskserver account.',
      project,
      project.length - 1,
    );
  }
}

void validateTaskTags(String tag) {
  if (tag.contains(' ')) {
    throw FormatException(
      'Taskwarrior documentation on JSON format indicates your task tag '
      'should not contain spaces.',
      tag,
      tag.indexOf(' '),
    );
  }
}
