import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/outlined_form_icon_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';

class TaskBottomSheet extends StatefulWidget{
  final Task? editTask;

  TaskBottomSheet({this.editTask});

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.editTask != null;

  late String _title = _isEditing ? widget.editTask!.title : "";
  late String _description = _isEditing ? widget.editTask!.description : "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputHeader("Task"),
          RoundedTextFormField(
            label: "Task title",
            initialValue: _title,
            validator: (value){
              if (value == null || value.isEmpty) return "Please enter a title";
              return null;
            },
            onSaved: (value){
              _title = value!;
            },
          ),

          FormInputHeader("Description"),
          RoundedTextFormField(
            label: "Description",
            initialValue: _description,
            textInputType: TextInputType.multiline,
            maxLines: 3,
            textInputAction: TextInputAction.newline,
            onSaved: (value){
              _description = value!;
            },
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
            onPressed: (){
              if (_formKey.currentState!.validate()){
                _formKey.currentState!.save();

                Task _task = Task(_title, _description, DateTime.now());

                if(widget.editTask != null) BlocProvider.of<TaskBloc>(context).add(TaskUpdated(
                  oldTask: widget.editTask!,
                  taskUpdated: _task
                ));
                else BlocProvider.of<TaskBloc>(context).add(TaskAdded(_task));
                
                Navigator.pop(context);
              }
            }
          ),
        ],
      ),
    );
  }
}