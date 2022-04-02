import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/models/comment_model.dart';
import 'package:lovestories/models/notification.dart';
import 'package:lovestories/models/replay_comments.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/modules/comments/cubit/states.dart';
import 'package:lovestories/shared/componanets/componanets.dart';
import 'package:http/http.dart' as http;

class CommentCubit extends Cubit<CommentStates> {
  LoveCubit? loveCubit;

  CommentCubit({this.loveCubit}) : super(InitialCommentState());

  static CommentCubit get(context) => BlocProvider.of(context);

  List<CommentModel> commentList = [];
  TextEditingController _commentController = TextEditingController();
  List<bool> _isExpanded = [];

  List<bool> get isExpanded => _isExpanded;

  void setIsExpanded(bool value, int index) {
    _isExpanded[index] = value;
    emit(ChangeIsExpanded());
  }

  TextEditingController get commentController => _commentController;
 var _lastCooment;
  void getAllComments({required String storyUid, NotifModel? notifModel}) {
    try {
      _isExpanded = [];
      getCommentAllow = true;
      print('I in getAllComments');
      String _collection = 'yaserSto';

      if (loveCubit?.widgetIndex == 1) {
        _collection = 'usersSto';
      }

      if(notifModel!=null){
        if(notifModel.collection ==1){
          _collection = 'usersSto';
        }
      }
      print('I in getAllComments');
      commentList = [];
      print(loveCubit?.widgetIndex);
      FirebaseFirestore.instance
          .collection(_collection)
          .doc(storyUid)
          .collection('comments')
          .orderBy('time', descending: true)
          .limit(15)
          .get()
          .then((value) {
        _lastCooment = value.docs.last;
        print( _lastCooment.data());
        _handleGetCommentsWithReplays(value: value, index: 0);
      }).catchError((onError) {
        print(onError);
        emit(GetAllCommentsError());
      });
    } catch (onError) {
      print(onError);
      emit(GetAllCommentsError());
    }
  }
bool getCommentAllow = true;
  void getCommentsLimit({required String storyUid, NotifModel? notifModel}){
    try {
      if(getCommentAllow){
        emit(LoadingGetCommentsLimit());
        getCommentAllow = false;
        print('I in getAllComments');
        print(_lastCooment.data());
        String _collection = 'yaserSto';

        if (loveCubit?.widgetIndex == 1) {
          _collection = 'usersSto';
        }

        if(notifModel!=null){
          if(notifModel.collection ==1){
            _collection = 'usersSto';
          }
        }
        print('I in getAllComments');
        // commentList = [];
        print(loveCubit?.widgetIndex);
        FirebaseFirestore.instance
            .collection(_collection)
            .doc(storyUid)
            .collection('comments')
            .orderBy('time', descending: true)
            .limit(10)
            .startAfterDocument(_lastCooment)
            .get()
            .then((value) {
              getCommentAllow = true;
          value.docs.forEach((element) {
            print(element.data());
          });
          _lastCooment = value.docs.last;
          print(_lastCooment.data);
          _handleGetCommentsWithReplays(value: value, index: 0);
        }).catchError((onError) {
          print(onError);
         if(onError.toString()=='Bad state: No element'){
           getCommentAllow = false;
         }
          emit(GetAllCommentsError());
        });
      }

    } catch (onError) {
      print('the error is $onError');
      emit(GetAllCommentsError());
    }
  }

  Map<int, List<ReplayModel>> replayMap = {};

