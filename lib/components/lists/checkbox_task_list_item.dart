import 'package:flutter/material.dart';
import 'package:task_manager/components/shimmer/shimmer_text.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/theme/theme.dart';

class CheckboxTaskListItem extends StatelessWidget{

  final Task? task;
  final Function()? onPressed;
  final Function(bool?)? onChanged;
  final bool isShimmer;
  
  const CheckboxTaskListItem({
    Key? key, 
    this.task,
    this.onPressed,
    this.onChanged,
    this.isShimmer = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isShimmer) {
      return const IgnorePointer(
        ignoring: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: cListItemSpace),
          child: CheckboxTaskListItemContent(isShimmer: true),
        ),
      );
    }

    if(task != null) {
      return CheckboxTaskListItemContent(
        onCheckboxChanged: onChanged,
        onPressed: onPressed,
        completed: task!.isCompleted,
        title: task!.title,
        description: task!.description,
        dateTime: task!.date,
      );
    }

    return Container();
  }
}

class CheckboxTaskListItemContent extends StatelessWidget{

  final void Function(bool?)? onCheckboxChanged;
  final void Function()? onPressed;
  final bool? completed;
  final String? title;
  final String? description;
  final DateTime? dateTime;
  final bool isShimmer;

  const CheckboxTaskListItemContent({
    Key? key, 
    this.onCheckboxChanged,
    this.onPressed,
    this.completed,
    this.title,
    this.description,
    this.dateTime,
    this.isShimmer = false
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Row(
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            unselectedWidgetColor: customTheme.unselectedCheckboxColor,
          ),
          child: Checkbox(
            value: isShimmer ? true : (completed ?? false),
            activeColor: isShimmer ? customTheme.contentBackgroundColor : cPrimaryColor,
            checkColor: isShimmer ? customTheme.contentBackgroundColor : null,
            onChanged: (value) => onCheckboxChanged != null ? onCheckboxChanged!(value) : null,
          ),
        ),

        const SizedBox(width: 4.0),

        Expanded(
          child: ElevatedButton(
            onPressed: onPressed ?? () {},
            style: ElevatedButton.styleFrom(
              primary: customTheme.contentBackgroundColor,
              padding: const EdgeInsets.all(cListItemPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cBorderRadius),
              ),
              elevation: customTheme.elevation,
              shadowColor: customTheme.shadowColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ShimmerText(
                        isShimmer: isShimmer,
                        shimmerTextHeight: 0.9,
                        shimmerMinTextLenght: 25,
                        shimmerMaxTextLenght: 40,
                        text: title,
                        style: customTheme.boldTextStyle,
                        maxLines: 2,
                        alignment: Alignment.bottomLeft,
                      ),
                    ),

                    const SizedBox(width: 12.0),

                    if(dateTime != null) Text(
                      dateTime!.format(context, "HH:mm a"),
                      style: customTheme.lightTextStyle,
                      maxLines: 1,
                    )
                  ],
                ),

                // Description
                if(isShimmer || description != "") Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ShimmerText(
                    isShimmer: isShimmer,
                    shimmerTextHeight: 0.9,
                    shimmerMinTextLenght: 25,
                    shimmerMaxTextLenght: 45,
                    shimmerProbability: 0.5,
                    text: description,
                    style: customTheme.lightTextStyle,
                    maxLines: 3
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}