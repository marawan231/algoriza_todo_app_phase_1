import 'dart:math';

import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_colors.dart';
import '../../widgets/task_item.dart';

class NotDoneTasksView extends StatelessWidget {
  const NotDoneTasksView({Key? key}) : super(key: key);
  Widget buildBlocWidget() {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        return buildTheBody(context);
      },
    );
  }

  Widget buildTheBody(context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: ListView.builder(
                itemCount: BlocProvider.of<TasksCubit>(context)
                    .tasks
                    .where((element) => element.isCompleted == false)
                    .toList()
                    .length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    task: BlocProvider.of<TasksCubit>(context)
                        .tasks
                        .where((element) => element.isCompleted == false)
                        .toList()[index],
                    index: index,
                  );
                }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
