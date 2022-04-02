
class StoryModel {
  StoryModel();
  String? _text;
  String? _title;
  String? _time;
  String? _storyUid;
  String? _userName;
  String? _userUid;
  String? _userImage;
  List<String>_likesId=[];
  String? _token;
  bool? _checkBox ;
  int _likes =0;
  int? _comments;

  String get userImage => _userImage!;

  set userImage(String value) {
    _userImage = value;
  }

  String get userName => _userName!;

  set userName(String value) {
    _userName = value;
  }



  StoryModel.setValues({required bool checkBox, required int likes ,required String token ,required String title,required String time,required String image,required String  text ,required String userName,required String userUid,}){
    _title = title;
    _time = time;
    _userImage = image;
    _text = text;
    _userName = userName;
    _userUid =  userUid;
    _token = token;
    _likes = likes;
    _checkBox = checkBox;
  }

  String get storyUid => _storyUid!;

  set storyUid(String value) {
    _storyUid = value;
  }

  String get text => _text!;
  String get title => _title!;
  String get time => _time!;

  String get image => _userImage!;

  set text(String? text){
    _text = text;
  }



  StoryModel.fromJson(Map<String, dynamic> json) {
    _text = json['text'];
    _title = json['title'];
    _time = json['time'];
    _userImage = json['userImage'];
    _userName = json['userName'];
    _userUid = json['userUid'];
    _token = json['token'];
    _likes = json['likes'];
    _checkBox = json['checkBox'];
  }

  Map<String ,dynamic > toMap (){

    Map<String ,dynamic > myMap = {};

    myMap['text'] = text;
    myMap ['title'] = _title;
    myMap ['time'] = _time;
    myMap ['userImage'] = _userImage;
    myMap['userName'] = _userName;
    myMap['userUid'] = _userUid;
    myMap['token'] = _token;
    myMap['likes'] = _likes;
    myMap['checkBox'] = _checkBox;


    return myMap;

  }


  bool get checkBox => _checkBox!;

  set checkBox(bool value) {
    _checkBox = value;
  }

  int get likes => _likes;

  set likes(int value) {
    _likes = value;
  }

  String get token => _token!;

  String get userUid => _userUid!;

  int get comments => _comments!;

  set comments(int value) {
    _comments = value;
  }



  set userUid(String value) {
    _userUid = value;
  }

  List<String> get likesId => _likesId;

  set likesId(List<String> value) {
    _likesId = value;
  }
}
