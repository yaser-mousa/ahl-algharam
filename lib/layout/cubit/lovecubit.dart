import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/main.dart';
import 'package:lovestories/models/notification.dart';
import 'package:lovestories/models/user_data.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/modules/all_articles_screen.dart';
import 'package:lovestories/modules/artical/artical.dart';
import 'package:lovestories/modules/choice_screen.dart';
import 'package:lovestories/modules/comments/comments_screen.dart';
import 'package:lovestories/modules/favorite_sories.dart';
import 'package:lovestories/modules/login/select_image.dart';
import 'package:lovestories/modules/notification/cubit/cubit.dart';
import 'package:lovestories/modules/notification/notif_screen.dart';
import 'package:lovestories/modules/user_screen.dart';
import 'package:lovestories/modules/user_stories.dart';
import 'package:lovestories/shared/cach_helper.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lovestories/shared/componanets/componanets.dart';


class LoveCubit extends Cubit<LoveStates> {
  LoveCubit() : super(InitialLifeState());

  static LoveCubit get(context) => BlocProvider.of(context);
  String? str = 'str';
  int _showLogin = 0;
  var token;
  bool? _tokenChange = false;
  bool _isPlay = true;
  //ScrollController _scrollController = ScrollController();
  final Duration _position = const Duration();
  final Duration _duration = const Duration();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _createStoryController ;
  TextEditingController? _articleTitleEditingController;
  TextEditingController? _articleEditingController;
  TextEditingController? _createTitleStoryController ;
  TextEditingController? _textControllerText ;

  List<String> _favoriteList =[];
  bool _yasAdmin =false;
  List<String> get favoriteList => _favoriteList;
  String? _url;
  bool _loading = true;
  bool _firstTime = true;
  bool _isInterstitialAdLoaded = false;
  BuildContext? context;
  int? _index;
  int _widgetIndex = 0;
  String? _msgToken ;

  TextEditingController get textControllerText => _textControllerText!;

  set textControllerText(TextEditingController value) {
    _textControllerText = value;
  }
  String get msgToken => _msgToken!;

  set msgToken(String value) {
    _msgToken = value;
  }

  void initNotific(BuildContext context){
    var notifCuibit = NotifCubit.get(context);
    notifCuibit.getNotifications(context);
  }

  void changeYasAdmin() {
    _yasAdmin = !_yasAdmin;
    print(_yasAdmin);
    emit(ChangeAdminState());
  }




  List<Widget> loveWidgets = [
   // const ChoiceScreen(),
    const AllArticlesScreen(),
   // const FavoriteLoveStories(),
    const UserLoveStories(),
    const NotifScreen()

  ];

  List<String> loveWidgetsTitles = [
    'أهل الغرام',
    'قصص الأعضاء',
    'الاشعارات'
  ];

  void changeWidgetIndex({required int index}) {
    _widgetIndex = index;
    emit(ChangeWidgetIndex());
  }





  //////////////////////// Stories data //////////////////////////////
  //////////////////////// Stories data //////////////////////////////
  //////////////////////// Stories data //////////////////////////////
  //////////////////////// Stories data //////////////////////////////


  String _collection = 'usersSto';


  String get collection => _collection;



  List<StoryModel> _storiesList = [];



  List<StoryModel> get storiesList => _storiesList;


  void updateLikesFroStory({required String storyUid, required int likesNumber}){

    String collection = 'yaserSto';
    if(widgetIndex==1){
      collection = 'usersSto';
    }

    FirebaseFirestore.instance
    .collection(collection)
    .doc(storyUid)
    .update({'likes' : likesNumber})
    .then((value) {

      emit(UpdateLikeForStory());
    })
    .catchError((onError){
      print(onError);
    });
  }

