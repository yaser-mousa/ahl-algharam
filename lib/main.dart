
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/modules/comments/cubit/cubit.dart';
import 'package:lovestories/modules/notification/cubit/cubit.dart';
import 'package:lovestories/shared/cach_helper.dart';
import 'package:lovestories/styles/themes.dart';
import 'class_bloc/class_bloc.dart';
import 'layout/cubit/lovestates.dart';
import 'layout/love_layout.dart';
import 'modules/login/OTPcontroller.dart';
import 'modules/login/auth_name.dart';
import 'modules/login/select_image.dart';







Future backGroundMessage(RemoteMessage message)async
{

  print('============ backGroundMessage ================== ');
  print(message.notification!.body.toString());
  print('sender Id ====================== ${message.senderId}');
  print('event.messageId =================== ${message.data.values}');
  print('============ backGroundMessage ================== ');

}


Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor:  Colors.black,
    //systemNavigationBarDividerColor: Colors.red,
    systemNavigationBarIconBrightness: Brightness.light,
    //statusBarColor: Colors.pink,
  ));
 await init();
  FirebaseMessaging.onBackgroundMessage(backGroundMessage);


  firebaseGetToken();
  int index =0;
  var message = await FirebaseMessaging.instance.getInitialMessage().then((value) {
    if(value!= null){
      index =2;
    }
  });
  //Bloc.observer = MyBlocObserver();

  var token;




  if(FirebaseAuth.instance.currentUser != null){
    try{
      print('firebase token =================== ${FirebaseAuth.instance.currentUser!.uid}');
      token = FirebaseAuth.instance.currentUser!.uid;
    }
  catch(onError){
      print('Error ////// from Main in 61 Line FirebaseAuth.instance.currentUser : ${onError}');
  }

  }
  BlocOverrides.runZoned(
        () => runApp(MyApp(token: token, index: index)),
    blocObserver: MyBlocObserver(),
  );

}





class MyApp extends StatelessWidget {
  var token;
  int? index;
  MyApp ({Key? key,required this.token, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('builder');
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoveCubit>(
          create: (BuildContext context) => LoveCubit()..firebaseGetToken()..getYaserStoriesData()..getUsersStoriesData()..thisUserData()..initFirebaseMessaging(context)..changeWidgetIndex(index: index!),
        ),
        BlocProvider<CommentCubit>(
          create: (BuildContext context) => CommentCubit(),
        ),
        BlocProvider<NotifCubit>(
          create: (BuildContext context) => NotifCubit(),
        ),

      ],

      child: BlocConsumer<LoveCubit, LoveStates>(
        listener: (context, state){},
        builder: (context, state){

          LoveCubit _cubit = LoveCubit.get(context);



          if(!_cubit.tokenChange){

            _cubit.token = token;
            _cubit.setTokenNotFirst();
          }

          materialContext = context;

          print('token ////////////////////// ${token}');
          return  MaterialApp(
            title: 'أهل الغرام',
            theme:  _cubit.myThemeData(),
            // themeMode: ThemeMode.,
            // darkTheme: ThemeData.light(),

            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
// 'ar', 'AE
            supportedLocales: const [
              Locale('ar', ''),
            ],

            home: LoveLayout(),




//CarizmaLayout (token: token,),
          ); },
      ),
    );
  }
}

void firebaseGetToken()
{
  FirebaseMessaging.instance.getToken().then((value) {
    print('============================= token ===========================');
    print(value);

    print('============================= token ===========================');
  });

}

Future init()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}