import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/date_picker_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/time_picker_bottom_sheet.dart';
import 'package:task_manager/components/animated_chip.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/forms/form_validator.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/outlined_form_icon_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:uuid/uuid.dart';

import 'modal_bottom_sheet.dart';

class TaskBottomSheet extends StatefulWidget{
  
  final Task? editTask;
  final DateTime? initialDate;
  final String? initialCategoryUuid;

  TaskBottomSheet({
    this.editTask,
    this.initialDate,
    this.initialCategoryUuid
  });

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet>{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool formValidated = false;

  late Task task = widget.editTask ?? Task(
    uuid: Uuid().v4(),
    date: widget.initialDate != null ? getDate(widget.initialDate!) : null,
    categoryUuid: widget.initialCategoryUuid
  );

  @override
  Widget build(BuildContext context) {

    ThemeData themeData = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: cPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  FormInputHeader("Task"),
                  RoundedTextFormField(
                    label: "Task title",
                    initialValue: task.title,
                    onChanged: (value){
                      task = task.copyWith(title: value);
                    },
                    validator: (value){
                      value = value ?? "";
                      if(value.isEmpty) return "Please enter a title";
                      if(value.length > 30) return "Maximum 30 characters";
                      return null;
                    },
                  ),

                  FormInputHeader("Description"),
                  RoundedTextFormField(
                    label: "Description",
                    initialValue: task.description,
                    textInputType: TextInputType.multiline,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    onChanged: (value){
                      task = task.copyWith(description: value);
                    },
                    validator: (value){
                      value = value ?? "";
                      if(value.length > 60) return "Maximum 60 characters";
                      return null;
                    },
                  ),

                  FormInputHeader("Choose date & time"),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FormValidator(
                          widget: (state) => OutlinedFormIconButton(
                            icon: Icons.event_rounded,
                            text: task.date == null ? "Select a date" : DateFormat("dd/MM/yyyy").format(task.date!),
                            outlineColor: state.hasError ? themeData.errorColor : null,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              ModalBottomSheet(
                                context: context,
                                title: "Select a date",
                                content: DatePickerBottomSheet(
                                  initialDate: task.date ?? DateTime.now(),
                                  onDateChanged: (value){
                                    task = task.copyWith(date: value);
                                  },
                                )
                              ).show();
                            }
                          ),
                          validator: (value){
                            if(task.date == null) return "Please select a date";
                            return null;
                          }
                        )
                      ),
                      SizedBox(width: 12.0),

                      Expanded(
                        child: FormValidator(
                          widget: (state) => OutlinedFormIconButton(
                            icon: Icons.watch_later_rounded,
                            text: task.time == null ? "Select a time" : DateFormat("HH:mm a").format(task.time!),
                            outlineColor: state.hasError ? themeData.errorColor : null,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              ModalBottomSheet(
                                context: context,
                                title: "Select Time",
                                content: TimePickerBottomSheet(
                                  initialTime: Duration(
                                    hours: task.time != null ? task.time!.hour : DateTime.now().hour,
                                    minutes: task.time != null ? task.time!.minute : DateTime.now().minute,
                                  ),
                                  onTimeChanged: (duration){
                                    task = task.copyWith(
                                      time: copyDateTimeWith(
                                        DateTime.now(),
                                        hour: duration.inHours,
                                        minute: duration.inMinutes.remainder(60)
                                      )
                                    );
                                  },
                                )
                              ).show();
                            }
                          ),
                          validator: (value){
                            if(task.time == null) return "Please select a time";
                            return null;
                          }
                        )
                      ),
                    ],
                  ),

                  FormInputHeader("Category"),
                  SizedBox(height: 4.0),
              ],
            ),
          ),

          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (_, categoryState){
              if(categoryState is CategoryLoadSuccess){
                List<Category> categories = categoryState.categories.where((category) => !category.isGeneral).toList();

                return Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: cPadding),
                    child: Row(
                      children: List.generate(categories.length, (index){
                        Category category = categories[index];
                        bool isSelected = task.categoryUuid == category.uuid;
                        bool isLastItem = index == categories.length - 1;

                        return AnimatedChip(
                          text: category.name,
                          textColor: isSelected ? category.color : null,
                          backgroundColor: isSelected ? Color.alphaBlend(
                            category.color.withOpacity(0.1),
                            cBackgroundColor
                          ) : null,
                          isLastItem: isLastItem,
                          onTap: () {
                            setState(() {
                              if(category.uuid == task.categoryUuid) task = task.copyWith(categoryUuid: null);
                              else task = task.copyWith(categoryUuid: category.uuid);
                            });
                          }
                        );
                      }),
                    ),
                  ),
                );
              }
              return Container();
            }
          ),

          SizedBox(height: 48.0),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: cPadding),
            child: RoundedButton(
              width: double.infinity,
              child: Text(
                "Done",
                style: cSubtitleTextStyle,
              ),
              onPressed: (){
                setState(() => formValidated = true);
                if (formKey.currentState!.validate()){
                  formKey.currentState!.save();

                  if(widget.editTask != null) BlocProvider.of<TaskBloc>(context).add(TaskUpdated(task));
                  else BlocProvider.of<TaskBloc>(context).add(TaskAdded(task));
                  
                  Navigator.pop(context);
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}