  void createLikeForStory (){
   try{
    bool canCreate = false;
    String?  storyUid;

    if(widgetIndex==0){
      if(_yaserStoriesList[index].likesId.contains(_userData?.userUid)){
        _yaserStoriesList[index].likesId.remove(_userData?.userUid);
        print( 'like id number  ======== ${ _yaserStoriesList[index].likesId.length}');
        _yaserStoriesList[index].likes --;
        emit(RemoveLikeFromListFirstStep());
      }else{
        _yaserStoriesList[index].likesId.add(_userData!.userUid);
        _yaserStoriesList[index].likes ++;
        emit(CreateLikeFirstStepSuccess());
        canCreate = true;
      }
      _collection ='yaserSto';
      storyUid = _yaserStoriesList[index].storyUid;
      updateLikesFroStory(likesNumber: _yaserStoriesList[index].likes , storyUid: storyUid);
    }else{

      if(_storiesList[index].likesId.contains(_userData!.userUid)){
        _storiesList[index].likesId.remove(_userData!.userUid);
        _storiesList[index].likes --;
        emit(RemoveLikeFromListFirstStep());
      }else{

        _storiesList[index].likesId.add(_userData?.userUid);
        _storiesList[index].likes ++;
        emit(CreateLikeFirstStepSuccess());
        canCreate = true;
      }
      _collection = 'usersSto';
      storyUid = _storiesList[index].storyUid;
    updateLikesFroStory(likesNumber:  _storiesList[index].likes , storyUid: storyUid);
    }

    if(canCreate){
      _createLikeInFirebase(storyUid);
    }else{
      _deleteLikeFromFirebase(storyUid);
    }



   }
   catch(onError){
     print(onError);
   }
  }


  void _createLikeInFirebase (String storyUid){
    FirebaseFirestore.instance
        .collection(_collection)
        .doc(storyUid)
        .collection('likes')
        .doc(_userData?.userUid)
        .set({'like': true})
        .then((value) {
      emit(CreateLikeLastStepSuccess());
    })
        .catchError((onError){
      print('good');
      if(widgetIndex==0){
        _yaserStoriesList[index].likesId.remove(_userData?.userUid);
      }else{
        _storiesList[index].likesId.remove(_userData?.userUid);
      }
      emit(CreateLikeError());
      print(onError);
    });
  }

  void _deleteLikeFromFirebase(String storyUid){

    FirebaseFirestore.instance
        .collection(_collection)
        .doc(storyUid)
        .collection('likes')
        .doc(_userData?.userUid)
        .delete()
        .then((value) {
      emit(RemoveLikeFromListLastStep());
    })
        .catchError((onError){
      //emit(CreateLikeError());
      print('While try to remove a like : ${onError}');
    });
  }

var _lastUserStory;
  void getUsersStoriesData() {
    _storiesList = [];
    _getUsersStories = true;
    FirebaseFirestore.instance.collection('usersSto').orderBy('time', descending: true).limit(10).get().then((value) {
      _lastUserStory = value.docs.last;

      _getStoriesAndComments(value: value ,x: 0);

    }).catchError((onError) {
      print('//////////////////////////////////// on error ${onError}');
    });
  }


bool _getUsersStories = true;



  void getLimitUsersStoriesData() {
   

// print(_lastUserStory.data()['text']);
   if(_getUsersStories){
     emit(LoadingGetStoriesUsers());
     _getUsersStories = false;
     FirebaseFirestore.instance.collection('usersSto').orderBy('time', descending: true).startAfterDocument( _lastUserStory ).limit(10).get().then((value) {
       _lastUserStory = value.docs.last;

       value.docs.forEach((element) {
         print(element.id);
       });
       _getStoriesAndComments(value: value ,x: 0);
       _getUsersStories = true;
     }).catchError((onError) {
       if(onError.toString()=='Bad state: No element'){
         _getUsersStories   = false;
       }
       emit(GetLimitUsersStoriesDataError());
       print('//////////////////////////////////// on error ${onError}');
     });
   }
  }



  void _getStoriesAndComments({required QuerySnapshot<Map<String, dynamic>> value, required int x}){
    var mainValue = value;
    print('value docs len is : ${value.docs.length}');
   // value.docs[x].data();

    _storiesList.add( StoryModel.fromJson(value.docs[x].data()));
    _storiesList.last.storyUid = value.docs[x].id;
    print('print from limit === ${ _storiesList.last.storyUid }');
    _storiesList.last.comments = 0;
    _storiesList.last.likesId =[];
    print(_storiesList.last.text );

   // _storiesList[x].likesId = [];
    x++;
    if(x<mainValue.docs.length){
      _getStoriesAndComments(value: mainValue, x: x);
    }else{
      print(_storiesList.length);
      _storiesList.forEach((element) {
        print('end ==== ${element.storyUid}');
      });
      emit(GetDataVoicesSuccess()) ;
    }



  }

