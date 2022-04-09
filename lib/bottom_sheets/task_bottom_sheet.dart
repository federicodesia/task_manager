import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
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
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/theme/theme.dart';

import 'modal_bottom_sheet.dart';

class TaskBottomSheet{

  final BuildContext context;
  final Task? editTask;
  final DateTime? initialDate;
  final String? initialcategoryId;

  TaskBottomSheet(
    this.context,
    {
      this.editTask,
      this.initialDate,
      this.initialcategoryId
    }
  );

  void show(){
    ModalBottomSheet(
      title: editTask != null
        ? context.l10n.bottomSheet_editTask
        : context.l10n.bottomSheet_createTask, 
      context: context, 
      content: _TaskBottomSheet(this)
    ).show();
  }
}

class _TaskBottomSheet extends StatefulWidget{
  
  final TaskBottomSheet data;
  const _TaskBottomSheet(this.data);

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<_TaskBottomSheet>{

  late Task? editTask = widget.data.editTask;

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
            padding: const EdgeInsets.symmetric(horizontal: cPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  FormInputHeader(context.l10n.task),
                  RoundedTextFormField(
                    hintText: context.l10n.task,
                    initialValue: title,
                    onChanged: (value) => title = value,
                    validator: (value) {
                      value = value ?? "";
                      if(value.isEmpty) return context.l10n.error_enterTitle;
                      if(value.length > 30) return context.l10n.error_maxLength(30);
                      return null;
                    },
                  ),

                  FormInputHeader(context.l10n.description),
                  RoundedTextFormField(
                    hintText: context.l10n.description,
                    initialValue: description,
                    onChanged: (value) => description = value,
                    textInputType: TextInputType.multiline,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    validator: (value){
                      value = value ?? "";
                      if(value.length > 60) return context.l10n.error_maxLength(60);
                      return null;
                    },
                  ),

                  FormInputHeader(context.l10n.chooseDateTime),
                  const SizedBox(height: 4.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FormValidator(
                          widget: (state) => OutlinedFormIconButton(
                            icon: Icons.event_rounded,
                            text: date == null
                              ? context.l10n.selectDate_button
                              : date!.format(context, "dd/MM/yyyy"),
                            outlineColor: state.hasError ? themeData.errorColor : null,
                            expand: true,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              DatePickerBottomSheet(
                                context,
                                initialDate: date ?? DateTime.now(),
                                onDateChanged: (value) => date = value,
                              ).show();
                            }
                          ),
                          validator: (value){
                            if(date == null) return context.l10n.error_selectDate;
                            return null;
                          }
                        )
                      ),
                      const SizedBox(width: 12.0),

                      Expanded(
                        child: FormValidator(
                          widget: (state) => OutlinedFormIconButton(
                            icon: Icons.watch_later_rounded,
                            text: time == null
                              ? context.l10n.selectTime_button
                              : time!.format(context, "HH:mm a"),
                            outlineColor: state.hasError ? themeData.errorColor : null,
                            expand: true,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              TimePickerBottomSheet(
                                context,
                                initialTime: Duration(
                                  hours: time != null ? time!.hour : DateTime.now().hour,
                                  minutes: time != null ? time!.minute : DateTime.now().minute,
                                ),
                                onTimeChanged: (duration) => time = DateTime.now().copyWith(
                                  hour: duration.inHours,
                                  minute: duration.inMinutes.remainder(60)
                                )
                              ).show();
                            }
                          ),
                          validator: (value){
                            if(time == null) return context.l10n.error_selectTime;
                            return null;
                          }
                        )
                      ),
                    ],
                  ),

                  FormInputHeader(context.l10n.category),
                  const SizedBox(height: 4.0),
              ],
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: cPadding),
              child: Row(
                children: [

                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (_, categoryState){
                      final categories = categoryState.categories.where((category) => !category.isGeneral).toList();

                      return Row(
                        children: List.generate(categories.length, (index){
                          Category category = categories[index];
                          bool isSelected = categoryId == category.id;

                          return AnimatedChip(
                            text: category.name,
                            textColor: isSelected ? category.color : null,
                            backgroundColor: isSelected ? Color.alphaBlend(
                              category.color.withOpacity(0.1),
                              customTheme.backgroundColor
                            ) : null,
                            isLastItem: false,
                            onTap: () {
                              setState(() {
                                categoryId = category.id == categoryId ? null : category.id;
                              });
                            }
                          );
                        }),
                      );
                    }
                  ),

                  OutlinedFormIconButton(
                    text: context.l10n.addNewCategory_button,
                    icon: Icons.add_rounded,
                    onPressed: () => CategoryBottomSheet(context).show()
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: cPadding),
            child: RoundedTextButton(
              text: context.l10n.done_button,
              onPressed: (){

                if(formKey.currentState!.validate()){
                  formKey.currentState!.save();

                  final dateTime = date?.copyWith(
                    hour: time?.hour,
                    minute: time?.minute,
                  );

                  if(dateTime != null){
                    if(editTask != null) {
                      context.read<TaskBloc>().add(TaskUpdated(editTask!.copyWith(
                        categoryId: categoryId,
                        title: title,
                        description: description,
                        date: dateTime
                      )));
                    }
                    else {
                      context.read<TaskBloc>().add(TaskAdded(Task.create(
                        categoryId: categoryId,
                        title: title,
                        description: description,
                        date: dateTime
                      )));
                    }
                  }
                  
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