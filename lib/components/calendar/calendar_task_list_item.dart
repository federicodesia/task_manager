import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/components/shimmer/shimmer_text.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'calendar_group_hour.dart';

class CalendarTaskListItem extends StatelessWidget{

  final Task? task;
  final Function()? onPressed;
  final bool isShimmer;
  
  CalendarTaskListItem({
    this.task,
    this.onPressed,
    this.isShimmer = false
  });

  @override
  Widget build(BuildContext context) {

    if(isShimmer) return IgnorePointer(
      ignoring: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: cListItemSpace),
        child: CalendarTaskListItemContent(isShimmer: true),
      ),
    );

    if(task != null) return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (_, categoryState) {

        if(categoryState is CategoryLoadSuccess){

          Category? category = categoryState.categories.firstWhereOrNull((c) => c.uuid == task!.categoryUuid);
          if(category != null) return CalendarTaskListItemContent(
            onPressed: onPressed,
            categoryColor: category.color,
            categoryName: category.name,
            dateTime: task!.dateTime,
            title: task!.title,
            description: task!.description,
          );

          return Container();
        }
        return Container();
      }
    );
    return Container();
  }
}

class CalendarTaskListItemContent extends StatelessWidget{

  final void Function()? onPressed;
  final Color? categoryColor;
  final String? categoryName;
  final DateTime? dateTime;
  final String? title;
  final String? description;
  final bool isShimmer;

  CalendarTaskListItemContent({
    this.onPressed,
    this.categoryColor,
    this.categoryName,
    this.dateTime,
    this.title,
    this.description,
    this.isShimmer = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CalendarGroupHourText(text: "12:00", visible: false),

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
            child: IntrinsicHeight(
              child: Row(
                children: [
                  
                  Container(
                    width: cLineSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: isShimmer ? cShimmerColor : categoryColor
                    )
                  ),
                  SizedBox(width: 16.0),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ShimmerText(
                                isShimmer: isShimmer,
                                shimmerTextHeight: 0.9,
                                shimmerMinTextLenght: 15,
                                shimmerMaxTextLenght: 25,
                                text: categoryName,
                                style: cSmallLightTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(width: 12.0),

                            if(dateTime != null) Text(
                              DateFormat("HH:mm a").format(dateTime!).toLowerCase(),
                              style: cLightTextStyle
                            )
                          ],
                        ),
                        SizedBox(height: 4.0),

                        ShimmerText(
                          isShimmer: isShimmer,
                          shimmerTextHeight: 0.9,
                          shimmerMinTextLenght: 25,
                          shimmerMaxTextLenght: 40,
                          text: title,
                          style: cBoldTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),

                        // Description
                        if(description != "" && description != null) Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            description!,
                            style: cExtraLightTextStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        )
      ],
    );
  }
}