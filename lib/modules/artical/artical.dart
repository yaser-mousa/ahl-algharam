import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/models/articals.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/models/user_data.dart';
import 'package:lovestories/modules/comments/comments_screen.dart';
import 'package:lovestories/modules/login/auth_name.dart';
import 'package:lovestories/modules/user_screen.dart';
import 'package:lovestories/shared/componanets/componanets.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:share_plus/share_plus.dart';
import 'edit_artical.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleScreen extends StatefulWidget {
  ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _copyToClipboard(
      {required BuildContext context, required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('نسخ للحافظة'),
    ));
  }

  @override
  Widget build(BuildContext context) {
// myInterstitial.listener(MobileAdEvent.closed);
    print('hello');
    print(MediaQuery.textScaleFactorOf(context));
    double textSize = 13;
    double textMainSize = 20;

    return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LoveCubit _cubit = LoveCubit.get(context);
        dynamic text;
        List<StoryModel> _article = [];
        if (_cubit.widgetIndex == 0) {
          // print('////////////// ////////////// ///////// ${_cubit.index}');
          _article = LoveCubit.get(context).yaserStoriesList;
          text = _article[_cubit.index].text.replaceAll('/n', '\n\n');

          print('article.length === ${_article.length}');
        } else {
          _article = LoveCubit.get(context).storiesList;
          text = _article[_cubit.index].text.replaceAll('/n', '\n\n');
        }

        print(' text is $text');
        print(_cubit.favoriteList);
        print(_cubit.index);
        return WillPopScope(
          onWillPop: () async {
            print('hhhhhhhhhhhhhhhhhhhh');
            //  _cubit.disposeEditingControllers();
            return true;
          },
          child: Scaffold(
              key: _scaffoldKey,
              appBar: appBarLife(
                  context: context,
                  cubit: _cubit,
                  title: _article[_cubit.index].title,
                  backOn: false),
              // drawer: drawerStories(_cubit: _cubit, context: context),
              body: Column(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  imageAndUserName(story: _article[_cubit.index], cubit: _cubit,context: context),
                  Expanded(
                    child: Stack(
                      children: [
                        textBody(text: text, cubit: _cubit),
                        myAllButtons(
                            cubit: _cubit, text: text, story: _article[_cubit.index]),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }



  Widget imageAndUserName({required StoryModel story, required LoveCubit cubit, required BuildContext context}){
    return GestureDetector(
      onTap: (){
        print('hello');
        if(cubit.yasAdmin){
          print(FirebaseAuth.instance.currentUser!.uid);
          cubit.getUserData(userId: story.userUid,context: context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
             backgroundImage: NetworkImage(story.checkBox ? '': story.image),
            ),
          SizedBox(width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(story.checkBox ? 'مجهول' : story.userName),
                Text(timeago.format(DateTime.parse(story.time),locale: 'en_short'),style: TextStyle(fontFamily: 'mirza'),),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget textBody({required String text, required LoveCubit cubit}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: cubit.setTextSize(20)),
                ),
              ),
            ),

            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  Widget myAllButtons(
      {required LoveCubit cubit,
      required String text,
      required StoryModel story}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myNiceButtonChild(
              color: Colors.pink,
              cubit: cubit,
              fun: () async {
                String str = '';
                if (str.contains('')) {
                  print('yes');
                }
                print(cubit.userData.name);
                if (FirebaseAuth.instance.currentUser == null ||
                    cubit.userData.name == null ) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AuthName();
                  }));

                  print(FirebaseAuth.instance.currentUser);
                }else{
                  cubit.createLikeForStory();
                  print('title is: ${story.likesId[cubit.index]}');
                }
              },
              title: 'أحببته',
              icon: story.likesId.contains(cubit.userData.userUid)
                  ? (Icons.favorite)
                  : (Icons.favorite_outline),
            ),

            myNiceButtonChild(
              color: Colors.blue,
              cubit: cubit,
              fun: () async {
                if (FirebaseAuth.instance.currentUser == null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AuthName();
                  }));
                }else{

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return   CommentScreenLove(storyModel: story);
                  }));
                }
              },
              title: 'تعليق',
              icon: Icons.comment,
            ),

            loveSpeedDial(text: text, cubit: cubit, story: story),

            // if (cubit.token != null)

            myNiceButtonChild(
                color: Colors.amber,
                cubit: cubit,
                fun: () async {
                  await Share.share(text);
                },
                title: 'مشاركة',
                icon: Icons.share),

            myNiceButtonChild(
              color: Colors.teal,
              cubit: cubit,
              fun: () async {
                _copyToClipboard(context: context, text: text);
              },
              title: 'نسخ',
              icon: Icons.copy,
            ),
          ],
        ),
      ),
    );
  }

  Widget myNiceButtonChild(
      {required Color color,
      required LoveCubit cubit,
      required String title,
      required var fun,
      required IconData icon}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //color: Colors.grey.withOpacity(0.2),
        Text(
          title,
          style: TextStyle(color: Colors.pink, fontSize: cubit.setTextSize(13)),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: fun,
            icon: Icon(
              icon,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget loveSpeedDial(
      {required String text,
      required LoveCubit cubit,
      required StoryModel story}) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.arrow_menu,
      children: [
       // if (checkUserUid(story.userUid, cubit))
          SpeedDialChild(
              child: const Icon(Icons.edit),
              label: 'تعديل',
              // labelStyle: TextStyle(fontSize: 8),

              onTap: () {
                cubit.initialEditingControllers();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ArticleEdit(
                    text: text,
                  );
                }));
              }),
       // if (checkUserUid(story.userUid , cubit))
          SpeedDialChild(
              child: const Icon(Icons.delete),
              label: 'حذف',
              //  labelStyle: TextStyle(fontSize: 8),
              onTap: () {
                cubit.deleteStory(
                  storyUid: story.storyUid,
                  context: context,
                );
              }),
        SpeedDialChild(
            child: const Icon(Icons.delete),
            label: 'حجم الخط',
            //  labelStyle: TextStyle(fontSize: 8),
            onTap: () {}),

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


  String  checkAndReturnUserUid(String userId) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == userId) {
        return FirebaseAuth.instance.currentUser!.uid;
      }
      return '';
    } catch (onError) {
      print(onError);
      return '';
    }
  }

  String checkUserData(UserModel? user){
    if(user != null){
      return user.userUid;
    }
    return '';

  }
}
