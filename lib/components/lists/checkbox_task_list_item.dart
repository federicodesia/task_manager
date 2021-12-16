import 'package:flutter/material.dart';
import 'package:task_manager/components/shimmer/shimmer_text.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';

class CheckboxTaskListItem extends StatelessWidget{

  final Task? task;
  final Function()? onPressed;
  final Function(bool?)? onChanged;
  final bool isShimmer;
  
  CheckboxTaskListItem({
    this.task,
    this.onPressed,
    this.onChanged,
    this.isShimmer = false
  });

  @override
  Widget build(BuildContext context) {
    if(isShimmer) return IgnorePointer(
      ignoring: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: cListItemSpace),
        child: CheckboxTaskListItemContent(isShimmer: true),
      ),
    );

    if(task != null) return CheckboxTaskListItemContent(
      onCheckboxChanged: onChanged,
      onPressed: onPressed,
      completed: task!.completed,
      title: task!.title,
      description: task!.description,
      dateTime: task!.dateTime,
    );

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

  CheckboxTaskListItemContent({
    this.onCheckboxChanged,
    this.onPressed,
    this.completed,
    this.title,
    this.description,
    this.dateTime,
    this.isShimmer = false
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            unselectedWidgetColor: cCheckBoxUnselectedColor,
          ),
          child: Checkbox(
            value: isShimmer ? true : (completed ?? false),
            activeColor: isShimmer ? cCardBackgroundColor : cPrimaryColor,
            checkColor: isShimmer ? cCardBackgroundColor : null,
            onChanged: (value) => onCheckboxChanged != null ? onCheckboxChanged!(value) : null
          ),
        ),

        SizedBox(width: 4.0),

        Expanded(
          child: ElevatedButton(
            onPressed: onPressed ?? () {},
            style: ElevatedButton.styleFrom(
              primary: cCardBackgroundColor,
              padding: EdgeInsets.all(cListItemPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cBorderRadius),
              ),
              elevation: 0
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
                        style: cSubtitleTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        alignment: Alignment.bottomLeft,
                      ),
                    ),

                    SizedBox(width: 12.0),

                    if(dateTime != null) Text(
                      DateFormat("HH:mm a").format(dateTime!).toLowerCase(),
                      style: cLightTextStyle
                    )
                  ],
                ),

                // Description
                if(isShimmer || description != "") Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: ShimmerText(
                    isShimmer: isShimmer,
                    shimmerTextHeight: 0.9,
                    shimmerMinTextLenght: 25,
                    shimmerMaxTextLenght: 45,
                    shimmerProbability: 0.5,
                    text: description,
                    style: cLightTextStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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