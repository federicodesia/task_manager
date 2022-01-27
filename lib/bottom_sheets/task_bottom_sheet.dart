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
import 'package:task_manager/theme/theme.dart';

import 'modal_bottom_sheet.dart';

class TaskBottomSheet extends StatefulWidget{
  
  final Task? editTask;
  final DateTime? initialDate;
  final String? initialcategoryId;

  TaskBottomSheet({
    this.editTask,
    this.initialDate,
    this.initialcategoryId
  });

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet>{

  late Task? editTask = widget.editTask;

  late String title = editTask != null ? editTask!.title : "";
  late String description = editTask != null ? editTask!.description : "";
  late DateTime? date = editTask != null ? editTask!.date : null;
  late DateTime? time = editTask != null ? editTask!.date : null;
  late String? categoryId = editTask != null ? editTask!.categoryId : null;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final customTheme = Theme.of(context).customTheme;

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
                    hintText: "Task title",
                    initialValue: title,
                    onChanged: (value) => title = value,
                    validator: (value) {
                      value = value ?? "";
                      if(value.isEmpty) return "Please enter a title";
                      if(value.length > 30) return "Maximum 30 characters";
                      return null;
                    },
                  ),

                  FormInputHeader("Description"),
                  RoundedTextFormField(
                    hintText: "Description",
                    initialValue: description,
                    onChanged: (value) => description = value,
                    textInputType: TextInputType.multiline,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
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
                            text: date == null ? "Select a date" : DateFormat("dd/MM/yyyy").format(date!),
                            outlineColor: state.hasError ? themeData.errorColor : null,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              ModalBottomSheet(
                                context: context,
                                title: "Select a date",
                                content: DatePickerBottomSheet(
                                  initialDate: date ?? DateTime.now(),
                                  onDateChanged: (value) => date = value,
                                )
                              ).show();
                            }
                          ),
                          validator: (value){
                            if(date == null) return "Please select a date";
                            return null;
                          }
                        )
                      ),
                      SizedBox(width: 12.0),

                      Expanded(
                        child: FormValidator(
                          widget: (state) => OutlinedFormIconButton(
                            icon: Icons.watch_later_rounded,
                            text: time == null ? "Select a time" : DateFormat("HH:mm a").format(time!),
                            outlineColor: state.hasError ? themeData.errorColor : null,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              ModalBottomSheet(
                                context: context,
                                title: "Select Time",
                                content: TimePickerBottomSheet(
                                  initialTime: Duration(
                                    hours: time != null ? time!.hour : DateTime.now().hour,
                                    minutes: time != null ? time!.minute : DateTime.now().minute,
                                  ),
                                  onTimeChanged: (duration) => time = copyDateTimeWith(
                                    time != null ? time! : DateTime.now(),
                                    hour: duration.inHours,
                                    minute: duration.inMinutes.remainder(60)
                                  ),
                                )
                              ).show();
                            }
                          ),
                          validator: (value){
                            if(time == null) return "Please select a time";
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
                        bool isSelected = categoryId == category.id;
                        bool isLastItem = index == categories.length - 1;

                        return AnimatedChip(
                          text: category.name,
                          textColor: isSelected ? category.color : null,
                          backgroundColor: isSelected ? Color.alphaBlend(
                            category.color.withOpacity(0.1),
                            customTheme.backgroundColor
                          ) : null,
                          isLastItem: isLastItem,
                          onTap: () {
                            setState(() {
                              if(category.id == categoryId) categoryId = null;
                              else categoryId = category.id;
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
                style: customTheme.primaryColorButtonTextStyle,
              ),
              onPressed: (){

                if(formKey.currentState!.validate()){
                  formKey.currentState!.save();

                  if(editTask != null) context.read<TaskBloc>().add(TaskUpdated(editTask!.copyWith(
                    categoryId: categoryId,
                    title: title,
                    description: description,
                    date: date
                  )));
                  else context.read<TaskBloc>().add(TaskAdded(Task(
                    categoryId: categoryId,
                    title: title,
                    description: description,
                    date: date!
                  )));
                  
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