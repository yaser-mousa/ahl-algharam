



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/shared/componanets/componanets.dart';





class MyHomePageVir extends StatefulWidget {
  @override
  _MyHomePageVirState createState() => _MyHomePageVirState();
}

class _MyHomePageVirState extends State<MyHomePageVir> {
  bool _onEditing = true;
  String? _code;
  var _message;

 final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit,LoveStates>(
      listener:  (context, state){
       // LoveCubit.get(context).saraFont ='';
        if(state is CodeNotCorrect){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content:Text('الرمز غير صحيح'),
              duration: Duration(seconds: 3),));

          setState(() {
            _message = 'الرمز غير صحيح، أعد ادخال الرمز';
          });
        }
      }
      ,builder: (context, state){
    // print( FirebaseAuth.instance.currentUser!.uid);


     final  LoveCubit _cubit = LoveCubit.get(context);
    // print(_cubit.firstNameController.text + ' ' + _cubit.secondNameController.text);
    // print(_cubit.phoneNumber);


          return Scaffold(
            key: _scaffoldKey,

            appBar: appBarLife(context: context, cubit: _cubit, title: ''),


            body: SingleChildScrollView(
              child: Container(

                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'أدخل الرمز',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: VerificationCode(

                            itemSize: 40,
                            textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900], fontFamily: ''),
                            keyboardType: TextInputType.number,
                            // in case underline color is null it will use primaryColor: Colors.red from Theme
                            underlineColor: Colors.amber,
                            length: 6,
                            // clearAll is NOT required, you can delete it
                            // takes any widget, so you can implement your design
                            clearAll: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'حذف الكل',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue[700]),
                              ),
                            ),
                            onCompleted: (String value) {
                              setState(() {
                                _code = value;
                                _code = convertNumbers(_code!);
                                print('code is ${_code}');
                                _cubit.otpVerify(context: context , otp: _code!);
                              });
                            },
                            onEditing: (bool value) {
                              setState(() {
                                _onEditing = value;

                              });
                              if (!_onEditing) FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        if(_message !=null)
                          Text(_message, style: TextStyle(color: Colors.pink), ),

                        SizedBox(height: 60,),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('ان لم يصلك الرمز بعد مرور دقيقة يمكنك طلب اعادة الارسال أو عد للخلف وتحقق من رقمك', textAlign: TextAlign.center,),
                        ),

                      ElevatedButton(onPressed: (){
                        _cubit.verifyPhone();
                      }, child: Text('أعد الارسال')),

                      ],
                    ),
                    SizedBox(height: 180,),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: _onEditing
                            ? const Text('لو سمحت أدخل الرمز كاملا')
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('رمزك هو: '),
                                Text(convertNumbers(_code!), style: TextStyle(fontFamily: ''),)
                              ],
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        );
  }
}
