import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/animated_chip.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';

class ResultsBottomSheet extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: cPadding),
          child: FormInputHeader("Task status"),
        ),
        SizedBox(height: 4.0),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: cPadding),
          child: Row(
            children: [
              AnimatedChip(
                text: "All",
                isLastItem: false
              ),

              AnimatedChip(
                text: "Completed",
                isLastItem: false
              ),

              AnimatedChip(
                text: "Uncompleted",
                isLastItem: true
              )
            ],
          )
        ),

        SizedBox(height: 32.0),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: cPadding),
          child: RoundedButton(
            width: double.infinity,
            child: Text(
              "Done",
              style: cSubtitleTextStyle,
            ),
            onPressed: () => Navigator.pop(context)
          ),
        )
      ],
    );
  }
}