  var _lastYaserSto;
  bool _getyaserLimitt = true;
  void getLimitYaserStoriesData() {
    print(_getyaserLimitt);
    if(_getyaserLimitt){
      _getyaserLimitt = false;
      //_getyaserLimit = false;
      emit(LoadingGetStoriesUsers());
      print(_lastYaserSto.data());
      FirebaseFirestore.instance.collection('yaserSto').orderBy('time', descending: true).startAfterDocument( _lastYaserSto ).limit(10).get().then((value) {
        _lastYaserSto = value.docs.last;
        print(_lastYaserSto.data());
        _getStoriesYasserAndComments(value: value, x: 0);
        _getyaserLimitt = true;
      }).catchError((onError) {
        if(onError.toString()=='Bad state: No element'){
          _getyaserLimitt   = false;
        }
        emit(GetLimitUsersStoriesDataError());
        print('//////////////////////////////////// on error ${onError}');
      });
    }


  }

  List<StoryModel> _yaserStoriesList = [];



  List<StoryModel> get yaserStoriesList => _yaserStoriesList;

  Future<void> getYaserStoriesData() async {
    _getyaserLimitt = true;
    _yaserStoriesList = [];
    FirebaseFirestore.instance.collection('yaserSto').orderBy('time', descending: true).limit(10).get().then((value) {
      _getStoriesYasserAndComments(value: value, x: 0);
      _lastYaserSto = value.docs.last;

    }).catchError((onError) {
      print('//////////////////////////////////// on error ${onError}');
    });
  }


  void _getStoriesYasserAndComments({required QuerySnapshot<Map<String, dynamic>> value, required int x}){
    var mainValue = value;
    print('value docs len is : ${value.docs.length}');
    value.docs[x].data();
    _yaserStoriesList.add( StoryModel.fromJson(value.docs[x].data()));
    _yaserStoriesList.last.storyUid = value.docs[x].id;
    _yaserStoriesList.last.comments = 0;
    _yaserStoriesList.last.likesId = [];
   print(_yaserStoriesList.last.text );

    x++;
    if(x<mainValue.docs.length){
      _getStoriesYasserAndComments(value: mainValue, x: x);
    }else{
     // _getyaserLimit = false;
      emit(GetYaserStoriesDataSuccess());
    }



  }
  void getLikesId(String storyUid){
    String collection = 'yaserSto';

    if(widgetIndex ==1){
      collection = 'usersSto';
    }
    //_storiesList[index].likesId = [];

    FirebaseFirestore.instance
        .collection(collection)
        .doc(storyUid)
        .collection('likes')
        .    get()
        .then((value) {
      if(widgetIndex == 1){
        _storiesList[index].likesId = [];
        value.docs.forEach((element) {
          _storiesList[index].likesId.add( element.id);
        });
      }else{
        yaserStoriesList[index].likesId = [];
        value.docs.forEach((element) {
          yaserStoriesList[index].likesId.add( element.id  );
        });
        // yaserStoriesList[index].likesId.add(   )
      }

      emit(GetLikesUidSuccess());
    })
        .catchError((onError){
      print(onError);
      emit(GetLikesUidError());
    });
  }
  void printStoriesData() {
    for (var x = 0; x < _storiesList.length; x++) {
      print(_storiesList[x].title);
    }
  }

