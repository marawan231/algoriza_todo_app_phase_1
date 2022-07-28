// ignore_for_file: avoid_print

import 'dart:math';

import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:algoriza_todo_app/presentation/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/task.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);
  final Task task;
  final int index;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool valueOfCheckBox = false;
  Color colorOfCheckBox = Colors.red;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        print(state.toString());
      },
      builder: (context, state) {
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            BlocProvider.of<TasksCubit>(context)
                .deleteTask(widget.index, widget.task.id!);
          },
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content:
                      const Text("Are you sure you wish to delete this item?"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("DELETE")),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 8),
            child: ListTile(
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: widget.task.isFavourite
                      ? const Icon(
                          Icons.favorite,
                          color: myRed,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                        ),
                  onPressed: () {
                    widget.task.isFavourite =
                        BlocProvider.of<TasksCubit>(context).toggleFavourite(
                      widget.task.isFavourite,
                      widget.index,
                      widget.task.id!,
                    );
                  },
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 2),
              leading: Transform.scale(
                scale: 1.3,
                child: MyCustomCheckBox(
                  splashRadius: 1,
                  borderColor: colorOfCheckBox,
                  checkedFillColor: colorOfCheckBox,
                  //checkBoxSize: 10,
                  value: widget.task.isCompleted,

                  onChanged: (bool value) {
                    setState(() {
                      valueOfCheckBox = value;
                      widget.task.isCompleted = value;
                    });
                    BlocProvider.of<TasksCubit>(context).taskIsDoneOrNot(
                      widget.task.isCompleted,
                      widget.index,
                      widget.task.id!,
                    );
                  },
                ),
              ),
              title: Text(
                widget.task.taskTitle!.toString(),
              ),
            ),
          ),
        );
      },
    );
  }
}
