import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/models/stories_model.dart';
import 'package:lovestories/shared/componanets/componanets.dart';

import 'artical/artical.dart';
import 'articles_titles_list.dart';
import 'notification/cubit/cubit.dart';

class AllArticlesScreen extends StatelessWidget {
  const AllArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state){
        print('state');
        print(state.toString());
      },
      builder: (context, state){
        LoveCubit _cubit = LoveCubit.get(context);
        int width = MediaQuery.of(context).size.width.round();
        int height = MediaQuery.of(context).size.height.round();
    //    List<StoryModel> _storiesList = [];
//print(_cubit.yaserStoriesList.length);
  //      print(_cubit.index);
        return WillPopScope(
            onWillPop:  () async {
             //_cubit.changeWidgetIndex(index: 0);
              return true;
            },
            child: ArticleTitlesList( storiesList: _cubit.yaserStoriesList ,height: height, context: context, cubit: _cubit));
      },
    );
  }

}