  void _handleGetCommentsWithReplays(
      {required int index,
      required QuerySnapshot<Map<String, dynamic>> value}) {
    var mainValue = value;
    commentList.add(CommentModel.fomJson(value.docs[index].data()));
    commentList.last.comment = showText(commentList.last.comment);
    if (commentList.last.comment.length > 50) {
      isExpanded.add(true);
    } else {
      isExpanded.add(false);
    }
    commentList.last.commentId = value.docs[index].id;

    print('print 1 =======${commentList.last.commentId}');

    int replayindex = 0;
    if( replayMap.length>0){
      replayindex =  replayMap.length;
    }
    replayMap[replayindex ] = [];
    print( 'replayMap.length ===== ${replayMap.length}');
    value.docs[index].reference
        .collection('replay')
        .orderBy('time', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {

    print ('141 true;');
    print(value.docs.first.id);

        replayMap[replayindex ]!.add(ReplayModel.fomJson(element.data()));
        replayMap[replayindex ]!.last.replayUid = element.id;

       if(replayMap[replayindex ]!.length >1){
         replayMap[replayindex ]!.first.expandedRep = true;
       }
        emit(GetAllCommentsSuccess());
      });
      index++;
      if (index < mainValue.docs.length) {
        _handleGetCommentsWithReplays(value: mainValue, index: index);
      } else {
        emit(GetAllCommentsSuccess());
      //  print('print 2 ====== ${replayMap[0]?.first.commentId}');
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void createComment({required String txtComment, required String storyUid}) {
    try {
      String _collection = 'yaserSto';
      if (loveCubit?.widgetIndex == 1) {
        _collection = 'usersSto';
      }
      CommentModel? _commentModel = CommentModel.setValues(
        token: loveCubit!.userData.token,
          storyUid: storyUid,
          comment: txtComment,
          userUid: loveCubit!.userData.userUid,
          image: loveCubit!.userData.picImage,
          name: loveCubit!.userData.name,
          time: DateTime.now().toString());
      FirebaseFirestore.instance
          .collection(_collection)
          .doc(storyUid)
          .collection('comments')
          .add(_commentModel.toMap())
          .then((value) {
        print(value.id);
        getAllComments(storyUid: storyUid);
        changeMaxLines(1);
        _commentController = TextEditingController();
        // FocusScope.of(context).unfocus();
        emit(CreateCommentSuccess());
      }).catchError((onError) {
        print(onError);
        emit(CreateCommentError());
      });
    } catch (onError) {
      emit(CreateCommentError());
      print(onError);
    }
  }
  double setTextSize(double size){
   return  loveCubit!.setTextSize(size);
  }
  void createReplayCommentNotification({required StoryModel storyModel, required BuildContext context, required int index})async{


    print('hello 1 ////////////////// ');
   // _loveCubit = LoveCubit.get(context);


    CommentCubit commentCubit = CommentCubit.get(context);
    print('index === ${index}');
    print(replayMap[index]!.first.repComment);
    print(replayMap[index]!.length);

    List<ReplayModel> replayMapTwo = [];
    List<String> usersId =[];
    replayMap[index]!.forEach((element) {
      print('hello 2 ////////////////// ');
      print(element.userUid);
      if(!usersId.contains(element.userUid)  && loveCubit!.userData.userUid !=  element.userUid && storyModel.userUid != element.userUid){
        print('hello 3 ////////////////// ');
        usersId.add(element.userUid);
        replayMapTwo.add(element);
      }
    });

    print('replayMapTwo.length === ===== ===== ${replayMapTwo.length}');
    print(replayMapTwo.first.userUid);
   replayMapTwo.forEach((element)async {

     print('hello 2');
     const String serverToken = 'AAAA-PyCP28:APA91bHK2j000KXFkuqLdh9ggAaGv5ytJeXJq63qIvt-oJjTpYtPhE1IbjBYRg7DInuEk2xw8BKTWKt515Dds2yPZQ9fTk0lFg1NLiv7CQ6zRJBrdyvwCA1RjJVEbWxWJ53TKFaFHKUo';


     int collection = loveCubit!.widgetIndex;
     print('hello 3');
     print(element.token);
     print(loveCubit!.userData.name);
     print(loveCubit!.userData.userUid);

     await http.post(
       Uri.parse('https://fcm.googleapis.com/fcm/send'),
       headers: <String, String>{
         'Content-Type': 'application/json',
         'Authorization': 'key=$serverToken',
       },
       body: jsonEncode(
         <String, dynamic>{
           'notification': <String, dynamic>{
             'body': 'رد ${loveCubit!.userData.name} على تعليق ',
             'title': 'أهل الغرام',
             "sound" : "alert.WAV",
             "android_channel_id": "high_importance_channel"
           },
           'priority': 'high',
           'data': <String, dynamic>{
             'senderId': loveCubit!.userData.userUid,
             'collection': collection,
             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
             'id': '1',
             'status': 'done',

           },
           'to': element.token,
         },
       ),
     );

     print('hello 4');

     NotifModel notifModel = NotifModel(
         collection: collection,
         storyId: storyModel.storyUid,
         title: 'أهل الغرام',
         body:'رد ${loveCubit!.userData.name} على تعليق ' ,
         senderId: loveCubit!.userData.userUid,
         senderName: loveCubit!.userData.name,
         senderPic: loveCubit!.userData.picImage,
         token: element.token,
         receivedName: element.userName,
         receivedId: element.userUid,
         time: DateTime.now().toString());
     print('hello 5');
     FirebaseFirestore.instance
         .collection('users')
         .doc(element.userUid)
         .collection('messages')
         .add(notifModel.toMap())
         .then((value) {
       // emit(CreateNotificationSuccess ());
     })
         .catchError((onError){
       // emit( CreateNotificationError());
     });

   });


  }

  void updateComment({required CommentModel comModel, required String text}) {
    try {
      String _collection = 'yaserSto';
      if (loveCubit?.widgetIndex == 1) {
        _collection = 'usersSto';
      }

      CommentModel model = CommentModel.setValues(
        token: loveCubit!.userData.token,
          storyUid: comModel.storyUid,
          comment: text,
          userUid: loveCubit?.userData.userUid,
          image: loveCubit!.userData.picImage,
          name: loveCubit!.userData.name,
          time: comModel.time);

      FirebaseFirestore.instance
          .collection(_collection)
          .doc(comModel.storyUid)
          .collection('comments')
          .doc(comModel.commentId)
          .update(model.toMap())
          .then((value) {
        getAllComments(storyUid: comModel.storyUid);
        //emit(CommentUpdateSuccess());
      }).catchError((onError) {
        print(onError);
        emit(CommentUpdateError());
      });
    } catch (onError) {
      emit(CommentUpdateError());
      print(onError);
    }
  }

  void deleteComment({required String storyUid, required String commentUid}) {
    try {
      String _collection = 'yaserSto';
      if (loveCubit?.widgetIndex == 1) {
        _collection = 'usersSto';
      }
      FirebaseFirestore.instance
          .collection(_collection)
          .doc(storyUid)
          .collection('comments')
          .doc(commentUid)
          .delete()
          .then((value) {
        emit(CommentDeleteSuccess());
        getAllComments(storyUid: storyUid);
      }).catchError((onError) {
        print(onError);
        emit(CommentDeleteError());
      });
    } catch (onError) {
      emit(CommentDeleteError());
      print(onError);
    }
  }

  int _maxLines = 1;

  get maxLines => _maxLines;

  void changeMaxLines(int max) {
    print(max);
    _maxLines = max;
    emit(ChangeNaxLines());
  }

  ////////////////////////////////////// replay comment //////////////////////

  bool _isReplay = false;
  int _commentIndex= 0;
  int _replayIndex=0;

  int get commentIndex => _commentIndex;

  set commentIndex(int value) {
    _commentIndex = value;
    emit(ChangeCommentIndex());
  }

  bool get isReplay => _isReplay;

  set isReplay(bool value) {
    _isReplay = value;
    emit(ChangeIsReplayState());
  }

  void createReplayComment(
      {required String txtComment,
      required String storyUid,
      required String commentId,
      required CommentModel model
      }) {
    try {
      String _collection = 'yaserSto';
      if (loveCubit?.widgetIndex == 1) {
        _collection = 'usersSto';
      }
      print('commentId ======= ${commentId}');

      ReplayModel? _replayModel = ReplayModel.setValues(
        token: loveCubit!.userData.token,
          commentId: commentId,
          storyUid: storyUid,
          repComment: txtComment,
          userUid: loveCubit!.userData.userUid,
          image: loveCubit!.userData.picImage,
          name: loveCubit!.userData.name,
          time: DateTime.now().toString());
      FirebaseFirestore.instance
          .collection(_collection)
          .doc(storyUid)
          .collection('comments')
          .doc(commentId)
          .collection('replay')
          .add(_replayModel.toMap())
          .then((value) {
        print(value.id);

        int index = commentList.indexOf(model);
        if(replayMap[index] == null){
          replayMap[index] = [];
          replayMap[index]!.add(ReplayModel.fomJson(_replayModel.toMap()));
          replayMap[index]!.first.replayUid = value.id;
        }else{
          var fastMap = replayMap[index];
          replayMap[index] = [];
          replayMap[index]!.add(ReplayModel.fomJson(_replayModel.toMap()));
          replayMap[index]!.first.replayUid = value.id;
          fastMap!.forEach((element) {
            replayMap[index]!.add(element);

           });
         // replayMap[index]!.first.expandedRep =true;
          print( replayMap[index]!.length);
        }
        _commentController = TextEditingController();

        emit(CreateReplaySuccess());
      }).catchError((onError) {
        print(onError);
        emit(CreateReplayError());
      });
    } catch (onError) {
      print(onError);
    }
  }

  void changeExpandedState({required int index }){
    replayMap[index]!.first.expandedRep = !replayMap[index]!.first.expandedRep;
    emit(ChangeReplaysExpandedState());
  }
  
  void deleteReplayComment({required ReplayModel repModel}){
    try{
      String collection = 'yaserSto';
      if(loveCubit!.widgetIndex ==1){
        collection = 'usersSto';
      }
      print(replayMap[commentIndex]![0].repComment);
      FirebaseFirestore.instance
      .collection(collection)
           .doc(repModel.storyUid)
          .collection('comments')
          .doc(repModel.commentId)
          .collection('replay')
          .doc(repModel.replayUid)
      .delete().then((value) {

        replayMap[commentIndex]!.removeAt(replayIndex);
        emit(DeleteReplayCommentSuccess());
      })
      .catchError((onError){
        print(onError);
        emit(DeleteReplayCommentError());
      });
          
    }
    catch(onError){
      print(onError);
    }
  }

  void updateReplayComment({required ReplayModel repModel}){
    try{
      String collection = 'yaserSto';
      if(loveCubit!.widgetIndex ==1){
        collection = 'usersSto';
      }
      FirebaseFirestore.instance
          .collection(collection)
          .doc(repModel.storyUid)
          .collection('comments')
          .doc(repModel.commentId)
          .collection('replay')
          .doc(repModel.replayUid)
          .update(repModel.toMap())
          .then((value) {
        replayMap[commentIndex]![replayIndex] = repModel;
            emit(UpdateReplayCommentSuccess());
          })
          .catchError((onError){});
    }
    catch(onError){
      print(onError);
      emit(UpdateReplayCommentError());
    }
  }

  int get replayIndex => _replayIndex;

  set replayIndex(int value) {
    _replayIndex = value;
    emit(ChangeReplayIndex());
  }
}
