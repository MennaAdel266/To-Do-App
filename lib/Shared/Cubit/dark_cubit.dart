import 'package:first_app/Shared/Cubit/dark_states.dart';
import 'package:first_app/Shared/Network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DarkCubit extends Cubit <DarkStates> {
  DarkCubit() : super(DarkAppInitialState());

  static DarkCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark;

  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(DarkAppChangeMoodState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(DarkAppChangeMoodState());
      });
    }
  }
}