  void storiesUpdate({required String? str, required BuildContext context, required String title, required StoryModel story
  }) {

    String  storyUid='';


    if(yasAdmin){
      _collection ='yaserSto';
        storyUid = yaserStoriesList[index].storyUid;
    }else{
      _collection = 'usersSto';
       storyUid = _storiesList[index].storyUid;
    }
    //print(str);
    //print(_storiesList[index].title);

    StoryModel articalsModel =
    StoryModel.setValues(
      checkBox: story.checkBox ,
      likes: story.likes,
      token: _userData!.token,
      text: str!,
      title: title,
      userName: _userData?.name,
      image: _userData?.picImage,
      userUid: _userData?.userUid,
      time: story.time,
    );



    FirebaseFirestore.instance.collection(_collection).
    doc(storyUid).
    update(articalsModel.toMap()).then((value) {
      print('update end');
     //disposeEditingControllers();
      if(yasAdmin){
        getYaserStory(context);
      }
        else{
          getStory(context: context);
      }

    }).catchError((onError) {
      print(onError);
    });
  }
  StoryModel _storyDataModel =StoryModel() ;
  void getStory({BuildContext? context , NotifModel? notifModel}) {

print('collection is === ${_collection}');
String? storyUid;
String? collection = 'usersSto';
if(notifModel != null){
 storyUid = notifModel.storyId;

 if(notifModel.collection == 0){
   collection = 'yaserSto';
 }
}

// print(collection);
// print('story id ===${storyUid}');

    FirebaseFirestore.instance
        .collection(collection).
    doc( storyUid??  _storiesList[index].storyUid)
        .get()
        .then((value) {
          print('success');
      //  setState(() {
          if(value.data() ==null){
           AwesomeDialog(context: context!, title: 'عذرا يبدو بأن هذه القصة تم حذفها').show();
           if(notifModel!= null){
             deleteNotification(notifModel: notifModel);
           }

          }
      if(storyUid !=null){
        _storyDataModel = StoryModel.fromJson(value.data()!);
        _storyDataModel.storyUid = value.id;
      //  emit(GetArticleSuccess());
        print(_storyDataModel.userName);
        Navigator.of(context!).push(MaterialPageRoute(builder: (context){

          return  CommentScreenLove(storyModel:_storyDataModel , notifModel : notifModel);
        }));
      //  changeWidgetIndex(index:notifModel!.collection );
      }else{
        _storiesList[index] = StoryModel.fromJson(value.data()!);
        _storiesList[index].storyUid = value.id;
        String str = _storiesList[index].text;
        if (str.contains("/n")) {
          str = str.replaceAll('/n', "\n");
        }
        //_articleEditingController.text = str;
        Navigator.of(context!).push(MaterialPageRoute(builder: (context){

          return  LoveLayout();
        }));
      }


      //disposeEditingControllers();


    }).catchError((onError) {
      print('error is ${onError}');
    });
  }
void deleteNotification({ required NotifModel notifModel}){

String? storyUid;
String? collection = 'usersSto';
if(notifModel != null){
storyUid = notifModel.storyId;

if(notifModel.collection == 0){
collection = 'yaserSto';
}
}

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(notifModel.notifId)
        .delete().then((value) {
          print('success delete');
    })
    .catchError((onError){
      print(onError);
    });
}


  void getYaserStory(BuildContext context) {
    FirebaseFirestore.instance
        .collection('yaserSto').
    doc(_yaserStoriesList[index].storyUid)
        .get()
        .then((value) {
      //  setState(() {
      _yaserStoriesList[index] = StoryModel.fromJson(value.data()!);
      _yaserStoriesList[index].storyUid = value.id;
      String str = _yaserStoriesList[index].text;
      if (str.contains("/n")) {
        str = str.replaceAll('/n', "\n");
      }
     // _articleEditingController.text = str;

      Navigator.of(context).push(MaterialPageRoute(builder: (context){

        return  LoveLayout();
      }));
     // disposeEditingControllers();
      emit(GetArticleSuccess());

    }).catchError((onError) {
      print('error is ${onError}');
    });
  }

  void setTextStoryController(String str) {
    _articleEditingController!.text = str;
    emit(TextArticleController());
  }

  void deleteStory({

    required String storyUid,
    required BuildContext context
}){

    if(yasAdmin){
      _collection = 'yaserSto';
    }else{
      _collection = 'usersSto';
    }
print(storyUid);
    print(_collection);
    FirebaseFirestore.instance.collection(_collection)
        .doc(storyUid)
        .delete()
        .then((value) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return LoveLayout();
          }));
          if(yasAdmin){
            getYaserStoriesData();
          }else{
            getUsersStoriesData();
          }

    })
        .catchError((onError){
          print(onError);
    });
  }

  //////////////////////////////////////// create Story /////////////////////
