import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lovestories/layout/cubit/lovecubit.dart';
import 'package:lovestories/layout/cubit/lovestates.dart';
import 'package:lovestories/shared/componanets/componanets.dart';

import 'articles_titles_list.dart';

class UserLoveStories extends StatelessWidget {
  const UserLoveStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoveCubit, LoveStates>(
      listener: (context, state){
      },
      builder: (context, state){
        LoveCubit cubit = LoveCubit.get(context);
        int width = MediaQuery.of(context).size.width.round();
        int height = MediaQuery.of(context).size.height.round();
        LoveCubit _cubit = LoveCubit.get(context);
        print(_cubit.storiesList.length);
        print(_cubit.index);
        return WillPopScope(
            onWillPop:  () async {
              //cubit.changeWidgetIndex(index: 0);
              return true;
            },
            child: ArticleTitlesList(storiesList: _cubit.storiesList,height: height, context: context, cubit: cubit,));
      },
    );
  }
}
