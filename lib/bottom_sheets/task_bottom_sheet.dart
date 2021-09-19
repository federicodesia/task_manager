import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/outlined_form_icon_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';

import 'modal_bottom_sheet.dart';

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
  late DateTime? _date = _isEditing ? widget.editTask!.dateTime : null;
  late DateTime? _time = _isEditing ? widget.editTask!.dateTime : null;
  

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

          FormField(
            initialValue: true,
            builder: (FormFieldState<bool> state){
              ThemeData themeData = Theme.of(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedFormIconButton(
                          icon: Icons.event_rounded,
                          text: _date == null ? "Select a date" : DateFormat("dd/MM/yyyy").format(_date!),
                          onPressed: () {

                            ModalBottomSheet(
                              context: context,
                              title: "Select a date",
                              content: Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: cPrimaryColor,
                                    surface: cBackgroundColor,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: cPadding),
                                      child: CalendarDatePicker(
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                        lastDate: DateTime.now().add(Duration(days: 365)),
                                        onDateChanged: (date) {
                                          state.didChange(true);
                                          setState(() => _date = date);
                                        },
                                      ),
                                    ),
                                    RoundedButton(
                                      width: double.infinity,
                                      child: Text(
                                        "Select",
                                        style: cTitleTextStyle,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                )
                              )
                            ).show();
                          }
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

                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.centerLeft,
                    crossFadeState: state.hasError ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    firstChild: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 16.0
                      ),
                      child: Text(
                        state.errorText.toString(),
                        textAlign: TextAlign.center,
                        style: themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    secondChild: Container(),
                  )
                ],
              );
            },
            validator: (value){
              if(_date == null && _time == null) return "Please select a date and time";
              else if(_date == null) return "Please select a date";
              else if(_time == null) return "Please select a time";
            },
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