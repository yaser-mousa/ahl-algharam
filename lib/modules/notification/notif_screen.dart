import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/models/notification.dart';
import 'package:lovestories/modules/comments/comments_screen.dart';
import 'package:lovestories/modules/notification/cubit/states.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'cubit/cubit.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotifCubit, NotifState>
      ( listener: (con, st){},
      builder: (con, st){
        LoveCubit _loveCubit = LoveCubit.get(context);
        NotifCubit _notifCubit = NotifCubit.get(context);


         return  Conditional.single(
              context: context,
              conditionBuilder: (context) => _notifCubit.notifList.length>0,
              widgetBuilder: (context ){
                return notificationsListView(loveCubit: _loveCubit, notifList: _notifCubit.notifList, notifCubit: _notifCubit);
              },
              fallbackBuilder: (context){
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('لا يوجد اشعارات حتى الآن..'),
                );
              });

      },
    );
  }

  Widget notificationsListView({required LoveCubit loveCubit, required List<NotifModel> notifList, required NotifCubit notifCubit}){
    return ListView.separated(
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              print('press');
               print(notifList.length);
              loveCubit.getStory(context:context, notifModel: notifList[index]);
              notifCubit.changeReadableNotification(notifModel: notifList[index]);
               // loveCubit.changeWidgetIndex(index: notifList[index].collection);


              },
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: notifList[index].readable? Color(0xffF7DCEC): Colors.grey.shade200,
                child: ListTile(
                  leading: CircleAvatar(
                  backgroundImage: NetworkImage( notifList[index].senderPic),
                 radius: 20,
                  ),

                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notifList[index].body),
                      Text(  timeago.format(DateTime.parse( notifList[index].time ), locale: 'en_short'))
                    ],
                  ),

                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index){
       return Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
          height: 1,
           color: Colors.pink.shade200,
         ),
       );
        },
        itemCount: notifList.length);
  }


}
