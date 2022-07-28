import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:algoriza_todo_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DaysCalenderItem extends StatefulWidget {
  DaysCalenderItem({
    Key? key,
    this.dayName,
    this.dayNumber,
    this.index,
    this.isSelected,
    this.onTap,
  }) : super(key: key);
  final String? dayName;
  final String? dayNumber;
  final int? index;
  bool? isSelected;
  final void Function()? onTap;

  @override
  State<DaysCalenderItem> createState() => _DaysCalenderItemState();
}

class _DaysCalenderItemState extends State<DaysCalenderItem> {
  //final List<DateTime> ?dateTimes;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            BlocProvider.of<TasksCubit>(context)
                .selectDayToShowTasks(widget.index!);

            if (selectedIndex == widget.index) {
              // Again Click on Same Item
              // setState(() {
              //   selectedIndex = -1;
              //   widget.isSelected = false;
              //   print(widget.isSelected);
              // });
              // Set to -1 to indicate nothing is selected!
            } else {
              setState(() {
                selectedIndex = widget.index!;
                widget.isSelected = true;
                print(widget.isSelected);
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: 8,
              top: 16,
              bottom: 16,
              // right: 16,
            ),
            decoration: BoxDecoration(
                color: (selectedIndex == widget.index) ? myGreen : myWhite,
                borderRadius: const BorderRadius.all(Radius.circular(10))),

            width: 45,
            // height: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.dayName!,
                  style: TextStyle(
                    fontWeight: (selectedIndex == widget.index)
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: (selectedIndex == widget.index) ? myWhite : myBlack,
                  ),
                ),
                Text(
                  "${widget.dayNumber}",
                  style: TextStyle(
                    fontWeight: (selectedIndex == widget.index)
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: (selectedIndex == widget.index) ? myWhite : myBlack,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
