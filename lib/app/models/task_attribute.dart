/// Task attributes shown on the detail page, in display order.
///
/// [name] is the Taskwarrior field name, used both as the on-screen label and
/// as the key passed to `Modify.set`.
enum TaskAttribute {
  description,
  status,
  entry,
  modified,
  start,
  end,
  due,
  wait,
  until,
  priority,
  project,
  tags,
  urgency;

  /// Attributes that are only ever displayed, never edited.
  bool get isDisplayOnly =>
      this == TaskAttribute.entry ||
      this == TaskAttribute.modified ||
      this == TaskAttribute.urgency;
}
