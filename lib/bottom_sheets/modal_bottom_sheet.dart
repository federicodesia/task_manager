import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

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

    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: cModalBottomSheetBarrierColor,
      backgroundColor: cBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cBottomSheetBorderRadius),
          topRight: Radius.circular(cBottomSheetBorderRadius)
        ),
      ),
      context: context,
      builder: (context){
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.95
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 16.0, 0, cPadding),
            child: Column(
              children: [
                Container(
                  height: 4.0,
                  width: 48.0,
                  decoration: BoxDecoration(
                    color: cModalBottomSheetColorIndicator,
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