//////////////////////////////////////// create Story /////////////////////
//////////////////////////////////////// create Story /////////////////////

  void createNewStory({required String  collection,required String str, required String title}) {
    if(yasAdmin){
      collection = 'yaserSto';
    }else{
      collection = 'usersSto';
    }
    StoryModel story =
    StoryModel.setValues(
      checkBox: _checkBox,
      likes: 0,
        token: userData.token,
        title: title,
        time: DateTime.now().toString(),
        image: userData.picImage,
        text: str,
        userName: userData.name,
        userUid: userData.userUid);

    FirebaseFirestore.instance.collection(collection)
        .add(
         story.toMap())
        .then((value) {
      emit(CreateNewStorySuccess());
      if(yasAdmin){
        getYaserStoriesData();
      }else{
        getUsersStoriesData();
      }



    }).
    catchError((onError) {
      print(onError);
      emit(CreateNewStoryError());
    });
  }




////////////////////////////////////////// verifyPhone //////////////////////
////////////////////////////////////////// verifyPhone //////////////////////
////////////////////////////////////////// verifyPhone //////////////////////
////////////////////////////////////////// verifyPhone //////////////////////

  var auth = FirebaseAuth.instance;
  var isLoading = false;
  var verId = '';
  var authStatus = '';
  String _country= '+962';
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final  TextEditingController _phoneController = TextEditingController();
  String _phoneNumber = '' ;


  get firstNameController => _firstNameController;

  get country => _country;
  get secondNameController => _secondNameController;

  get phoneController => _phoneController;
  String get phoneNumber => _phoneNumber;

  void setCountry({required String country}){

    _country = country;
    emit(SetCountryCode());
  }

  void verifyPhone({String? phone}) async {
    isLoading = true;
    if(phone!=null){
      _phoneNumber = phone;
      emit(SetPhoneNumber());
    }

    await auth.verifyPhoneNumber(
        timeout: Duration(seconds: 50),
        phoneNumber: _phoneNumber,
        verificationCompleted: (AuthCredential authCredential) {

          if (auth.currentUser != null) {
            isLoading = false;
            authStatus = "login successfully";
            print('login successfully');

          }
          print('it is done');

        },
        verificationFailed: (authException) {
          print(authException);
          print("sms code info otp code hasn't been sent!!");
        },
        codeSent: (String id, [ int? forceResent]) {
          isLoading = false;
          this.verId = id;
          authStatus = "login successfully";
        },
        codeAutoRetrievalTimeout: (String id) {
          this.verId = id;
        });
  }


  /////////
  void otpVerify({required String otp, required BuildContext context}) async {
   isLoading = true;
    try {
      UserCredential userCredential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: this.verId, smsCode: otp)
      );
      if (userCredential.user != null) {
        userCredential.user!.uid;
        isLoading = false;
        print('go to home');
        thisUserData();
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return SelectImage();
        }));
      }
    } on Exception catch (e) {
      print("الرمز غير صحيح");

      emit(CodeNotCorrect(e.toString()));
    }
  }


  File? _profileImage;
  final _picker = ImagePicker();

  File? get profileImage => _profileImage;


  Future<void> getProfileImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(ProfileImagePickedErrorState());
    }
  }

  String? _profileImageUrl;
  void uploadProfileImage() {
    try{
      if(profileImage!=null){
        emit(UploadProfileImageLoadingState ());
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child('users/${Uri.file(_profileImage!.path).pathSegments.last}')
            .putFile(_profileImage!)
            .then((value) {
          value.ref.getDownloadURL().then((value) {
            _profileImageUrl = value;
            print('profileImageUrl ${_profileImageUrl}');
            print(value);
            userCreated();
            //emit(UploadProfileImageSuccessState(_profileImageUrl));
          }).catchError((onError) {
            emit(UploadProfileImageErrorState());
            print(onError);
          });
        }).catchError((onError) {
          emit(UploadProfileImageErrorState());
          print(onError);
        });
      }

  }catch(onError){
      print(onError);
    }

  }

  void userCreated()async {
    var model = UserModel.setValues(
      token: _msgToken,
      name: _firstNameController.text + ' ' + _secondNameController.text,
      phonNumber: convertNumbers(_country+_phoneController.text),
      picImage: _profileImageUrl
    );

    print(model.phoneNumber);

    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid,)
        .set(model.toMap())
        .then((value) {
          thisUserData();
      emit(CreateUserSuccessDataState(auth.currentUser?.uid,));
    }).catchError((error) {
      emit(CreateUserErrorDataState(error.toString()));
    });
  }

 UserModel? _userData = UserModel();


  UserModel get userData => _userData!;

  void thisUserData (){
    try{
      if(auth.currentUser !=null){
        FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get().then((value) {
          _userData = UserModel.fromJson(value.data()!);
          _userData!.userUid = value.id;
          emit(ThisUserDataSuccess());
          print(_userData!.phoneNumber);
          print(_userData!.userUid);
          print(_userData!.picImage);
          print(_userData!.name);
        });
      }
    }
    catch(onError){
      print(onError);
      emit(ThisUserDataError());
    }

  }


  UserModel get userInformation => _userInformation;

  set userInformation(UserModel value) {
    _userInformation = value;
  }

  UserModel  _userInformation = UserModel();
  void getUserData({required String userId, required BuildContext context}){
    try{
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get().then((value) {
          _userInformation = UserModel.fromJson(value.data()!);
          _userInformation.userUid = value.id;
          print(_userInformation.phoneNumber);
          print(_userInformation.userUid);
          print(_userInformation.picImage);
          print(_userInformation.name);

          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return UserScreen();
          }));

          emit(GetUserDataSuccess ());
        });

    }
    catch(onError){
      print(onError);
      emit(GetUserDataError());
    }

  }

  void blockUserFromId({required String userId, required BuildContext context}){

    try{
      FirebaseFirestore.instance
          .collection('blocks')
          .doc(userId)
          .set({'block' : true})
          .then((value) {
            emit(BlockUserFromIdSuccess());
            AwesomeDialog(context: context, title: 'Success block');

      })
          .catchError((onError){
            print(onError);
            emit(BlockUserFromIdError());
            AwesomeDialog(context: context, title: 'Error block');
      });

    }
    catch(onError){
      print(onError);
    }
  }


  void unblockUserFromId({required String userId, required BuildContext context}){

    try{
      FirebaseFirestore.instance
          .collection('blocks')
          .doc(userId)
         .delete()
          .then((value) {
        emit(UnblockUserFromIdSuccess());

      })
          .catchError((onError){
        emit(UnblockUserFromIdError());
        AwesomeDialog(context: context, title: 'Error Unblock');
      });

    }
    catch(onError){
      print(onError);
    }
  }



