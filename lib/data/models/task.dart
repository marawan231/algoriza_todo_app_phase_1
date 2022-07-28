// ignore_for_file: prefer_const_declarations

final String tableTasks = 'tasks';

class TasksField {
  static final List<String> values = [
    id,
    taskTitle,
    taskDate,
    taskStartTime,
    taskEndTime,
    taskRemindTime,
    taskRepeatTime,
    isCompleted,
    isFavourite,
  ];

  static final String id = '_id';
  static final String taskTitle = 'taskTitle';
  static final String taskDate = 'taskDate';
  static final String taskStartTime = 'taskStartTime';
  static final String taskEndTime = 'taskEndTime';
  static final String taskRemindTime = 'taskRemindTime';
  static final String taskRepeatTime = 'taskRepeatTime';
  static final String isCompleted = 'isCompleted';
  static final String isFavourite = 'isFavourite';
}

class Task {
  final int? id;
  final String? taskTitle;
  final String? taskDate;
  final String? taskStartTime;
  final String? taskEndTime;
  final String? taskRemindTime;
  final String? taskRepeatTime;
  bool isCompleted;
  bool isFavourite;
  bool isDaySelected;

  Task({
    this.id,
    this.taskTitle,
    this.taskDate,
    this.taskStartTime,
    this.taskEndTime,
    this.taskRemindTime,
    this.taskRepeatTime,
    this.isCompleted = false,
    this.isFavourite = false,
    this.isDaySelected = false,
  });

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TasksField.id] as int?,
        taskTitle: json[TasksField.taskTitle] as String?,
        taskDate: json[TasksField.taskDate] as String?,
        taskStartTime: json[TasksField.taskStartTime] as String?,
        taskEndTime: json[TasksField.taskEndTime] as String?,
        taskRemindTime: json[TasksField.taskRemindTime] as String?,
        taskRepeatTime: json[TasksField.taskRepeatTime] as String?,
        isCompleted: json[TasksField.isCompleted] == 1,
        isFavourite: json[TasksField.isFavourite] == 1,
      );

  Map<String, Object?> toJson() => {
        TasksField.taskTitle: taskTitle,
        TasksField.taskDate: taskDate,
        TasksField.taskStartTime: taskStartTime,
        TasksField.taskEndTime: taskEndTime,
        TasksField.taskRemindTime: taskRemindTime,
        TasksField.taskRepeatTime: taskRepeatTime,
        TasksField.id: id,
        TasksField.isFavourite: isFavourite ? 1 : 0,
        TasksField.isCompleted: isCompleted ? 1 : 0,
      };

  Task copy({
    int? id,
    final String? taskTitle,
    final String? taskDate,
    final String? taskStartTime,
    final String? taskEndTime,
    final String? taskRemindTime,
    final String? taskRepeatTime,
    bool isCompleted = false,
    bool isFavourite = false,
  }) =>
      Task(
        id: id ?? this.id,
        taskDate: taskDate ?? this.taskDate,
        taskStartTime: taskStartTime ?? this.taskStartTime,
        taskEndTime: taskEndTime ?? this.taskEndTime,
        taskRemindTime: taskRemindTime ?? this.taskRemindTime,
        taskRepeatTime: taskRepeatTime ?? this.taskRepeatTime,
        taskTitle: taskTitle ?? this.taskTitle,
      );
}
