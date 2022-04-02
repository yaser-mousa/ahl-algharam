

class UserModel{
  UserModel();
  String? _name , _userUid, _phoneNumber, _picImage, _token;

  get picImage => _picImage;

  set picImage(value) {
    _picImage = value;
  }

  UserModel.setValues({required String? name, String? userUid, String? phonNumber, String? picImage,required String? token}){
    _name = name;
   // _userUid = userUid;
    _phoneNumber = phonNumber;
    _picImage = picImage;
    _token = token;
  }

  UserModel.fromJson(Map<String, dynamic> json){
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _picImage =json['picImage'];
    _token =json['token'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map ={};
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['picImage'] =  _picImage;
    map['token'] = _token;
    //map['userUid'] = _userUid;
    return map;
  }

  get token => _token;

  get userUid => _userUid;

  set userUid(value) {
    _userUid = value;
  }

  get phoneNumber => _phoneNumber;

  set phoneNumber(value) {
    _phoneNumber = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }
}