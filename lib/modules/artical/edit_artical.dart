import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/layout/love_layout.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/shared/componanets/componanets.dart';


class ArticleEdit extends StatefulWidget {
  String? text;

   ArticleEdit({Key? key, this.text}) : super(key: key);

  @override
  State<ArticleEdit> createState() => _ArticleEditState();
}

class _ArticleEditState extends State<ArticleEdit> {
  final _formKey = GlobalKey<FormState>();


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose');

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state){

      },
      builder: (context, state){
        LoveCubit _cubit = LoveCubit.get(context);
        double hie = MediaQuery.of(context).size.height;
        //////////////////////// must change later //////////////////
        //////////////////////// must change later //////////////////


        List<StoryModel> _article =[];
        if(_cubit.widgetIndex ==0){
          // print('////////////// ////////////// ///////// ${_cubit.index}');

          _article =  LoveCubit.get(context).yaserStoriesList;
          widget.text = _article[_cubit.index].text.replaceAll('/n', '\n\n');

          print('article.length === ${_article.length}');

        }else{
          _article = LoveCubit.get(context).storiesList;
          widget.text = _article[_cubit.index].text.replaceAll('/n', '\n\n');
        }
        // List<StoryModel> _article = LoveCubit.get(context).storiesList ;
        if(_cubit.articleEditingController.text==''){

          _cubit.articleEditingController.text = _article[_cubit.index].text.replaceAll('/n', '\n\n');
          _cubit.articleTitleEditingController.text = _article[_cubit.index].title;
        }


        return WillPopScope(
          onWillPop:  () async {
            print('will');

            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white.withOpacity(0.9),
            appBar: appBarLife(title: 'تعديل قصة', context: context, cubit: _cubit,elevation: 1,
                evButton: Container(
                width: 100,
                height: 10,
                // color: Colors.blue,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      String str = _cubit.articleEditingController.text;
                      String title = _cubit.articleTitleEditingController.text;

                        str = handleText(str);
                      title = handleText(title);

                      _cubit.storiesUpdate( story : _article[_cubit.index] ,str: str, context: context, title:  title,  );

                    }
                  },
                  child: Container(
                      width: 69,
                      height: 40,
                      alignment: Alignment.center,
                      color: Colors.blue,
                      child: Text('تعديل')),
                ))
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      TextFormField(
                        maxLength: 22,
                        minLines: 1,

                        decoration: const InputDecoration
                          (
                            label: Text('عنوان القصة')
                        )
                        ,controller: _cubit.articleTitleEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ' أدخل عنوان صحيح';
                          }
                          return null;
                        },
                      ),
                      Container(
                     height:  hie/1.7,
                        child: TextFormField(
                          maxLines: 50,
                          maxLength: 7000,
                          decoration: const InputDecoration
                            (
                            label: Text('أكتب قصتك هنا'),

                          ),
                          controller: _cubit.articleEditingController,
                          //maxLines: 150,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'أدخل بيانات صحيحة';
                            }
                            return null;
                          },
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



