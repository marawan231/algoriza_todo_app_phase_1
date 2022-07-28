import 'dart:io';
import 'dart:math';

import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:algoriza_todo_app/core/constants.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/app_colors.dart';
import '../../../data/models/task.dart';
import '../../widgets/days_calender_item.dart';
import '../../widgets/scheduled_task_item.dart';

class ScheduleTasksView extends StatefulWidget {
  const ScheduleTasksView({Key? key}) : super(key: key);

  @override
  State<ScheduleTasksView> createState() => _ScheduleTasksViewState();
}

class _ScheduleTasksViewState extends State<ScheduleTasksView> {
  DateTime? currentSelectedDate;
  var currentMon = date.month;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  bool isSelected = false;

  var selectedDate = DateFormat('d').format(date.add(Duration(days: 1)));

  Widget _buildWeekDaysList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: ListView.builder(
        itemCount: lastDayOfMonth.day,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          //  final isSelected = selectedIndexs.contains(index);
          return DaysCalenderItem(
            isSelected: isSelected,
            index: index,
            dayName: () {
              final currentDate = date.add(Duration(days: index));

              final dateName = DateFormat('E').format(currentDate);

              return dateName;
            }(),
            dayNumber: () {
              final currentDate = date.add(Duration(days: index));

              final dateNumber = DateFormat('d').format(currentDate);

              return dateNumber;
            }(),
          );
        },
      ),
    );
  }

  _buildBody(context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TasksOfDaySelected) {
          setState(() {
            currentSelectedDate = state.selectedDate;
          });
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 16,
          ),
          child: Column(
            children: [
              _buildCurrentDay(),
              _buildTasksForCurrentDay(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentDay() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ' ${DateFormat('EEEE').format(currentSelectedDate ?? date)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          currentSelectedDate == null
              ? Text('${date.day} ${months[currentMon - 1]}, ${date.year}')
              : Text(
                  '${currentSelectedDate!.day} ${months[currentSelectedDate!.month - 1]}, ${currentSelectedDate!.year}'),
        ],
      ),
    );
  }

  _buildEmptyTasksForDay() {
    return EmptyWidget(
      image: null,
      packageImage: PackageImage.Image_2,
      title: 'No Tasks Today',
      subTitle: 'Take a rest',
      titleTextStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xff9da9c7),
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xffabb8d6),
      ),
    );
  }

  Widget _buildTasksForCurrentDay(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    List<Task> scheduleTasksForThisDay = BlocProvider.of<TasksCubit>(context)
        .tasks
        .where((task) => selectedDateFor == task.taskDate!)
        .toList();
    return scheduleTasksForThisDay.isEmpty
        ? _buildEmptyTasksForDay()
        : Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: scheduleTasksForThisDay.length,
                itemBuilder: (context, index) {
                  return ScheduledTaskItem(
                    selectedDateTask: scheduleTasksForThisDay[index],
                    index: index,
                  );
                },
              ),
            ),
          );
  }

  // static List<String> getDaysOfWeek([String? locale]) {
  //   final now = DateTime.now();
  //   final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
  //   return List.generate(7, (index) => index)
  //       .map((value) => DateFormat(DateFormat.WEEKDAY, locale)
  //           .format(firstDayOfWeek.add(Duration(days: value))))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: myBlack,
            size: 13,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              color: myWhite,
              border: Border(
                bottom: BorderSide(width: 3, color: myGrey),
                top: BorderSide(width: 3, color: myGrey),
              ),
            ),
            child: _buildWeekDaysList(context),
          ),
        ),
        title: const Text(
          'Schedule',
          style: TextStyle(
            color: myBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: myWhite,
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0.0,
        backgroundColor: myWhite,
      ),
      body: _buildBody(context),
    );
  }
}
