
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/modules/login/OTPcontroller.dart';
import 'package:lovestories/shared/cach_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatelessWidget {

LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state){},
        builder: (context, state){
        LoveCubit cubit = LoveCubit.get(context);
         print( 'token in login ${cubit.token}' );
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(

          appBar: AppBar(backgroundColor: Colors.pink,
          title: const Text('Login'),),
          // appBarCarizma(title : 'Login'),

          body: cubit.token ==null? loginBody(cubit: cubit,context: context) : logout(cubit: cubit),

        ),
      );
    }, );
  }
  Widget logout({required LoveCubit cubit}){
    return Center(
      child: MaterialButton(
        onPressed: (){
          cubit.logOutFirebase();
         // cubit.changeTokenState();
        },
        child: Text('Logout'),
      ),
    );
  }

  Widget loginBody({required LoveCubit cubit, required BuildContext context}){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(

        child: DefaultTextStyle(
          style: const TextStyle(
              fontFamily: 'katibeh'
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff6077B1), fontSize: 33),),
              const SizedBox(height: 30,),
              TextFormField(
                style: const TextStyle( fontFamily: 'katibeh'),
                controller: cubit.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff6077B1),),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),

                  ),
                  labelText: 'Phone Number',

                  // border: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 30,),

              // Container(
              //
              //   child: TextFormField(
              //     style: TextStyle( fontFamily: 'katibeh'),
              //     controller: cubit.passwordController,
              //     keyboardType: TextInputType.visiblePassword,
              //     obscureText: true,
              //     decoration: InputDecoration(
              //
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xff6077B1),),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       border: OutlineInputBorder(
              //         //borderSide: BorderSide(color: Colors.black),
              //         borderRadius: BorderRadius.circular(20),
              //
              //       ),
              //       labelText: 'Password',
              //
              //       // border: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 40,),
              MaterialButton(
                  color: const Color(0xff6077B1),
                  onPressed: ()async{
                    cubit.verifyPhone(phone: '${cubit.emailController.text}');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePageVir()));
                //  FirebaseAuth.instance.signOut();
              //cubit.signInWithEmailAndPassword();

              }, child: const Text('Welcome', style: TextStyle(color: Colors.white),)),
            ],),
        ),
      ),
    );
  }
  appBarCarizma({ @required String title=''}){
    return AppBar(
      title: Text(title, style: TextStyle(fontSize: 30, ),),
      elevation: 0,
      toolbarHeight: 70,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // systemNavigationBarColor: Colors.black54,
        //systemNavigationBarColor: Colors.white,
        statusBarColor:  Color(0xff613C7D),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
         color: Colors.pink
        ),
      ),);
  }
}




