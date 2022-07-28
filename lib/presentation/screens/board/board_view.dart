import 'dart:math';

import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:algoriza_todo_app/core/route_manager.dart';
import 'package:algoriza_todo_app/db/tasks_database.dart';
import 'package:algoriza_todo_app/presentation/screens/done_tasks/done_tasks_view.dart';
import 'package:algoriza_todo_app/presentation/screens/favourit_tasks/favourite_tasks_view.dart';
import 'package:algoriza_todo_app/presentation/screens/not_done_tasks/not_done_tasks_view.dart';
import 'package:algoriza_todo_app/presentation/widgets/custom_button.dart';
import 'package:algoriza_todo_app/presentation/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardView extends StatefulWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  _buildAllTasksView(context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is AddTaskSuccess || state is DeleteTaskSuccess) {
          refreshNote();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                    itemCount:
                        BlocProvider.of<TasksCubit>(context).tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: BlocProvider.of<TasksCubit>(context).tasks[index],
                        index: index,
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: CustomButton(
                text: 'Add a task',
                onTap: () {
                  Navigator.pushNamed(context, Routes.addTask);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _buildCompletedTaskView() {
    return const DoneTasksView();
  }

  _buildUncomletedTaskView() {
    return const NotDoneTasksView();
  }

  _buildFavouriteTasksView() {
    return const FavouriteTasksView();
  }

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => true);
    BlocProvider.of<TasksCubit>(context).tasks =
        await TasksDatabase.instance.readAllNotes();
    setState(() => false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: myWhite,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: myWhite,
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0.0,
          backgroundColor: myWhite,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                top: 16,
              ),
              child: IconButton(
                icon:
                    Icon(Icons.calendar_month, color: myBlack.withOpacity(.7)),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.scheduleRoute);
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              //padding: EdgeInsets.only(bottom: 0),
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.5, color: myGrey),
                top: BorderSide(width: 1.5, color: myGrey),
              )),
              child: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                  Tab(
                    text: 'Uncompleted',
                  ),
                  Tab(
                    text: 'Favourite',
                  ),
                ],
              ),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Board',
              style: TextStyle(
                color: myBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllTasksView(context),
            _buildCompletedTaskView(),
            _buildUncomletedTaskView(),
            _buildFavouriteTasksView(),
          ],
        ),
      ),
    );
  }
}
