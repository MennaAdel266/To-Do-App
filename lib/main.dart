import 'package:first_app/Modules/splash_screen.dart';
import 'package:first_app/Shared/Cubit/dark_cubit.dart';
import 'package:first_app/Shared/Cubit/dark_states.dart';
import 'package:first_app/Shared/Cubit/states.dart';
import 'package:first_app/Shared/Network/local/cache_helper.dart';
import 'package:first_app/Shared/Network/remote/dio_helper.dart';
import 'package:first_app/Shared/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark= CacheHelper.getBoolean(key: 'isDark');

  runApp(MyApp(isDark));
}

//class MyApp
class MyApp extends StatelessWidget
{
  final bool isDark;
  MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DarkCubit()..changeAppMode(
        fromShared: isDark,
      ),
      child: BlocConsumer<DarkCubit, DarkStates>(
        listener: (context, states){},
        builder: (context, states){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:  ThemeData(
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: Colors.white,
              tabBarTheme: TabBarTheme(
                labelColor: Colors.deepOrange,
                labelStyle: TextStyle(
                  color: Colors.deepOrange,
                ),
                unselectedLabelColor: Colors.black,
              ),
              appBarTheme: AppBarTheme(
                titleSpacing: 20,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepOrange,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.white,
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: HexColor('333739'),
              tabBarTheme:  TabBarTheme(
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                unselectedLabelColor: Colors.deepOrange,
              ),
              appBarTheme: AppBarTheme(
                titleSpacing: 20,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor:HexColor('333739'),
                  statusBarIconBrightness: Brightness.light,
                ),
                backgroundColor: HexColor('333739'),
                elevation: 0,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepOrange,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: HexColor('333739'),
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            themeMode: DarkCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

