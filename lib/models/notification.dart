class NotifModel{

  String?  _storyId , _title , _body ,_notifId, _senderId, _senderName, _senderPic, _token , _receivedName, _receivedId, _time;
  bool _readable = false;
  int?  _collection;
  get notifId => _notifId;

  set notifId(value) {
    _notifId = value;
  }

  bool get readable => _readable;

  set readable(bool value) {
    _readable = value;
  }

  get title => _title;

  String get storyId => _storyId!;

  NotifModel({
    required String title ,required String body, required String senderId,
    required String senderName, required String senderPic, required String token,
    required String receivedName, required String receivedId, required String time,
  required String storyId , required int collection
  }){
    _title = title;
    _body = body;
    _senderId = senderId;
    _senderName = senderName;
    _senderPic = senderPic;
    _token = token;
    _receivedName = receivedName;
    _receivedId = receivedId;
    _time = time;
    _storyId = storyId;
    _collection = collection;

  }

  NotifModel.fromJson(Map<String, dynamic> json){
    _title = json['title'];
    _body = json['body'];
    _senderId = json['senderId'];
    _senderName = json['senderName'];
    _senderPic = json['senderPic'];
    _token = json['token'];
    _receivedName = json['receivedName'];
    _receivedId = json['receivedId'];
    _time = json['time'];
    _storyId = json['storyId'];
    _collection = json['collection'];
    _readable = json['readable'];
  }

  Map<String , dynamic> toMap(){
    return {
      'title' :  _title,
      'body' : _body,
      'senderId' : _senderId,
      'senderName' : _senderName,
      'senderPic' : _senderPic,
      'token' : _token,
      'receivedName' : _receivedName,
      'receivedId' : _receivedId,
      'time' : _time,
      'storyId' : _storyId,
      'collection' : _collection,
      'readable' : _readable
    };
  }

  get body => _body;

  get senderId => _senderId;

  get senderName => _senderName;

  get senderPic => _senderPic;

  get token => _token;

  get receivedName => _receivedName;

  get receivedId => _receivedId;

  get time => _time;

  int get collection => _collection!;
}