import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static  SharedPreferences? sharedPreferences;

  static Future<dynamic> init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
     @required String? key,
     @required bool? value,
  }) async
  {
    return await sharedPreferences!.setBool(key!, value!);
  }

  static dynamic getData({
    @required String? key,
  }) {
    return sharedPreferences!.get(key!);
  }

  static Future<bool> saveData({
    @required String? key,
    @required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key!, value);
    if (value is int) return await sharedPreferences!.setInt(key!, value);
    if (value is bool) return await sharedPreferences!.setBool(key!, value);


    return await sharedPreferences!.setDouble(key!, value);
  }

  static Future<bool> saveList({
    @required String? key,
    @required dynamic value,
}) async {
   return await sharedPreferences!.setStringList(key!, value);
  }

  static List<String> getList({
    required String? key,
}){
    try{
      return sharedPreferences!.getStringList(key!)!;
    }catch(onError){
      print('onError ${onError}');
      return [];
    }

  }



  static Future<bool> removeData({
    @required String? key,
  }) async
  {
    return await sharedPreferences!.remove(key!);
  }
}