import 'package:first_app/Shared/Cubit/states.dart';
import 'package:first_app/Shared/Network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit <AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when created table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });

  }

  insertDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks (title,date, time, status) VALUES(" $title","$date","$time","new")',
      ).then((value) {
        print('$value insert successed');

        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting new ${error.toString()}');
      });

      return null;
    });
  }
  void getDataFromDatabase(database)
  {
    newTasks= [];
    doneTasks= [];
    archiveTasks= [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else  if(element['status'] == 'done')
          doneTasks.add(element);
        else archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) async
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomShetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  })
  {
    isBottomShetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  // bool isDark = false;
  // ThemeMode appMode = ThemeMode.dark;
  // void changeAppMode({bool fromShared})
  // {
  //   if(fromShared != null)
  //   {
  //     isDark = fromShared;
  //     emit(AppChangeMoodState());
  //   } else
  //   {
  //     isDark = !isDark;
  //     CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
  //       emit(AppChangeMoodState());
  //     });
  //   }
  // }


}