import 'package:flutter/material.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/outlined_form_icon_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';

class TaskBottomSheet extends StatelessWidget{

  TaskBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputHeader("Task"),
          RoundedTextFormField("Task title"),

          FormInputHeader("Description"),
          RoundedTextFormField(
            "Description",
            textInputType: TextInputType.multiline,
            maxLines: 3,
            textInputAction: TextInputAction.newline
          ),

          FormInputHeader("Choose date & time"),

          Row(
            children: [
              Expanded(
                child: OutlinedFormIconButton(
                  icon: Icons.event_rounded,
                  text: "Select a date",
                  onPressed: () {}
                ),
              ),

              SizedBox(width: 12.0),

              Expanded(
                child: OutlinedFormIconButton(
                  icon: Icons.watch_later_rounded,
                  text: "Select Time",
                  onPressed: () {}
                ),
              ),
            ],
          ),

          SizedBox(height: 48.0),

          RoundedButton(
            width: double.infinity,
            child: Text(
              "Done",
              style: cTitleTextStyle,
            ),
            onPressed: () => Navigator.of(context).pop()
          ),
        ],
      ),
    );
  }
}