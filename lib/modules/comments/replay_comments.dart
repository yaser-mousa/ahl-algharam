import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovestories/models/replay_comments.dart';
import 'package:lovestories/modules/comments/cubit/cubit.dart';
import 'package:lovestories/shared/componanets/componanets.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReplayComments extends StatelessWidget {
  List<ReplayModel> replayComments = [];
 final  _replayEditController = TextEditingController();
 final _formEditKey = GlobalKey<FormState>();
 CommentCubit cubit ;
 int commentIndex =0;
 ReplayComments({Key? key, required this.replayComments, required this.cubit, required this.commentIndex}) : super(key: key);
  Future<void> _copyToClipboard(
      {required BuildContext context, required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('نسخ للحافظة'),
    ));
  }
  @override
  Widget build(BuildContext context) {
    double _height= MediaQuery.of(context).size.height;
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          print(' replayComments.length ============================== ${ replayComments.length}');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(replayComments[index].userImage),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      GestureDetector(
                        onLongPress: (){
                          cubit.replayIndex = index;
                          cubit.commentIndex = commentIndex;
                          print(cubit.commentIndex);
                          print(cubit.replayIndex);
                          print('hello');
                          showModel(height: _height, context: context, model: replayComments[index] ,cubit:cubit );
                        },
                        child: Container(
                          padding: EdgeInsetsDirectional.all(10),
                          decoration:
                              BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black12)
                              ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(replayComments[index].userName,   style: TextStyle(color: Colors.blueGrey, fontSize: cubit.setTextSize(18)),),
                              Text(replayComments[index].repComment, style: TextStyle(color: Colors.black, fontSize: cubit.setTextSize(18)),),
                            ],
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Container(child:Text( timeago.format(DateTime.parse(replayComments[index].time) ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 20,
          );
        },
        itemCount: replayComments.length);
  }

  void showModel(
      {required BuildContext context,
        required double height,
        required ReplayModel model,
        required CommentCubit cubit}) {
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
                    ///////////////////////////// Copy /////////////////////////////
                    ///////////////////////////// Copy /////////////////////////////
                    ///////////////////////////// Copy /////////////////////////////
                    GestureDetector(
                      onTap: () {
                        print('hjk');
                        _copyToClipboard(context: context, text:model.repComment );
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.copy),
                          SizedBox(width: 5,),
                          Container(
                          width: 70,child: Text('نسخ')),
                        ],
                      ),
                    ),
                    ///////////////////////////// edit edit /////////////////////////////
                    ///////////////////////////// edit edit /////////////////////////////
                    ///////////////////////////// edit edit /////////////////////////////
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {

                        //cubit.isReplay=false;
                        // cubit.updateComment(storyUid: model.storyUid, commentUid: model.commentId);
                        showEditCommentDialog(
                            text: model.repComment,
                            cubit: cubit,
                            model: model,
                            height: height,
                            context: context,
                            onPressed: () {

                              print('hello');
                              if (_formEditKey.currentState!.validate()) {
                                print(_replayEditController.text);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                model.repComment =  handleText(_replayEditController.text);
                                print(model.repComment);

                                cubit.updateReplayComment(repModel: model);
                                // cubit.updateComment(
                                //     comModel: model,
                                //     text: handleText(_replayEditController.text));

                              //  _replayEditController = TextEditingController();
                              }
                            });

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.edit),
                          SizedBox(width: 5,),
                          Container(
                             width: 70 ,child: Text('تعديل')),
                        ],
                      ),
                    ),
                    ///////////////////////////// delete /////////////////////////////
                    ///////////////////////////// delete /////////////////////////////
                    ///////////////////////////// delete /////////////////////////////
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // cubit.deleteComment(
                        //     storyUid: model.storyUid,
                        //     commentUid: model.commentId);
                        print(model.storyUid);
                        print(model.commentId);
                        print(model.replayUid);
                        cubit.deleteReplayComment(repModel: model);

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.delete_outline),
                          SizedBox(width: 5,),
                          Container(
                            width: 70  ,child: Text('حذف')),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
             ////////////////////////////////close button ///////////////////////////////
              closeButton(context)
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
        required ReplayModel model,
        required CommentCubit cubit,
        required var onPressed}) {

      _replayEditController.text = model.repComment;


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
                                maxLength: 300,
                                keyboardType: TextInputType.multiline,
                                controller: _replayEditController,
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

  Widget closeButton(BuildContext context){
    return  Positioned(
      right: 10,
      top: 10,
      child: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
