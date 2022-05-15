import 'package:first_app/Shared/Components/components.dart';
import 'package:first_app/Shared/Cubit/cubit.dart';
import 'package:first_app/Shared/Cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).newTasks;
        return tasksBuilder(
          tasks: tasks,
        );

      },
    );
  }
}