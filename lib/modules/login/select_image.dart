import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';

class SelectImage extends StatefulWidget {
  const SelectImage({Key? key}) : super(key: key);

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
        listener: (con, st){


        if(st is CreateUserSuccessDataState){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
            return LoveLayout();
          }), (route) => false);
        }

        if(st is CreateUserErrorDataState){
          Fluttertoast.showToast(
              msg: "هنالك خطأ في عملية التسجيل. حاول من جديد",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }


        },
      builder: (con, st){
          final LoveCubit _cubit = LoveCubit.get(context);
          var wid = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: appBarLife(context: context, cubit: _cubit, title: 'الخطوة الأخيرة'),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(

              children: [
                if(st is UploadProfileImageLoadingState)
                  const LinearProgressIndicator(),
                const Text('أضف صورة شخصية من فضلك'),
                const SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: (){
                  _cubit.getProfileImage();
                }, child:const Text('إضافة')),
                const SizedBox(height: 200,),
                if(_cubit.profileImage !=null)
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.file(_cubit.profileImage!)),
                if(_cubit.profileImage !=null)
                SizedBox(

                    width: wid * 0.5,
                    child: ElevatedButton(
                        onPressed: (){
                          _cubit.uploadProfileImage();
                        },
                        child: const Text('التالي')))
              ],
            ),
          ),
        ) ,
      );
    }, );
  }
}
