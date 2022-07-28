part of 'tasks_cubit.dart';

@immutable
abstract class TasksState {}

class TasksInitial extends TasksState {}

class AddTaskLoading extends TasksState {}

class AddTaskSuccess extends TasksState {}

class AddTaskError extends TasksState {}

class FavouriteTasksLoaded extends TasksState {
  final List<Task> favouriteTasks;

  FavouriteTasksLoaded(this.favouriteTasks);
}

class TaskIsFavourite extends TasksState {}

class TaskIsNotFavourite extends TasksState {}

class DoneTasksLoaded extends TasksState {
  final List<Task> doneTasks;

  DoneTasksLoaded(this.doneTasks);
}

class TasksOfDaySelected extends TasksState {
  final DateTime selectedDate;

  TasksOfDaySelected(this.selectedDate);
}

class DeleteTaskSuccess extends TasksState {}

class TaskIsDone extends TasksState {}

class TaskIsNotDone extends TasksState {}
