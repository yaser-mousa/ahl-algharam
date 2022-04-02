


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';

class UserScreen extends StatelessWidget {

  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(

         listener: (context, state){
           if(state is UnblockUserFromIdSuccess){
             AwesomeDialog(context: context, title: 'Unblock Success').show();
           }
           if(state is BlockUserFromIdSuccess){
             AwesomeDialog(context: context, title: 'Block Success').show();
           }

         },
        builder: (context, state){
           LoveCubit _loveCubit = LoveCubit.get(context);
           return Scaffold(
             appBar: AppBar(),
             body: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(children: [
                     CircleAvatar(
                       radius: 20,
                       backgroundImage: NetworkImage(_loveCubit.userInformation.picImage),
                     ),
                     const SizedBox(width: 20,),
                     Text(_loveCubit.userInformation.name),
                   ],),
                 ),
                 const SizedBox(height: 20,),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(_loveCubit.userInformation.userUid),
                 ),

                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(_loveCubit.userInformation.phoneNumber),
                 ),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(onPressed: (){
                       _loveCubit.blockUserFromId(userId: _loveCubit.userInformation.userUid, context: context);
                     }, child: const Text('Block')),
                     const SizedBox(width: 10,),
                     ElevatedButton(onPressed: (){
                       _loveCubit.unblockUserFromId(userId: _loveCubit.userInformation.userUid, context:context );
                      // AwesomeDialog(context: context, title: 'Unblock');

                     }, child: const Text('Unblock')),
                   ],
                 ),



               ],
             ),
           );

        }
         );
  }
}
