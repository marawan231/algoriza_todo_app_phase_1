import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:algoriza_todo_app/presentation/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/cubit/tasks_cubit.dart';
import '../../core/constants.dart';
import '../../data/models/task.dart';

class ScheduledTaskItem extends StatefulWidget {
  const ScheduledTaskItem(
      {Key? key, required this.selectedDateTask, required this.index})
      : super(key: key);
  final Task selectedDateTask;
  final int index;

  @override
  State<ScheduledTaskItem> createState() => _ScheduledTaskItemState();
}

class _ScheduledTaskItemState extends State<ScheduledTaskItem> {
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      height: 80,
      child: Card(
        color: myRed,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedDateTask.taskStartTime!.padLeft(2, "0"),
                    style: const TextStyle(
                      color: myWhite,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.selectedDateTask.taskTitle!,
                    style: const TextStyle(
                      color: myWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            MyCustomCheckBox(
              uncheckedFillColor: Colors.transparent,
              uncheckedIconColor: Colors.transparent,
              borderColor: myWhite,
              splashRadius: 1,
              borderWidth: 1,
              checkedFillColor: Colors.transparent,
              shouldShowBorder: true,
              borderRadius: 10,
              value: widget.selectedDateTask.isCompleted,
              onChanged: (bool value) {
                setState(() {
                  checkBoxValue = value;
                  widget.selectedDateTask.isCompleted = value;
                });
                BlocProvider.of<TasksCubit>(context).taskIsDoneOrNot(
                  widget.selectedDateTask.isCompleted,
                  widget.index,
                  widget.selectedDateTask.id!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