////////////////////////// theme ////////////////////

  double _textSizeDriver =0;

  String _saraFont= 'sara';
  bool _setSaraTrue = true;

  //double get textSizeDriver => _textSizeDriver; //double storyTextSize;

  double setTextSize(double size){
    if(_textSizeDriver>1){
      return size / _textSizeDriver;
    }

    return size;
  }

  bool get setSaraTrue => _setSaraTrue;

  void setTextSizeDrive(double textSize){

    if(_textSizeDriver==0){
      _textSizeDriver = textSize;
      emit(SetTextSize());
    }

  }

  set setSaraTrue(bool value) {
    _setSaraTrue = value;
    emit(SetSaraBool());
  }

  String get saraFont => _saraFont;

  set saraFont(String value) {
    _saraFont = '';
    _setSaraTrue = false;
    emit(SetSaraFont());
  }

  ThemeData myThemeData(){
    return    ThemeData(
      fontFamily: 'cairo',
      brightness: Brightness.light,
      backgroundColor: Color(0xffF7DCEC),
      primaryColor: Color(0xffF9C2F2),
      scaffoldBackgroundColor: Color(0xffF7DCEC),
      appBarTheme: const AppBarTheme(
          actionsIconTheme:  IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),

          brightness: Brightness.light,
          backgroundColor: Color(0xffF9C2F2),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'cairo')
      ),

      textTheme:  const TextTheme(

          headline1:  TextStyle(
              height: 1.7,
              color: Colors.black,
              fontSize: 25),
          bodyText1: TextStyle(fontSize: 20,  fontFamily: 'cairo',)),

    );
}


  ////////////////////////////// getter and setter ///////////////////////////
  ////////////////////////////// getter and setter ///////////////////////////
  ////////////////////////////// getter and setter ///////////////////////////
  ////////////////////////////// getter and setter ///////////////////////////


  set favoriteList(List<String> value) {
    _favoriteList = value;
  }

  int get widgetIndex => _widgetIndex;

  set widgetIndex(int value) {
    _widgetIndex = value;
  }

  TextEditingController get passwordController => _passwordController!;

  TextEditingController get emailController => _emailController!;

  set emailController(TextEditingController value) {
    _emailController = value;
  }

  bool get yasAdmin => _yasAdmin;

   get createTitleStoryController => _createTitleStoryController;

   get createStoryController => _createStoryController;

  get articleEditingController => _articleEditingController;

  get articleTitleEditingController => _articleTitleEditingController;

  get tokenChange => _tokenChange;

  get showLogin => _showLogin;

  get isPlay => _isPlay;

  // get scrollController => _scrollController;

  get position => _position;

  get duration => _duration;

  get url => _url!;

  get loading => _loading;

  get firstTime => _firstTime;

  get index => _index;


  void setTokenNotFirst() {
    _tokenChange = true;
    emit(SetTokenNotFirst());
  }

  set firstTime(dynamic firstTime) {
    _firstTime = firstTime;
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  set setIndex(int index) {
    _index = index;
    emit(SetIndex());
  }

  void plusLoginShow() {
    _showLogin++;
    emit(PlusLoginShow());
  }



  //////////////////////////////////////// initial Controllers ///////////////////////
  //////////////////////////////////////// initial Controllers ///////////////////////
  //////////////////////////////////////// initial Controllers ///////////////////////
  //////////////////////////////////////// initial Controllers ///////////////////////

  void initialEditingControllers(){
    try{
      _articleTitleEditingController =TextEditingController();
      _articleEditingController = TextEditingController();
    }
    catch(onError){
      print(onError);
    }

  }

  void initialEmailAndPasswordControllers(){
    try{
      _emailController =TextEditingController();
      _passwordController = TextEditingController();
    }
    catch(onError){
      print(onError);
    }

  }

  void initialCreateControllers(){
    try{
      print('in initial state ===============');
      _createStoryController =TextEditingController();
      _createTitleStoryController = TextEditingController();
    }
    catch(onError){
      print(onError);
    }

  }

  /////////////////////////////////// login WithEmailAndPassword///////////////////////////
/////////////////////////////////// login WithEmailAndPassword///////////////////////////
/////////////////////////////////// login WithEmailAndPassword///////////////////////////
/////////////////////////////////// login WithEmailAndPassword///////////////////////////
  void signInWithEmailAndPassword() {

    String email = emailController.text;
    String password = passwordController.text;

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      print('user user id  = ${value.user!.uid}');
      var userId = value.user!.uid;


      CacheHelper.saveData(key: 'token', value: userId).then((value) {
        //var last = await CacheHelper.getData(key: 'token');
        //print('last====$last');

        token = userId;

        // print('_token is ${_token}');

        emit(SignInWithEmailAndPasswordSuccess());
      });
    }).catchError((onError) {
      print(onError.toString());

      emit(ErrorSignInWithEmailAndPassword());
    });
  }

  void logOutFirebase() {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'token');
      token = null;
      emit(ChangeTokenState());
    });
  }




  ///////////////////////// favorite ///////////////////////////
  ///////////////////////// favorite ///////////////////////////
  ///////////////////////// favorite ///////////////////////////
  ///////////////////////// favorite ///////////////////////////

  void setFavoriteList({ int? favorite, List<String>? favList})  {
    //_favoriteList.removeWhere((element) => false)


    if(favorite != null){
      _favoriteList.add(favorite.toString());
    }else{
      _favoriteList = favList!;
    }

    CacheHelper.saveList(key: 'favorite', value: _favoriteList ).
    then((value) {
      getFavoriteList();
    })
        .catchError((onError){
      emit(SetFavoriteListError());
      print(' setFavoriteList Error : $onError');
    });

  }




  void  getFavoriteList()  {
    try{
      _favoriteList = CacheHelper.getList(key: 'favorite');
      emit(GetFavoriteListSuccess());
      print(_favoriteList);
    }
    catch(onError){
      emit(GetFavoriteListError());
      print(onError);
    }


  }

  void removeFavoriteList({required String removeFav}){
    try{
      _favoriteList.removeWhere((element) => element.contains(removeFav));
      CacheHelper.removeData(key: 'favorite')
          .then((value) {
        emit(RemoveFavoriteListSuccess());
        if(_favoriteList.isNotEmpty){
          //setFavoriteList(favList:_favoriteList);
        }

      })
          .catchError((onError){
        print('removeFavoriteList Error :  $onError');
        emit(RemoveFavoriteListError());
      });

    }
    catch(onError){
      print(onError);
    }
  }

  // void justChangeState(){
  //   emit(RemoveFavoriteListError());
  // }

  ////////////////////////////// close ///////////////////////////
  ////////////////////////////// close ///////////////////////////
  ////////////////////////////// close ///////////////////////////
  ////////////////////////////// close ///////////////////////////


  @override
  Future<void> close() {
    //_scrollController?.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
    _createStoryController?.dispose()  ;
    _articleTitleEditingController?.dispose();
    _articleTitleEditingController?.dispose();
    _articleEditingController?.dispose() ;
    _createTitleStoryController?.dispose() ;
    //});
    print('audio dispose');
    return super.close();
  }



  Widget currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

