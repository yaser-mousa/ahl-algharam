class ReplayModel {
  String? _repComment;
  String? _storyUid;
  String? _userUid;
  String? _userImage;
  String? _userName;
  String? _time;
  String? _commentId;
  String? _replayUid;
  bool _expandedRep = false;
  String? _token;


  bool get expandedRep => _expandedRep;

  set expandedRep(bool value) {
    _expandedRep = value;
  }

  String get replayUid => _replayUid!;

  set replayUid(String value) {
    _replayUid = value;
  }

  set repComment(String value) {
    _repComment = value;
  }

  set commentId(String value) {
    _commentId = value;
  }

  ReplayModel.setValues(
      {required String token ,required String commentId , required String storyUid ,required String repComment, required String userUid,required String image,required String name,required String time}){
    _repComment =repComment;
    _userUid = userUid;
    _userImage =image;
    _userName =name;
    _time = time;
    _storyUid = storyUid;
    _commentId = commentId;
    _token = token;
    // _commentId = commentId;
  }

  ReplayModel.fomJson(Map<String, dynamic> json) {
    _repComment = json['repComment'];
    _userUid = json['userUid'];
    _userImage = json['userImage'];
    _userName = json['userName'];
    // _commentId = json['comment_id'];
    _time = json['time'];
    _storyUid = json['storyUid'];
    _commentId = json['commentId'];
    _token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'repComment': _repComment,
      'userUid': _userUid,
      'userImage': _userImage,
      'userName': _userName,
      'time': _time,
      'storyUid' : _storyUid,
      'commentId' : _commentId,
      'token' : _token
      //"comment_id": _commentId
    };
  }


  String get token => _token!;

  String get repComment => _repComment!;

  String get commentId => _commentId!;

  String get time => _time!;

  String get userUid => _userUid!;

  String get storyUid => _storyUid!;

  String get userImage => _userImage!;

  String get userName => _userName!;
}