import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';

class CalendarTaskListItem extends StatelessWidget{

  final Task task;
  final Function() onPressed;
  
  CalendarTaskListItem({
    required this.task,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (_, categoryState) {

        if(categoryState is CategoryLoadSuccess){
          Category category = categoryState.categories.firstWhere((category) => category.uuid == task.categoryUuid);

          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: cCardBackgroundColor,
              padding: EdgeInsets.all(cListItemPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cBorderRadius),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  
                  Container(
                    width: 6.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: category.color
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
                              child: Text(
                                category.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: cLightTextStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 13.0)
                              ),
                            ),

                            SizedBox(width: 12.0),

                            Text(
                              DateFormat("HH:mm a").format(task.dateTime).toLowerCase(),
                              style: cLightTextStyle
                            )
                          ],
                        ),
                        SizedBox(height: 4.0),

                        Text(
                          task.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: cSubtitleTextStyle
                        ),

                        // Description
                        Visibility(
                          visible: task.description != "",
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              task.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: cLightTextStyle.copyWith(fontWeight: FontWeight.w300, fontSize: 14.0)
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          );
        }

        return Container();
      }
    );
  }
}