///////////////////////// FirebaseMessaging. /////////////////////////////
///////////////////////// FirebaseMessaging. /////////////////////////////
///////////////////////// FirebaseMessaging. /////////////////////////////
///////////////////////// FirebaseMessaging. /////////////////////////////

 Future messagingRequestPermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void firebaseGetToken()
  {
    FirebaseMessaging.instance.getToken().then((value) {
      print('============================= token ===========================');
      print(value);
      _msgToken = value;
      print('============================= token ===========================');
    });

  }
void initFirebaseMessaging(BuildContext context)async{

  await messagingRequestPermission();
  FirebaseMessaging.onMessage.listen((event) {
    print('===================== notification onMessage ====================');
    print(event.notification!.body);
    print('sender Id ====================== ${event.senderId}');
    print('event.messageId =================== ${event.messageId}');

    // print(event.notification!);
    print('===================== notification onMessage ====================');

  });



}


  bool get checkBox => _checkBox;

  set checkBox(bool value) {
    _checkBox = value;
  }

  bool _checkBox = false;
void checkBoxChangeState({required bool value }){
   _checkBox = value;

   emit( CheckBoxChangeState());
  // print(createTitleStoryController.text);
}


///////////////////////////////// ads //////////////////////////////
///////////////////////////////// ads //////////////////////////////
///////////////////////////////// ads //////////////////////////////
///////////////////////////////// ads //////////////////////////////

