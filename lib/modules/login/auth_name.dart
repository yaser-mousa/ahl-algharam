import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/modules/login/OTPcontroller.dart';
import 'package:lovestories/shared/componanets/componanets.dart';

class AuthName extends StatefulWidget {
   AuthName({Key? key}) : super(key: key);

  @override
  State<AuthName> createState() => _AuthNameState();
}

class _AuthNameState extends State<AuthName> {
  final   _formKey = GlobalKey<FormState>();
  String _phoneNum='';

  String? str;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>
      (
        listener: (context, state){},
        builder: (context, state){
          final LoveCubit _cubit = LoveCubit.get(context);
        return Scaffold(
          appBar: appBarLife(context: context, cubit: _cubit, title: 'تسجيل' ),
          body: SingleChildScrollView(
            child: Form(
              key:  _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _cubit.firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'أدخل الاسم الأول'
                    ),
                    validator: (value){
                        value = value!.trim();

                        if(value.isEmpty ){
                          return 'أدخل اسم صحيح';
                        }
                        else if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)){
                          return 'أدخل اسم صحيح';
                        }else if(value.contains(' ')){
                          return 'أدخل اسم صحيح';
                        }


                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _cubit.secondNameController,
                    decoration: const InputDecoration(
                        labelText: 'أدخل الاسم الثاني',

                    ),
                    validator: (value){
                    value = value!.trim();
                      if(value.isEmpty ){
                        return 'أدخل اسم صحيح';
                      }

                      else if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)){
                        return 'أدخل اسم صحيح';
                      }else if(value.contains(' ')){
                        return 'أدخل اسم صحيح';
                      }
                    },

                  ),


                  const SizedBox(height: 20,),

                  Row(
                   // mainAxisSize: MainAxisSize.max,
                    children: [


                      Expanded(

                        child: Container(
                          child: TextFormField(

                          //  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                           textDirection: TextDirection.ltr,
                             style: TextStyle(fontFamily: ''),
                            keyboardType: TextInputType.phone,
                            maxLength: 12 ,

                            controller: _cubit.phoneController,
                            onChanged: (value){
                              setState(() {
                                _phoneNum = _cubit.phoneController.text;
                              });
                            },
                            decoration:   InputDecoration(

                              labelText: 'أدخل رقم الهاتف',

                           suffix: CountryCodePicker(
                             onChanged: (country){
                               print('country is $country');
                               print(country.dialCode);
                               _cubit.setCountry(country: country.dialCode!);
                             },
                             dialogBackgroundColor: Color(0xffF7DCEC),
                             showOnlyCountryWhenClosed: false,
                             showCountryOnly: false,
                             // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                             initialSelection: 'JO',
                             favorite: ['+962',    '+963' , '+20',  '+213',  '+970'],

                             // flag can be styled with BoxDecoration's `borderRadius` and `shape` fields
                             flagDecoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(7),
                             ),
                           ),


                           //


                            ),

                            validator: (value){
                              value = value!.trim();
                              if(value.isEmpty ){
                                String st = _cubit.country;

                                return 'أدخل رقم صحيح';

                              }

                              else if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%a-z-A-Z]').hasMatch(value)){
                                return 'أدخل رقم صحيح';
                              }else if(value.contains(' ')){
                                return 'أدخل اسم صحيح';
                              }
                            },

                          ),

                        ),

                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  if(_cubit.phoneController!=null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(child: const Text('رقمك هو:  ',style: TextStyle(color: Colors.teal),)),
                      Text('${_cubit.country +convertNumbers( _phoneNum)}',style: TextStyle(fontFamily: '', color:  Colors.teal),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          //_cubit.justChangeState();
                            print('${_cubit.country}${convertNumbers(_cubit.phoneController.text)}');
                            _cubit.verifyPhone(phone: '${_cubit.country}${convertNumbers( _cubit.phoneController.text)}');
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePageVir()));

                        }

                      },

                      child: const Text('التالي'),
                  )
                ],),
              ),
            ),
          ),
        );
    },

       );
  }


}
