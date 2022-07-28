// ignore_for_file: depend_on_referenced_packages

import 'package:algoriza_todo_app/db/tasks_database.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../core/constants.dart';
import '../../../data/models/task.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  List<Task> tasks = [];
  List<Task> favouriteTasks = [];
  List<Task> doneTasks = [];

  void addTask(Task task) {
    emit(AddTaskLoading());
    // tasks.add(task);
    TasksDatabase.instance.create(task);
    emit(AddTaskSuccess());
  }

  void deleteTask(int index, int id) {
    tasks.removeAt(index);

    TasksDatabase.instance.delete(id);
    emit(DeleteTaskSuccess());
    // productsInCart.removeWhere(((product) => product.sId == id));
  }

  void selectDayToShowTasks(int index) {
    selectedDateFor = DateFormat("yyyy/MM/dd").format(dates[index]);
    emit(TasksOfDaySelected(dates[index]));
  }

  bool toggleFavourite(bool isFav, int index, int id) {
    isFav = !isFav;

    if (isFav) {
      emit(TaskIsFavourite());
      favouriteTasks.add(tasks[index]);
    } else if (!isFav) {
      favouriteTasks.removeWhere((task) => task.id == id);
      emit(TaskIsNotFavourite());
    }

    return isFav;
  }

  void taskIsDoneOrNot(bool isDone, int index, int id) {
    if (isDone) {
      emit(TaskIsDone());
      doneTasks.add(tasks[index]);
    } else if (!isDone) {
      doneTasks.removeWhere((task) => task.id == id);
      emit(TaskIsNotDone());
    }
  }
}
