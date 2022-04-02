import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/shared/componanets/componanets.dart';

class CreateStory extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  CreateStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state){},
      builder: (context, state){
        LoveCubit _cubit = LoveCubit.get(context);
        double hie = MediaQuery.of(context).size.height;
        //print('20 ========== ${_cubit.createTitleStoryController.text}');
        return Scaffold(
      backgroundColor: Colors.grey.shade200,
          appBar:  appBarLife(title: 'أكتب قصة', context: context, cubit: _cubit,elevation: 1, evButton: Container(
              width: 100,
              height: 10,
             // color: Colors.blue,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    String _str = _cubit.createStoryController.text;
                   String _title =  _cubit.createTitleStoryController.text;
                      _str = handleText(_str);
                      _title = handleText(_title);

                    _cubit.createNewStory(str: _str, title: _title,collection: _cubit.collection);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                      return LoveLayout();
                    }), (route) => false);
                  }
                },
                child: Container(
                   width: 69,
                    height: 40,
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Text('نشر')),
              ))),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('اخفاء الاسم'),
                        Checkbox(
                            value: _cubit.checkBox,
                            onChanged: (value){
                              // print(_cubit.createTitleStoryController.text);
                              // print(_cubit.createStoryController.text);
                              _cubit.checkBoxChangeState(value: value! );
                             // print(_cubit.createTitleStoryController.text);
                            })
                      ],
                    ),
                    TextFormField(
                      maxLength: 22,
                      minLines: 1,

                      decoration: const InputDecoration
                        (
                        label: Text('عنوان القصة')
                      )
                      ,controller: _cubit.createTitleStoryController,
                      validator: (value) {
                        value = value!.trim();
                        if (value.contains('  ')) {
                          value = value.replaceAll('  ', ' ');
                        }
                        if (value.isEmpty) {
                          return 'أدخل عنوان صحيح';
                        }
                        return null;
                      },
                    ),
                    Container(
                      height:  hie/1.7,
                      child: TextFormField(
                        maxLines: 14,
                        maxLength: 5000,
                        decoration: const InputDecoration
                          (
                            label: Text('أكتب قصتك هنا'),

                        ),
                        controller: _cubit.createStoryController,
                        //maxLines: 150,

                        validator: (value) {
                          value = value!.trim();
                          if (value.contains('  ')) {
                            value = value.replaceAll('  ', ' ');
                          }
                          if (value.isEmpty) {
                            return 'أدخل بيانات صحيحة';
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),

                      child:Column(
                        children: [
                          Text(_cubit.collection.toString(), style: TextStyle(fontSize: 8),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
