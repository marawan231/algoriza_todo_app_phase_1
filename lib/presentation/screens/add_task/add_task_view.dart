// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_const_constructors

import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:algoriza_todo_app/core/constants.dart';
import 'package:algoriza_todo_app/data/models/task.dart';
import 'package:algoriza_todo_app/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({Key? key}) : super(key: key);

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();

  TextEditingController endTimeController = TextEditingController();

  String? selectedReminfTime;
  String? selectedRepeatTime;
  var selectedEndTime;
  var selectedStartTime;

  DateTime? startDate;
  DateTime? endDate;
  int remainingMinutes = 0;

// Get the Duration using the diferrence method

// Duration dif = endDate.difference(startDate);

// // Print the result in any format you want
// print(dif.toString(); // 12:00:00.000000
// print(dif.inHours); // 12
  var uuid = const Uuid();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: timeNow,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: myGreen, // header background color
                onPrimary: myWhite, // header text color
                onSurface: myGreen,
                onPrimaryContainer: myWhite, // body text color
                onSecondaryContainer: myWhite,
                inversePrimary: myWhite,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != timeNow) {
      setState(() {
        timeNow = pickedS;
      });
    }
  }

  _buildBody(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              //  height: 500,
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTitleTextField(context),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildDateTextField(context),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      _buildStartTimeTextField(context),
                      const SizedBox(
                        width: 16,
                      ),
                      _buildEndTimeTextField(context),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildRemindDropDownMenu(context),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildRepeatDropDownMenu(context),
                ],
              ),
            ),
          ),
        ),
        _buildCreateTaskButton(),
      ],
    );
  }

  int getMinutesDiff(TimeOfDay tod1, TimeOfDay tod2) {
    return (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  }

  Widget _buildCreateTaskButton() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 16,
      ),
      child: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is AddTaskSuccess) {
            remainingMinutes = getMinutesDiff(selectedEndTime, TimeOfDay.now());
            if (selectedReminfTime == '10 minutes early') {
              if (remainingMinutes == 10) {
                _showNotificationCustomSound();
              }
            }
            if (selectedReminfTime == '30 minutes early') {
              if (remainingMinutes == 30) {
                _showNotificationCustomSound();
              }
            }
            if (selectedReminfTime == '1 hour early') {
              if (remainingMinutes == 60) {
                _showNotificationCustomSound();
              }
            }
            if (selectedReminfTime == '1 Day') {
              if (remainingMinutes == 1440) {
                _showNotificationCustomSound();
              }
            }

            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return state is AddTaskLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: myWhite,
                  ),
                )
              : CustomButton(
                  text: 'Create a Task',
                  onTap: () {
// Print the result in any format you want
                    // 12
                    final Task newTask = Task(
                      id: idGenerator(),
                      taskTitle: titleController.text,
                      taskDate: dateController.text,
                      taskStartTime: startTimeController.text,
                      taskEndTime: endTimeController.text,
                      taskRepeatTime: selectedRepeatTime,
                      taskRemindTime: selectedReminfTime,
                    );
                    if (titleController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        startTimeController.text.isEmpty ||
                        endTimeController.text.isEmpty ||
                        selectedReminfTime == null ||
                        selectedRepeatTime == null) {
                      showScaffold(
                        text: 'Please complete task info',
                        context: context,
                        color: myRed,
                      );
                    } else {
                      BlocProvider.of<TasksCubit>(context).addTask(newTask);
                    }
                  },
                );
        },
      ),
    );
  }

  _buildStartTimeTextField(context) {
    return Expanded(
      child: CustomTextField(
        text: 'Start time',
        controller: startTimeController,
        hintText: '',
        suffixIcon: Icons.alarm,
        suffixIconSize: 22,
        onPressed: () async {
          await _selectTime(context);
          setState(() {
            selectedStartTime = timeNow;
            startTimeController.text =
                "${timeNow.hour}:${timeNow.minute} ${timeNow.period.name}";
            print(selectedStartTime);
          });
        },
      ),
    );
  }

  _buildEndTimeTextField(context) {
    return Expanded(
      child: CustomTextField(
        text: 'End time',
        controller: endTimeController,
        hintText: '',
        suffixIcon: Icons.alarm,
        suffixIconSize: 22,
        onPressed: () async {
          await _selectTime(context);
          setState(() {
            selectedEndTime = timeNow;
            endTimeController.text =
                "${timeNow.hour}:${timeNow.minute} ${timeNow.period.name}";
            print(selectedEndTime);
          });
        },
      ),
    );
  }

  Widget _buildRepeatDropDownMenu(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Repeat',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: myGrey,
              border: Border.all(color: myGrey, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                style: const TextStyle(
                    color: myDarkGrey, fontWeight: FontWeight.bold),
                hint: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Choose Repeat Time',
                    style: TextStyle(
                        color: myDarkGrey, fontWeight: FontWeight.bold),
                  ),
                ),
                items: repeatTimes
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                isExpanded: true,
                iconSize: 30,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color.fromARGB(255, 185, 180, 180),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedRepeatTime = value as String?;
                  });
                },
                value: selectedRepeatTime,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildRemindDropDownMenu(context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Remind',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: myGrey,
              border: Border.all(color: myGrey, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                style: const TextStyle(
                    color: myDarkGrey, fontWeight: FontWeight.bold),
                hint: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Choose Remind Time',
                    style: TextStyle(
                        color: myDarkGrey, fontWeight: FontWeight.bold),
                  ),
                ),
                items: remindTimes
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                isExpanded: true,
                iconSize: 30,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color.fromARGB(255, 185, 180, 180),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedReminfTime = value as String?;
                  });
                },
                value: selectedReminfTime,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTitleTextField(context) {
    return CustomTextField(
      text: 'Title',
      controller: titleController,
      hintText: 'Please Enter Your Task Here',
    );
  }

  _buildDateTextField(context) {
    return CustomTextField(
      text: 'Date',
      controller: dateController,
      hintText: 'DD       MM       YYYY',
      suffixIcon: Icons.calendar_month_outlined,
      onPressed: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(1940),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: myGreen, // header background color
                  onPrimary: myWhite, // header text color
                  onSurface: myGreen, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.red, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        setState(() {
          dateController.text = DateFormat("yyyy/MM/dd").format(newDate!);
        });

        if (newDate == null) {
          return showScaffold(
            text: 'chosse birthday correct',
            context: context,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      appBar: AppBar(
        leading: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * .05),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: myBlack,
              size: 13,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: 2,
            color: myGrey,
          ),
        ),
        title: const Text(
          'Add task',
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

  // void scheduledAlarm() async {

  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'alarm_notif',
  //     'my_alarm_notif',
  //     channelDescription: 'your channel Des',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //     sound: RawResourceAndroidNotificationSound('notify'),
  //   );

  //   var platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.schedule(
  //     0,
  //     'plain title',
  //     'plain body',
  //     scheduledNotifitcationDateTime,
  //     platformChannelSpecifics,
  //   );
  // }

  Future<void> _showNotificationCustomSound() async {
    var scheduledNotifitcationDateTime =
        DateTime.now().add(Duration(seconds: 1));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'Devoloped by Marawan Aly',
      channelDescription: 'Junior Flutter Developer',
      sound: RawResourceAndroidNotificationSound('notify'),
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'plain title',
      'plain body',
      scheduledNotifitcationDateTime,
      platformChannelSpecifics,
    );
  }

  Future<void> _repeatNotification(repeatInterval) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      channelDescription: 'repeating description',
      sound: RawResourceAndroidNotificationSound('notify'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', repeatInterval, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }
}
