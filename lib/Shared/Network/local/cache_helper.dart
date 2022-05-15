import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static SharedPreferences sharedPrefernces;

  static init() async
  {
    sharedPrefernces = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    @required String key,
    @required bool value,
  })async
  {
    return await sharedPrefernces.setBool(key,value );
  }

  static dynamic getData({
    @required String key,

  })
  {
    return sharedPrefernces.get(key);
  }

  static Future<bool> saveData({
    @required String key,
    @required dynamic value,
  }) async
  {
    if(value is String) return await  sharedPrefernces.setString(key,value );
    if(value is int) return await  sharedPrefernces.setInt(key,value );
    if(value is bool) return await  sharedPrefernces.setBool(key,value );

    return await  sharedPrefernces.setDouble(key,value );

  }

  static Future<bool> removeData({
    @required String key,
  }) async
  {
    return await sharedPrefernces.remove(key);
  }

  static bool getBoolean( {
    @required String key,
  })
  {
    return sharedPrefernces.getBool(key);
  }
}


