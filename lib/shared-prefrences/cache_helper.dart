import 'package:shared_preferences/shared_preferences.dart';
class CacheHelper {
  static SharedPreferences? sharedPreferences;
  CacheHelper._();
  static Future<void > init()async{
    sharedPreferences=await SharedPreferences.getInstance();

  }
  static Future<bool>putStringDate({
  required String key,
    required String value
})async{
    return await sharedPreferences!.setString(key, value);
  }
  static Future<bool>putBoolDate({
  required String key,
    required bool value
})async{
    return await sharedPreferences!.setBool(key, value);
  }
static String? getStringData({required String key}){
    return  sharedPreferences!.getString(key);
}
static bool? getBoolData({required String key}){
    return  sharedPreferences!.getBool(key);
}
}
