class ToDo {
  String title, description, label;
  bool completed;
  bool ReminderOn;
  DateTime creationDate;
  DateTime timeReminder;
  int reminderId;
  ToDo(
    this.title,
    this.description,
    this.completed,
    this.ReminderOn,
    this.creationDate,
    this.timeReminder,
    this.reminderId,
    this.label,
  );
}