// void loadInterstitialAd() {
//   FacebookInterstitialAd.loadInterstitialAd(
//     // placementId: "YOUR_PLACEMENT_ID",
//     placementId: "2966946420302420_2966963100300752",
//     listener: (result, value) {
//       print(">> FAN > Interstitial Ad: $result --> $value");
//       if (result == InterstitialAdResult.LOADED) {
//         _isInterstitialAdLoaded = true;
//
//         emit(ChangeInterstitialAdLoadedTrue());
//       }
//
//
//       /// Once an Interstitial Ad has been dismissed and becomes invalidated,
//       /// load a fresh Ad by calling this function.
//       if (result == InterstitialAdResult.DISMISSED &&
//           value["invalidated"] == true) {
//         _isInterstitialAdLoaded = false;
//         if (!_isInterstitialAdLoaded) {
//           // Navigator.push(
//           //     context!,
//           //     MaterialPageRoute(
//           //         builder: (context){
//           //           return ArticalScreen(index: index, artical: artical);
//           //         }));
//           emit(ChangeInterstitialAdLoadedFalse());
//         }
//         // testState(url: '');
//         loadInterstitialAd();
//       }
//     },
//   );
// }

// showInterstitialAd() {
//   if (_isInterstitialAdLoaded == true)
//     FacebookInterstitialAd.showInterstitialAd();
//   else {
//     print("Interstial Ad not yet loaded!");
//     // Navigator.push(
//     //     context!,
//     //     MaterialPageRoute(
//     //         builder: (context) {
//     //           return VoiceScreen();
//     //         }));
//   }
// }


// showBannerAd() {
//   currentAd = FacebookBannerAd(
//     // placementId: "YOUR_PLACEMENT_ID",
//     placementId:
//     "2966946420302420_2966946983635697", //testid
//     bannerSize: BannerSize.STANDARD,
//     listener: (result, value) {
//       print("Banner Ad: $result -->  $value");
//     },
//   );
//   emit(ChangeCurrentAd());
// }
}
