import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/date_picker_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/time_picker_bottom_sheet.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/forms/form_validator.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/outlined_form_icon_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:uuid/uuid.dart';

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

  late String _uuid = _isEditing ? widget.editTask!.uuid : Uuid().v4();

  late String _title = _isEditing ? widget.editTask!.title : "";
  late String? _description = _isEditing ? widget.editTask!.description : "";

  late bool _dateState = true;
  late DateTime? _date = _isEditing ? widget.editTask!.dateTime : null;
  
  late bool _timeState = true;
  late DateTime? _time = _isEditing ? widget.editTask!.dateTime : null;
  

  @override
  Widget build(BuildContext context) {

    ThemeData themeData = Theme.of(context);

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
              _description = value;
            },
          ),

          FormInputHeader("Choose date & time"),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormValidator(
                  widget: OutlinedFormIconButton(
                    icon: Icons.event_rounded,
                    text: _date == null ? "Select a date" : DateFormat("dd/MM/yyyy").format(_date!),
                    outlineColor: _dateState ? null : themeData.errorColor,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      ModalBottomSheet(
                        context: context,
                        title: "Select a date",
                        content: DatePickerBottomSheet(
                          initialDate: _date ?? DateTime.now(),
                          onDateChanged: (date){
                            setState(() => _date = date);
                          },
                        )
                      ).show();
                    }
                  ),
                  validator: (_){
                    setState(() => _dateState = _date != null);
                    if(_date == null) return "Please select a date";
                    return null;
                  }
                )
              ),
              SizedBox(width: 12.0),

              Expanded(
                child: FormValidator(
                  widget: OutlinedFormIconButton(
                    icon: Icons.watch_later_rounded,
                    text: _time == null ? "Select Time" : DateFormat("HH:mm a").format(_time!),
                    outlineColor: _timeState ? null : themeData.errorColor,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      ModalBottomSheet(
                        context: context,
                        title: "Select Time",
                        content: TimePickerBottomSheet(
                          initialTime: Duration(
                            hours: _time != null ? _time!.hour : DateTime.now().hour,
                            minutes: _time != null ? _time!.minute : DateTime.now().hour
                          ),
                          onTimeChanged: (duration){
                            setState((){
                              _time = copyDateTimeWith(
                                DateTime.now(),
                                hour: duration.inHours,
                                minute: duration.inMinutes.remainder(60)
                              );
                            });
                          },
                        )
                      ).show();
                    }
                  ),
                  validator: (_){
                    setState(() => _timeState = _time != null);
                    if(_time == null) return "Please select a time";
                    return null;
                  },
                )
              ),
            ],
          ),
          SizedBox(height: 48.0),

          RoundedButton(
            width: double.infinity,
            child: Text(
              "Done",
              style: cSubtitleTextStyle,
            ),
            onPressed: (){
              if (_formKey.currentState!.validate()){
                _formKey.currentState!.save();

                Task _task = Task(
                  uuid: _uuid,
                  title: _title,
                  description: _description,
                  dateTime: copyDateTimeWith(
                    _date!,
                    hour: _time!.hour,
                    minute: _time!.minute,
                  )
                );

                if(widget.editTask != null) BlocProvider.of<TaskBloc>(context).add(TaskUpdated(_task));
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