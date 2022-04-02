import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/models/notification.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/models/user_data.dart';
import 'package:lovestories/modules/comments/cubit/cubit.dart';
import 'package:lovestories/modules/notification/cubit/states.dart';
import 'package:http/http.dart' as http;

class NotifCubit extends Cubit<NotifState>{

  NotifCubit() : super(InitilaNotifState());

  static NotifCubit get(BuildContext context) => BlocProvider.of(context);
  bool _getNotif = false;
  LoveCubit? _loveCubit ;
  //BuildContext? _context;
  UserModel? _userData;

  void createCommentNotification({required StoryModel storyModel, required BuildContext context})async{
   // print('hello 1 //////////////////////');
    _loveCubit = LoveCubit.get(context);
    _userData = _loveCubit!.userData;
   // print('hello 2///////////////////////');

    if(storyModel.userUid !=  _userData!.userUid){
      const String serverToken = 'AAAA-PyCP28:APA91bHK2j000KXFkuqLdh9ggAaGv5ytJeXJq63qIvt-oJjTpYtPhE1IbjBYRg7DInuEk2xw8BKTWKt515Dds2yPZQ9fTk0lFg1NLiv7CQ6zRJBrdyvwCA1RjJVEbWxWJ53TKFaFHKUo';

      var samsung = 'eP6q39B_TDi1IkHSE-BrbC:APA91bG7sxzikub8tJe4rduURMo715OT11cGL56RIYjRKR-58OvuCS78CFY-CLBEjqULm_z20L4O7iq1SUrOCmpPFo7pxE1akMo3LKPJh0d0lBhFyhoPQc4jse7jbxDls6cLVkN3T25M';
      var redmi = 'd93ZZYSjSM23SgWH86UFn1:APA91bFiewK3aj-07iI4R1BmSbS7cpmykt2dz4qtpQP2ZHQbpplOHfK1wbJP-XyRVd-kUUVtkX2HL0qkFhlXks5E-fW2DOQgSs_uIsFNwyCTi3RiLETdCxaFIDLi0kDrgyQ6HsD6cEch';
      int collection = _loveCubit!.widgetIndex;
      print('hello');
      print(collection);
      print(_userData!.name);
      print(_userData!.userUid);
      print('token');
      print(storyModel.token);

      print('hello  2');
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'علق ${_userData!.name} على قصتك ',
              'title': 'أهل الغرام',
              "sound" : "alert.wav",
              "android_channel_id": "high_importance_channel"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'senderId': _userData!.userUid,
              'collection': collection,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',

            },
            'to': storyModel.token,
          },
        ),
      );




      NotifModel notifModel = NotifModel(
          collection: collection,
          storyId: storyModel.storyUid,
          title: 'أهل الغرام',
          body:'علق ${_userData!.name} على قصتك ' ,
          senderId: _userData!.userUid,
          senderName: _userData!.name,
          senderPic: _userData!.picImage,
          token:storyModel.token,
          receivedName: storyModel.userName,
          receivedId: storyModel.userUid,
          time: DateTime.now().toString());

      FirebaseFirestore.instance
          .collection('users')
          .doc(storyModel.userUid)
          .collection('messages')
          .add(notifModel.toMap())
          .then((value) {
        emit(CreateNotificationSuccess ());
      })
          .catchError((onError){
        emit( CreateNotificationError());
      });
    }


  }


  void changeGetNotif(bool notif){

      _getNotif = notif;

  }

  void createReplayCommentNotification({required StoryModel storyModel, required BuildContext context, required int index})async{


    print('hello 1');
        _loveCubit = LoveCubit.get(context);
        _userData = _loveCubit!.userData;

        CommentCubit commentCubit = CommentCubit.get(context);
       print('index === ${index}');
       print(commentCubit.replayMap[index]!.first.repComment);
        for(int x =0; x <commentCubit.replayMap[index]!.length; x++){
          print('hello 2');
          const String serverToken = 'AAAA-PyCP28:APA91bHK2j000KXFkuqLdh9ggAaGv5ytJeXJq63qIvt-oJjTpYtPhE1IbjBYRg7DInuEk2xw8BKTWKt515Dds2yPZQ9fTk0lFg1NLiv7CQ6zRJBrdyvwCA1RjJVEbWxWJ53TKFaFHKUo';


          int collection = _loveCubit!.widgetIndex;

          await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: jsonEncode(
              <String, dynamic>{
                'notification': <String, dynamic>{
                  'body': 'علق ${_userData!.name} على قصتك ',
                  'title': 'أهل الغرام'
                },
                'priority': 'high',
                'data': <String, dynamic>{
                  'senderId': _userData!.userUid,
                  'collection': collection,
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done',

                },
                'to': commentCubit.replayMap[index]![x].token,
              },
            ),
          );

          NotifModel notifModel = NotifModel(
              collection: collection,
              storyId: storyModel.storyUid,
              title: 'أهل الغرام',
              body:'علق ${_userData!.name} على قصتك ' ,
              senderId: _userData!.userUid,
              senderName: _userData!.name,
              senderPic: _userData!.picImage,
              token: commentCubit.replayMap[index]![x].token,
              receivedName: commentCubit.replayMap[index]![x].userName,
              receivedId: commentCubit.replayMap[index]![x].userUid,
              time: DateTime.now().toString());

          FirebaseFirestore.instance
              .collection('users')
              .doc(commentCubit.replayMap[index]![x].userUid)
              .collection('messages')
              .add(notifModel.toMap())
              .then((value) {
            emit(CreateNotificationSuccess ());
          })
              .catchError((onError){
            emit( CreateNotificationError());
          });
        }
        //

  }


  List<NotifModel> notifList = [];
  void getNotifications(context){

   try{

     getUserId();
     if(_userId !=null && !_getNotif){
       //print(_userId);
       print(_userId);
       notifList = [];
       changeGetNotif(true);
       FirebaseFirestore.instance
           .collection('users')
           .doc(_userId)
           .collection('messages')
           .orderBy('time', descending: true)
           .get()
           .then((value) {
           value.docs.forEach((element) {

             notifList.add(NotifModel.fromJson(element.data()));
             notifList.last.notifId = element.id;
           });
           notifList.forEach((element) {
             print('Notification ${element.notifId}');
           });

             emit( GetNotificationSuccess());
       }).catchError((onError){
        print(onError);
        emit( GetNotificationError());
       });
     }else{
       print('user id is null or getNotif Variable = true ');
       print(_userId );
     }
   }
   catch(onError){
     print(onError);
   }
  }


   void changeReadableNotification({required NotifModel notifModel}){
  try{
    FirebaseFirestore.instance
        .collection('users')
        .doc(notifModel.receivedId)
        .collection('messages')
        .doc(notifModel.notifId)
        .update({'readable' : true})
        .then((value) {
         int index = notifList.indexOf(notifModel);
         notifList[index].readable = true;
      emit( ChangeReadableNotificationSuccess());
    })
        .catchError((onError){
      emit( ChangeReadableNotificationError());
    });
  }
  catch(onError){

  }

   }

  String? _userId;
  dynamic getUserId(){
    if(FirebaseAuth.instance.currentUser != null){
      try{
        print('firebase token =================== ${FirebaseAuth.instance.currentUser!.uid}');
        _userId = FirebaseAuth.instance.currentUser!.uid;
        return _userId;
      }
      catch(onError){
        print('Error ////// from Main in 61 Line FirebaseAuth.instance.currentUser : ${onError}');
        return null;
      }

    }
  }


}