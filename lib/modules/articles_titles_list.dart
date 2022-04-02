import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'artical/artical.dart';
import 'create_stroy.dart';
import 'login/auth_name.dart';

class ArticleTitlesList extends StatelessWidget {
  List<StoryModel> storiesList;
  int height;
  BuildContext context;
  LoveCubit? cubit;

   ArticleTitlesList({Key? key, required this.storiesList, required this.height,  required this.context,  required this.cubit}) : super(key: key);
  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Perform your task

        if(cubit!.widgetIndex ==0){
          cubit!.getLimitYaserStoriesData();
        }else{
          cubit!.getLimitUsersStoriesData();

        }
      }
    });
  //  cubit?.initialCreateControllers();
    return BlocConsumer<LoveCubit, LoveStates>(builder: (context , state){
      return Conditional.single(
          context: context,
          conditionBuilder:(context)  => storiesList.isNotEmpty,
          widgetBuilder: (context){
            return Column(
              children: [
                GestureDetector(
                  onTap: (){
                    if(FirebaseAuth.instance.currentUser!= null){
                      cubit!.initialCreateControllers();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return CreateStory();
                      }));
                    }else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return AuthName();
                      }));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      //color: Colors.white,
                      // width: 40,
                      height: 50,
                      width: double.infinity,

                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(25.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.pink)
                      ),
                      //   height: 40,
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('أكتب قصة', style:TextStyle(fontSize: cubit?.setTextSize(17)),),
                      ),),
                  ),
                ),
                Flexible(

                  child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Container(

                                // height: hie / 5,
                                child: GestureDetector(
                                  onTap: (){

                                      cubit!.getLikesId(storiesList[index].storyUid);

                                    print('index');
                                    cubit!.setIndex = index;
                                    cubit!.setContext(context);
                                    print('index');
                                    //print(index);

                                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                      return ArticleScreen();
                                    }));
                                    //  cubit.showInterstitialAd();
                                    // cubit.initState(url: cubit.voiceList[index].getVoice);
                                  },
                                  child: Card(

                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        SizedBox( height: height / 12,),
                                        Expanded(child: Text(storiesList[index].title, style:  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: cubit?.setTextSize(20)), textAlign: TextAlign.center,)),
                                        //Spacer(),
                                        //Text(storiesList[index].comments.toString()),
                                        if(storiesList[index].likes >0)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text('${storiesList[index].likes}'),
                                                Icon(Icons.favorite, color: Colors.pink,)
                                              ],
                                            ),
                                          ),

                                        //    const SizedBox(width: 20,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if(index ==storiesList.length-1 && state is LoadingGetStoriesUsers)
                                CircularProgressIndicator()
                            ],
                          ),
                        );
                      },
                      separatorBuilder:(context, index){
                        return Container();
                      },
                      itemCount: storiesList.length),
                ),


                // Align(
                //   alignment: Alignment(0, 1.0),
                //   child: cubit.currentAd,
                // )
              ],
            );
          },
          fallbackBuilder: (context){
            return fallbackContainer(context ,cubit!);
          });
    }, listener: (context , state){});
  }
}


// Widget titlesListBody({}){
//   //cubit.createStoryController
//
//   return
//
//
// }
Widget fallbackContainer(BuildContext context, LoveCubit cubit){
  return Column(
    children: [

      GestureDetector(
        onTap: (){
          if(FirebaseAuth.instance.currentUser!= null){
            cubit.initialCreateControllers();

            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CreateStory();
            }));
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return AuthName();
            }));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //color: Colors.white,
            // width: 40,
            height: 50,
            width: double.infinity,

            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(25.0),
                color: Colors.white,
                border: Border.all(color: Colors.pink)
            ),
            //   height: 40,
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('أكتب قصة', style:TextStyle(fontSize: cubit.setTextSize(17)),),
            ),),
        ),
      ),
      Container(
          height: 0,
          width: double.infinity,
          color: Colors.grey),
    ],
  );
}