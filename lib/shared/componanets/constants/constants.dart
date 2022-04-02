// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

// https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca



import 'package:lovestories/shared/cach_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
String? tokenn;


void removeToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove('token');
  tokenn = '';
}

void setToken(String token) {
  CacheHelper.saveData(key: 'token', value: token).then((value) {
    //print('tokkkkkkkkkkkkkkkkkk kkkkkkkkkk kkkkkk');
  }).catchError((onError) {
    print('error is :' + onError.toString());
  });
  tokenn = token;
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
