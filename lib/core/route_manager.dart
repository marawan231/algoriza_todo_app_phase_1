import 'package:algoriza_todo_app/business_logic/cubit/cubit/tasks_cubit.dart';
import 'package:algoriza_todo_app/presentation/screens/add_task/add_task_view.dart';
import 'package:algoriza_todo_app/presentation/screens/board/board_view.dart';
import 'package:algoriza_todo_app/presentation/screens/schedule_task/schedule_task_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String splashRoute = "/";
  static const String addTask = "/addTask";
  static const String scheduleRoute = "/scheduleRoute";
}

class RouteGenerator {
  late TasksCubit tasksCubit;

  RouteGenerator() {
    tasksCubit = TasksCubit();
  }

  Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: tasksCubit,
                  child: const BoardView(),
                ));

      case Routes.addTask:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: tasksCubit,
                  child: const AddTaskView(),
                ));
      case Routes.scheduleRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: tasksCubit,
                  child: const ScheduleTasksView(),
                ));
      // case Routes.forgotPasswordRoute:
      //   return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      // case Routes.mainRoute:
      //   return MaterialPageRoute(builder: (_) => const MainView());
      // case Routes.storeDetailsRoute:
      //   return MaterialPageRoute(builder: (_) => const StoreDetailsView());
      // case Routes.onBoardingRoute:
      //   return MaterialPageRoute(builder: (_) => const OnBoardingView());

    }
    return null;
  }
}
