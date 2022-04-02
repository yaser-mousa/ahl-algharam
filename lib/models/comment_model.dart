class CommentModel {
  String? _comment;
  String? _storyUid;
  String? _userUid;
  String? _userImage;
  String? _userName;
  String? _time;
  String? _commentId;
  String? _token;


  set comment(String value) {
    _comment = value;
  }

  set commentId(String value) {
    _commentId = value;
  }

  CommentModel.setValues(
      {required String token , required String storyUid ,required String comment, required String userUid,required String image,required String name,required String time}){
    _comment =comment;
    _userUid = userUid;
    _userImage =image;
    _userName =name;
    _time = time;
    _storyUid = storyUid;
    _token = token;
   // _commentId = commentId;
  }

  CommentModel.fomJson(Map<String, dynamic> json) {
    _comment = json['comment'];
    _userUid = json['userUid'];
    _userImage = json['userImage'];
    _userName = json['userName'];
   // _commentId = json['comment_id'];
     _time = json['time'];
    _storyUid = json['storyUid'];
    _token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': _comment,
      'userUid': _userUid,
      'userImage': _userImage,
      'userName': _userName,
      'time': _time,
      'storyUid' : _storyUid,
      'token' : _token,
      //"comment_id": _commentId
    };
  }


  String get token => _token!;

  String get comment => _comment!;

  String get commentId => _commentId!;

  String get time => _time!;

  String get userUid => _userUid!;

  String get storyUid => _storyUid!;

  String get userImage => _userImage!;

  String get userName => _userName!;
}