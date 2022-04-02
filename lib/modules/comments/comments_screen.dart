import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/models/comment_model.dart';
import 'package:lovestories/models/notification.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/modules/comments/cubit/cubit.dart';
import 'package:lovestories/modules/comments/cubit/states.dart';
import 'package:lovestories/modules/comments/edit_comment.dart';
import 'package:lovestories/modules/comments/replay_comments.dart';
import 'package:lovestories/modules/notification/cubit/cubit.dart';
import 'package:lovestories/shared/componanets/componanets.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreenLove extends StatelessWidget {
  CommentScreenLove({Key? key, required this.storyModel, this.notifModel}) : super(key: key);
  TextEditingController _comeentEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formEditKey = GlobalKey<FormState>();
  StoryModel? storyModel;
  NotifModel? notifModel;
  var _scrollController = ScrollController();
  Future<void> _copyToClipboard(
      {required BuildContext context, required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('نسخ للحافظة'),
    ));
  }

  @override
  Widget build(BuildContext context) {

    LoveCubit _loveCubit = LoveCubit.get(context);
    return BlocProvider(
      create: (context) {
        return CommentCubit(loveCubit: _loveCubit)
          ..getAllComments(storyUid:storyModel!.storyUid ,notifModel: notifModel);
      },
      child: BlocConsumer<CommentCubit, CommentStates>(
        listener: (con, st) {},
        builder: (con, st) {
          CommentCubit _cubit = CommentCubit.get(con);
          NotifCubit _notifCubit = NotifCubit.get(context);
          print('build after BlocProvide');
          //
          _scrollController.addListener(() {
            if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
              _cubit.getCommentsLimit(storyUid:  _cubit.commentList.last.storyUid);
            }
          });
          return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: (){
              //     _cubit.getCommentsLimit(storyUid:  _cubit.commentList.last.storyUid);
              //   },
              //
              // ),
              appBar: appBarLife(
                  title: 'التعليقات', context: context, cubit: _loveCubit),
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) => _cubit.commentList.isNotEmpty,

                widgetBuilder: (context) {
                  var model = _cubit.commentList;
                  double hie = MediaQuery.of(context).size.height;
                  //var likeComment = cubit.commentsLikes;
                  return SingleChildScrollView(
                    child: Container(
                      height: hie - 100,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                                shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return commentsfunc(
                                    state: st,
                                    loveCubit: _loveCubit,
                                    notifCubit: _notifCubit,
                                      index: index,
                                      model: model[index],
                                      context: context,
                                      hie: hie,
                                      cubit: _cubit,
                                    storyModel : storyModel!
                                  );
                                },
                                itemCount: _cubit.commentList.length),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: myFormField(
                              context: context,
                              notifCubit:_notifCubit,
                                cubit: _cubit,
                                storyModel: storyModel!,
                               ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                fallbackBuilder: (context) {
                  return fallbackBuilderWidget(cubit: _cubit, context: context, notifCubit: _notifCubit);
                },
              ));
        },
      ),
    );
  }

  Widget commentsfunc(
      {required CommentModel model,
      required BuildContext context,
      required CommentCubit cubit,
      required double hie,
      required int index,
      required NotifCubit notifCubit,
      required LoveCubit loveCubit,
      required var state ,
      required StoryModel storyModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 5),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage("${model.userImage}"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () {

                        print(model.comment);
                        showModel(
                          loveCubit:loveCubit ,
                          storyModel: storyModel,
                          notifCubit: notifCubit,
                            context: context,
                            height: hie,
                            model: model,
                            cubit: cubit);
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${model.userName}', style: TextStyle(fontSize:  cubit.setTextSize(18), color: Colors.pink),),
                            const SizedBox(
                              height: 10,
                            ),
                            //Text('${model.comment} '),
                            AnimatedSize(
                                duration: const Duration(milliseconds: 500),
                                child: ConstrainedBox(
                                    constraints: !cubit.isExpanded[index]
                                        ? BoxConstraints()
                                        : BoxConstraints(maxHeight: 100.0),
                                    child: Text(
                                      model.comment,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(fontSize:  cubit.setTextSize(18)),
                                    ))),
                            !cubit.isExpanded[index]
                                ? ConstrainedBox(
                                    constraints: new BoxConstraints())
                                : TextButton(
                                    child: Text('... المزيد'),
                                    onPressed: () =>
                                        cubit.setIsExpanded(false, index)),
                          ],
                        ),
                      ),
                    ),
                    if (model.time != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeago.format(DateTime.parse(model.time),
                                locale: 'en_short'),
                            style: TextStyle(color: Colors.grey.shade800, fontSize:  cubit.setTextSize(20)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        TextButton(onPressed: (){
                          _comeentEdit = TextEditingController();

                          cubit.isReplay = true;
                          showEditCommentDialog(

                              context: context,
                              cubit: cubit,
                              model: model,
                              height: 100,
                              text: '',
                              onPressed: () {
                                //print('hello 1');
                                if(_formEditKey.currentState!.validate()){
                                  // print('hello 2');
                                  // notifCubit.createCommentNotification(storyModel: storyModel, context: context);
                                  cubit.createReplayComment(model: model,txtComment: handleText(_comeentEdit.text), storyUid: model.storyUid, commentId: model.commentId);
                                  int index = cubit.commentList.indexOf(model);
                                  notifCubit.createCommentNotification(storyModel: storyModel, context: context);
                                  cubit.createReplayCommentNotification(storyModel: storyModel, context: context, index: index);
                                  _comeentEdit = TextEditingController();
                                  Navigator.of(context).pop();

                                }

                              });

                        }, child: const Text('رد'))
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          if(cubit.replayMap[index]!.length>0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
              duration: const Duration(milliseconds: 500),
                child: ConstrainedBox(
                  constraints:
                  !cubit.replayMap[index]!.first.expandedRep?
                     BoxConstraints() : BoxConstraints(maxHeight: 100.0),
                  child: ReplayComments(replayComments: cubit.replayMap[index]!,cubit: cubit,commentIndex: index,),
                ),
              ),
              !cubit.replayMap[index]!.first.expandedRep?
              ConstrainedBox(
                  constraints: new BoxConstraints())
                  : TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('رؤية${cubit.replayMap[index]!.length -1} تعليقات أخرى ....'),
                  ),
                  onPressed: () {
                cubit.changeExpandedState(index: index);
                  })
            ],
          ),

          if(index ==cubit.replayMap.length -1 && state is LoadingGetCommentsLimit)
            CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget myFormField(

      {
      required NotifCubit notifCubit,
      required CommentCubit cubit,
      required StoryModel storyModel,
        required BuildContext context
      }) {
    // String postId = posts[index].postId!;
    //
    // if (fromFrindScreen) {
    //   postId = cubit.frindPosts[index].postId!;
    // }
    final _formKey = GlobalKey<FormState>();
    return
      Form(
      key: _formKey,
      child:
      myTextFormField(
          type: TextInputType.multiline,
          sufixPressed: () {

            if (_formKey.currentState!.validate()) {
              print('validate');
              notifCubit.createCommentNotification(storyModel: storyModel, context: context);
              cubit.createComment(
                  txtComment: handleText(cubit.commentController.text),
                  storyUid:storyModel.storyUid);


            }
          },
          labletext: 'write a comment...',
          sufix: Icons.send,
          iconColor: Colors.blue,
          maxLines: 5,
          controller: cubit.commentController,

          // type: TextInputType.text,
          fixicon: Icons.comment,
          onChange: (String? str) {},
          validatefun: (String? value) {
            value = value!.trim();
            if (value.contains('  ')) {
              value = value.replaceAll('  ', '');
            }
            print(value.length);
            if (value.isEmpty) {
              return 'أدخل معلومات صحيحة';
            }
            return null;
          }),
    );
  }

  void showModel(
      {required BuildContext context,
      required double height,
      required CommentModel model,
      required CommentCubit cubit,
      required NotifCubit notifCubit,
      required StoryModel storyModel,
      required LoveCubit loveCubit
      }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height / 2,
          //color: Colors.amber,
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _copyToClipboard(context: context, text:  model.comment);
                        print('hjk');
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(Icons.copy),
                            SizedBox(width: 7,),
                            Container(
                                width: 70,
                               // color: Colors.blue,
                                child: Text('نسخ')),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                  //  if(checkUserUid(model.userUid, loveCubit))
                    GestureDetector(
                      onTap: () {

                        cubit.isReplay=false;
                        // cubit.updateComment(storyUid: model.storyUid, commentUid: model.commentId);
                        showEditCommentDialog(
                            text: model.comment,
                            cubit: cubit,
                            model: model,
                            height: height,
                            context: context,
                            onPressed: () {
                              Navigator.pop(context);
                              print('hello');
                              if (_formEditKey.currentState!.validate()) {
                                print(_comeentEdit.text);

                                cubit.updateComment(
                                    comModel: model,
                                    text: handleText(_comeentEdit.text));

                                _comeentEdit = TextEditingController();
                              }
                            });
                        // cubit.changeMaxLines(1);
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        //   return EditComment(storyUid: storyUid,);
                        // }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 7,),
                          Container(
                              width: 70
                              ,child: Text('تعديل')),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                   // if(checkUserUid(model.userUid, loveCubit))
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        cubit.deleteComment(
                            storyUid: model.storyUid,
                            commentUid: model.commentId);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.delete_outline),
                          SizedBox(width: 7,),
                          Container(
                          width: 70
                          ,child: Text('حذف')),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {
                        _comeentEdit = TextEditingController();

                        cubit.isReplay = true;
                        showEditCommentDialog(

                            context: context,
                            cubit: cubit,
                            model: model,
                            height: height,
                            text: '',
                            onPressed: () {
                              //print('hello 1');
                              if(_formEditKey.currentState!.validate()){
                               // print('hello 2');
                               // notifCubit.createCommentNotification(storyModel: storyModel, context: context);
                                cubit.createReplayComment(model: model,txtComment: handleText(_comeentEdit.text), storyUid: model.storyUid, commentId: model.commentId);
                                int index = cubit.commentList.indexOf(model);
                                notifCubit.createCommentNotification(storyModel: storyModel, context: context);
                                cubit.createReplayCommentNotification(storyModel: storyModel, context: context, index: index);
                                _comeentEdit = TextEditingController();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }

                            });

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment),
                          SizedBox(width: 7,),
                          Container(
                              width: 70
                              ,child: Text('رد')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showEditCommentDialog(
      {required String text,
      required BuildContext context,
      required double height,
      required CommentModel model,
      required CommentCubit cubit,
      required var onPressed}) {
    if (!cubit.isReplay) {
      _comeentEdit.text = model.comment;
    }

    int numbers = 0;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            child: AlertDialog(
              content: Container(
                height: 200,
                width: double.infinity,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      key: _formEditKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: TextFormField(
                                maxLines: 5,
                                minLines: 1,
                                maxLength: 3000,
                                keyboardType: TextInputType.multiline,
                                controller: _comeentEdit,
                                validator: (value) {
                                  value = value!.trim();
                                  if (value.contains('  ')) {
                                    value = value.replaceAll('  ', ' ');
                                  }
                                  if (value.isEmpty) {
                                    return 'أدخل بيانات صحيحة';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: ElevatedButton(
                              child: const Text("تم"),
                              onPressed: onPressed,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }


  Widget  fallbackBuilderWidget({required BuildContext context,required CommentCubit cubit , required NotifCubit notifCubit}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('لا يوجد تعليقات حتى الآن',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: cubit.setTextSize(22)) , textAlign: TextAlign.center,),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'كن أول من يضع بصمته',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize:  cubit.setTextSize(16)),
                    ),
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: myFormField(
            context: context,
            notifCubit: notifCubit,
            cubit: cubit,
            storyModel: storyModel!,
          ),
        ),
      ],
    );
  }
  bool checkUserUid(String  userUid, LoveCubit loveCubit) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == userUid || loveCubit.yasAdmin) {
        return true;
      }
      return false;
    } catch (onError) {
      print(onError);
      return false;
    }
  }
}
