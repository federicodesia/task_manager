import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/components/shimmer/shimmer_text.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:collection/collection.dart';
import 'package:task_manager/theme/theme.dart';

import 'calendar_group_hour.dart';

class CalendarTaskListItem extends StatelessWidget{

  final Task? task;
  final Function()? onPressed;
  final bool isShimmer;
  
  const CalendarTaskListItem({
    Key? key, 
    this.task,
    this.onPressed,
    this.isShimmer = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(isShimmer) {
      return const IgnorePointer(
        ignoring: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: cListItemSpace),
          child: CalendarTaskListItemContent(isShimmer: true),
        ),
      );
    }

    if(task != null) {
      return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (_, categoryState) {

          final category = categoryState.categories.firstWhereOrNull((c) => c.id == task!.categoryId);
          if(category != null) {
            return CalendarTaskListItemContent(
              onPressed: onPressed,
              categoryColor: category.color,
              categoryName: category.name,
              dateTime: task!.date,
              title: task!.title,
              description: task!.description,
            );
          }
          return Container();
        }
      );
    }
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

  const CalendarTaskListItemContent({
    Key? key, 
    this.onPressed,
    this.categoryColor,
    this.categoryName,
    this.dateTime,
    this.title,
    this.description,
    this.isShimmer = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Row(
      children: [
        const CalendarGroupHourText(text: "12:00", visible: false),

        Expanded(
          child: ElevatedButton(
            onPressed: onPressed ?? () {},
            style: ElevatedButton.styleFrom(
              primary: customTheme.contentBackgroundColor,
              padding: const EdgeInsets.all(cListItemPadding),
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
                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                      color: isShimmer ? customTheme.shimmerColor : categoryColor
                    )
                  ),
                  const SizedBox(width: 16.0),

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
                                style: customTheme.smallLightTextStyle,
                                maxLines: 1
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
                        const SizedBox(height: 4.0),

                        ShimmerText(
                          isShimmer: isShimmer,
                          shimmerTextHeight: 0.9,
                          shimmerMinTextLenght: 25,
                          shimmerMaxTextLenght: 40,
                          text: title,
                          style: customTheme.boldTextStyle,
                          maxLines: 2,
                        ),

                        // Description
                        if(description != "" && description != null) Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            description!,
                            style: customTheme.lightTextStyle,
                            maxLines: 3
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