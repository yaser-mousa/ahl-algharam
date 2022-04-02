
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/modules/all_articles_screen.dart';
import 'package:lovestories/modules/artical/artical.dart';
import 'package:lovestories/modules/choice_screen.dart';
import 'package:lovestories/modules/comments/comments_screen.dart';
import 'package:lovestories/modules/notification/cubit/cubit.dart';
import 'package:lovestories/modules/notification/notif_screen.dart';
import 'package:lovestories/shared/componanets/componanets.dart';
import 'package:lovestories/styles/themes.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class LoveLayout extends StatefulWidget {


  const LoveLayout({Key? key}) : super(key: key);

  @override
  State<LoveLayout> createState() => _LoveLayoutState();
}

class _LoveLayoutState extends State<LoveLayout> {
  LoveCubit? _loveCubit;
  NotifCubit? _notifCubit;
  BuildContext? _context;

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('===================== press on background ====================');
      Navigator.of(_context!).push(MaterialPageRoute(builder: (context){
          return LoveLayout();
        }));
     _loveCubit!.changeWidgetIndex(index: 2);
      _notifCubit!.changeGetNotif(false);
      _notifCubit!.getNotifications(_context);
    });




    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
        listener: (context, state){
        },
        builder: (context , state){
          _loveCubit = LoveCubit.get(context);

         _context = context;

           _notifCubit = NotifCubit.get(context);
          _notifCubit!.getNotifications(context);
          //notifCubit.testNotification();
          LoveCubit _cubit = LoveCubit.get(context);
          int width = MediaQuery.of(context).size.width.round();
          int height = MediaQuery.of(context).size.height.round();
          _cubit.setTextSizeDrive(MediaQuery.of(context).textScaleFactor);

          return Scaffold(

            bottomNavigationBar: BottomNavigationBar(
              onTap: (index){
                _cubit.changeWidgetIndex(index: index);
              },
              backgroundColor:Colors.black,
              selectedItemColor: Colors.pink,
              currentIndex: _cubit.widgetIndex,
              unselectedItemColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.article),label: 'أهل الغرام'),
                BottomNavigationBarItem(icon: Icon(Icons.people),label: 'قصص الأعضاء'),
                BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'الاشعارات'),
              ],
            ),
             drawer: drawerStories(context: context, cubit: _cubit),
             // backgroundColor: Colors.white70.withOpacity(0.8),
              appBar: appBarLife(title: _cubit.loveWidgetsTitles[_cubit.widgetIndex], context: context, cubit: _cubit),
              body: _cubit.loveWidgets[_cubit.widgetIndex],
          );
        },
       );
  }


}
AppBar appBarLife({ required String title,required BuildContext context, required LoveCubit cubit, bool backOn=false,Widget? evButton, double? elevation}){
  return AppBar(

    iconTheme: IconThemeData(color: Colors.black),
    title: Text(title,style: TextStyle(fontSize: cubit.setTextSize(23)),),

    elevation:elevation??0,

    toolbarHeight: 70,
    actions: [

      if(evButton!=null)
        evButton
    ],
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Color(0xffF7DCEC),
      statusBarIconBrightness: Brightness.dark
    ),
    flexibleSpace:  Container(
    color: loveAppColor,
    ),);
}




