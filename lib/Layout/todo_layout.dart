import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/Modules/archived_screen.dart';
import 'package:first_app/Modules/done_screen.dart';
import 'package:first_app/Modules/tasks_screen.dart';
import 'package:first_app/Shared/Components/components.dart';
import 'package:first_app/Shared/Cubit/cubit.dart';
import 'package:first_app/Shared/Cubit/dark_cubit.dart';
import 'package:first_app/Shared/Cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timingController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: Icon(
                          Icons.menu_outlined,
                        ),
                      text: 'Tasks',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.check_circle,
                      ),
                      text: 'Done',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      text: 'Archived',
                    ),
                  ],
                ),
                title: Text(
                  'Todo App',
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      DarkCubit.get(context).changeAppMode();
                    },
                    icon: Icon(
                      Icons.brightness_4_outlined,
                    ),
                  ),
                ],
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => TabBarView(children:[
                  NewTasksScreen(),
                  DoneTasksScreen(),
                  ArchivedTasksScreen(),
                ]),
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (cubit.isBottomShetShown) {
                      if (formKey.currentState.validate()) {
                        cubit.insertDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timingController.text,
                        );
                      }
                    } else {
                      scaffoldKey.currentState
                          .showBottomSheet(
                            (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFeild(
                                    label: 'Text Title',
                                    controller: titleController,
                                    prefix: Icons.title,
                                    type: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Text must not be empty ';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormFeild(
                                    label: 'Task time',
                                    controller: timingController,
                                    prefix: Icons.watch_later_outlined,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timingController.text =
                                            value.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty ';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormFeild(
                                    label: 'Task date',
                                    controller: dateController,
                                    prefix: Icons.date_range_outlined,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-12-12'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                        print(DateFormat.yMMMd().format(value));
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'date must not be empty ';
                                      }
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ),
                      )
                          .closed
                          .then((value) {
                        cubit.changeBottomSheetState(
                            isShow: false, icon: Icons.edit);
                      });
                      cubit.changeBottomSheetState(
                        icon: Icons.add,
                        isShow: true,
                      );
                    }
                  },
                  child: Icon(
                    cubit.fabIcon,
                  ),
                ),
            ),

          );
        },
      ),
    );
  }
}