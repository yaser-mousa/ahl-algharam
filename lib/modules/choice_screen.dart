import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/modules/create_stroy.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state){},
      builder: (context, state){
        int width = MediaQuery.of(context).size.width.round();
        int height = MediaQuery.of(context).size.height.round();
        print('width is : ${width}');
        LoveCubit cubit = LoveCubit.get(context);

        return  WillPopScope(
          onWillPop:  () async {
          print("After clicking the Android Back Button");
          return true;
        },
          child: SingleChildScrollView(

            child: Column(
              children: [
                choiceList(height: height, cubit: cubit, width: width,context: context),
               // loveStoryLogo(wid: width),
               // CreateStory()
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (con){
                    return CreateStory();
                  }));
                },
                    child: Text('create story'))
              ],
            ),
          ), );
      },);
  }

  Widget choiceList({required int height,required LoveCubit cubit , required int width,required BuildContext context}){

print(' hhhhhh is   ${height}}');
    return Container(
      //height: height.toDouble(),

      child: Column(
        children: [
          Row(
            children: [
             cardChoice(text: "قصص أهل الغرام",height: height, cubit: cubit, index: 1, wid: width),
             cardChoice( text: "قصصك المفضلة",height: height, cubit: cubit, index: 2, wid: width),
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             cardChoice( text: "قصص الأعضاء",height: height, cubit: cubit, index: 3, wid: width),
            ],
          ),

  // if(cubit.token!= null)
         //  createLoveStory(context: context),
        ],
      ),
    );
  }

  Widget cardChoice({required String text,required int height,required LoveCubit cubit, required int index,required int wid}){
   print('hhhhh ${height}');
    if(height < 500){
      height = (height /2).round();
    }else{
      height = (height /4).round();
    }
    double _textSizer= 20;
   if(wid< 380){
     _textSizer= 17;
   }
  // print('hhhhh ${height}');
    return   Expanded(
      child: GestureDetector(
        onTap: (){
          cubit.changeWidgetIndex(index: index);
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             color: Colors.white,
               border: Border.all(color: Colors.black)
           ),

           // alignment: AlignmentDirectional.center,
            height: height.toDouble(),
            width: wid/2,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [

               // loveStoryLogo(wid: height),
                Container(
                  width: wid/2.6,

                    //color: Colors.red,
                    child: FittedBox(child: Text(text, textAlign: TextAlign.center))),
                loveStoryLogo(wid: wid),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnCreateLoveStory({required BuildContext context}){
    return ElevatedButton(
      onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return CreateStory();
      }));
      },
      child: const Text('Create Story'),
    );
  }

  Widget loveStoryLogo({ required int wid}){
    double iconSize = 50;
    if(wid > 500){
      iconSize =70;
    }


   // print(wid);
   // print(queryData.textScaleFactor);

  //  queryData.devicePixelRatio;
    return Container(
     //height: wid/4,
      //width:wid.toDouble() ,

      child: Icon(
        Icons.favorite,
        size: iconSize,
        color: Colors.red,
      ),
    );
  }
}
