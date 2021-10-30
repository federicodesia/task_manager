import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/cubits/main_context_cubit.dart';

class ModalBottomSheet{

  final String title;
  final BuildContext context;
  final Widget content;

  ModalBottomSheet({
    required this.title,
    required this.context,
    required this.content
  });

  void show(){
    BuildContext mainContext = BlocProvider.of<MainContextCubit>(context).state!;

    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black26,
      backgroundColor: cBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cBottomSheetBorderRadius),
          topRight: Radius.circular(cBottomSheetBorderRadius)
        ),
      ),
      context: mainContext,
      builder: (context){
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(cPadding, 16.0, cPadding, cPadding),
            child: Column(
              children: [
                Container(
                  height: 4.0,
                  width: 48.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2E3D),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                ),

                SizedBox(height: 16.0),

                Text(
                  title,
                  style: cTitleTextStyle,
                ),

                content,
                SizedBox(height: 8.0),
              ],
            ),
          )
        );
      }
    );
  }
}