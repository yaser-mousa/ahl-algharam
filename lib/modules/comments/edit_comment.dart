import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/modules/comments/cubit/cubit.dart';
import 'package:lovestories/modules/comments/cubit/states.dart';
import 'package:lovestories/shared/componanets/componanets.dart';

class EditComment extends StatefulWidget {
  String? storyUid;
  EditComment({Key? key,required this.storyUid}) : super(key: key);

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  final  _formKey = GlobalKey<FormState>();
   TextEditingController? _editCommentController ;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editCommentController = TextEditingController();

    print('in initial ///////////////////');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentCubit,CommentStates>(

         listener: (context, state){},
          builder: (context, state){
           CommentCubit _cubit = CommentCubit.get(context);
           return Scaffold(
            appBar: AppBar(),
             body: SingleChildScrollView(
               child: Column(
                 children: [
                   formField(cubit: _cubit, formKey: _formKey, storyUid: widget.storyUid! ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(onPressed: (){
                       print(_editCommentController?.text);
                       // if(_formKey.currentState!.validate()){
                       //   _editCommentController.text = _editCommentController.text!.trim();
                       //   if(_editCommentController.text.contains('  ')){
                       //     _editCommentController.text = _editCommentController.text.replaceAll('  ', ' ');
                       //   }
                       //
                       //   //cubit.createComment(txtComment:cubit.commentController.text , storyUid: storyUid);
                       // }
                     }, child: const Text('تعديل')),
                     const SizedBox(width: 20,),
                     ElevatedButton(onPressed: (){}, child: const Text('الغاء')),
                   ],
                 ),
                 ],
               ),
             ),
           );
          },);
  }

  Widget formField({required CommentCubit cubit, required String storyUid, required formKey}) {
    // String postId = posts[index].postId!;
    //
    // if (fromFrindScreen) {
    //   postId = cubit.frindPosts[index].postId!;
    // }
    return Form(
      key: _formKey,
      child: myTextFormField(

   onTapFun: (){
    //cubit.changeMaxLines(2);
    // print(cubit.maxLines);
    },
          labletext: 'write a comment...',

          iconColor: Colors.blue,
          maxLines: 5,

          controller: _editCommentController,
         type: TextInputType.multiline,

          fixicon: Icons.comment,
          onChange: (String? str) {
     print(str);

          },
          validatefun: (String? value) {
            value = value!.trim();
            if(value.contains('  ')){
              value = value.replaceAll('  ', '');
            }
            if(value.isEmpty ){
              return  'أدخل معلومات صحيحة';
            }
            return null;
          }),
    );
  }
}
