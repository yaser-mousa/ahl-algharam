import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/modules/artical/artical.dart';
import 'package:lovestories/modules/artical/login.dart';
import 'package:lovestories/modules/create_stroy.dart';
import 'package:lovestories/modules/login/auth_name.dart';
import 'package:lovestories/styles/themes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


Widget myTextFormField(
        {
        // @required Key mykey,
        required TextEditingController? controller,
        required TextInputType? type,
        bool isPassword = false,
        IconData? sufix,
        Color iconColor = Colors.white,
        String labletext = '',
        Color background = Colors.white,
        //@required validateMsg,
        required IconData? fixicon,
        var sufixPressed,
        required var validatefun,
        var onChange,
        var onSubmit,
        double? contHi,
        var onTapFun,
        int maxLines = 1,
          int  maxLength= 3000,
        bool isEnabled = true,
         var textDirection}) =>
    TextFormField(
      // key: mykey,

      onFieldSubmitted: onSubmit,
      validator: validatefun,
      onChanged: onChange,
      enabled: isEnabled,
      maxLines: maxLines,
      onTap: onTapFun,
      style: TextStyle(color: Colors.black),
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      minLines: 1,
      maxLength: maxLength,
      decoration: InputDecoration(
          prefixIcon: Icon(fixicon),
          suffix: sufix != null
              ? GestureDetector(
                  onTap: sufixPressed,
                  child: Icon(sufix,
                      color: iconColor != null ? iconColor : Colors.white),
                )
              : null,
          labelText: labletext,
          border: OutlineInputBorder(),
          fillColor: background,
          filled: true),
    );

Widget defualtButton({
  double width = double.infinity,
  Color backdround = Colors.green,
  @required var function,
  @required String text = '',
  Color textColor = Colors.white,
  double radius = 0,
  bool isUpperCase = true,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backdround,
      ),
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: textColor),
        ),
      ),
    );

Widget defualtTextButton({
  @required var onPressed,
  @required String text = '',
}) =>
    TextButton(onPressed: onPressed, child: Text(text.toUpperCase()));


Widget drawerStories({required BuildContext context,required LoveCubit cubit}){
  int x =0;
  return Drawer(
    child: Stack(
      children: [
        ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: const BoxDecoration(
             color: Color(0xffF7DCEC),

              ),
              child: Text(
                'أهل الغرام',
                style: TextStyle(fontSize: cubit.setTextSize(19),  ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title:  Text(
                'تقييم',
                style: TextStyle(fontSize: cubit.setTextSize(19),color: Colors.grey),
              ),
              onTap: () async {

                launchURL(url: 'https://play.google.com/store/apps/details?id=com.yaserapps.loveStories');
                // Update the state of the app.
                //...
              },
              onLongPress: (){
                cubit.plusLoginShow();
                if(cubit.showLogin> 1){
                  cubit.changeYasAdmin();
                }

              },
            ),
            ListTile(
              leading:const Icon(Icons.share, color: Colors.deepPurpleAccent) ,
              title:  Text(
                'مشاركة التطبيق',
                style: TextStyle(fontSize:cubit.setTextSize(19), color: Colors.grey),
              ),
              onTap: ()async {
                await Share.share('https://play.google.com/store/apps/details?id=com.yaserapps.loveStories');
              },
            ),
            ListTile(
              leading:const Icon(Icons.apps, color: Colors.pink,) ,
              title:  Text(
                'تطبيقات أخرى',
                style: TextStyle(fontSize: cubit.setTextSize(19),color: Colors.grey),
              ),
              onTap: () {
                launchURL(url: 'https://play.google.com/store/apps/developer?id=Yaser+Shwahneh');
              },
            ),

            ListTile(
              leading:const Icon(Icons.facebook, color: Colors.blue,) ,
              title:  Text(
                'راسل المبرمج',
                style: TextStyle(fontSize: cubit.setTextSize(19),color: Colors.grey),
              ),
              onTap: () {
                launchURL(url: 'https://www.facebook.com/yaser.shwahneh');
              },
            ),
            if(cubit.showLogin> 1)
            ListTile(
              leading:const Icon(Icons.login) ,
              title:  Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: cubit.setTextSize(19), color: Colors.grey),
              ),
              onTap: () {
                cubit.initialEmailAndPasswordControllers();
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginScreen();
                }));
              },
            ),
          ],
        ),
      ],
    ),
  );
}

void launchURL({required String url}) async {
  if (!await launch(url)) throw 'Could not launch $url';
}


String handleText(String str){
  List<String> wordsX = ['شرموطة','طيزي','قحبة','قحبه','منيوكه','منيوكة','منيك','منيوك','طيز','نيك','أقحب', ' كس ', ' قحبة ',' بتنتاك ','بنتاك'];

  for(int x=0; x<wordsX.length; x++){
    str = str.replaceAll(wordsX[x], '***');
  }

  str = str.trim();
  str= str.replaceAll('\n', '/n');
  bool isTrue =false;

  print(str);
  for(int i=0; i<str.length-1 ; i++){
    String st = str[i] + str[i+1]+ i.toString();
//print(st);
    if(!isTrue){
      if(st.contains('/n')){
        isTrue = true;
        print('case 1');
      }
    }else{
      if(st.contains('/n')){
        str = str.replaceRange(i, i+2, '');
        print('case 2');
        i=0;
        // isTrue =false;
      }else{
        if(!st.contains('n/')){
          isTrue = false;
          print('case 3');
        }

      }

    }
  }

  return str;
}


String showText(String str){
  str = str.replaceAll('/n', '\n');
  return str;
}


String convertNumbers(String input) {
  //input = '۰';
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  const farsi2 = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll( farsi[i], english[i]);
    input = input.replaceAll( farsi2[i], english[i]);
  }
print("input is ${input}");
  return input;
}