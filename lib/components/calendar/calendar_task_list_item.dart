import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';

class CalendarTaskListItem extends StatefulWidget{

  final Task task;
  final Function() onPressed;
  
  CalendarTaskListItem({
    required this.task,
    required this.onPressed,
  });

  @override
  _CalendarTaskListItemState createState() => _CalendarTaskListItemState();
}

class _CalendarTaskListItemState extends State<CalendarTaskListItem>{

  final category = categoryList[0];

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: widget.onPressed,
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
                color: category.color.withOpacity(0.75)
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
                        DateFormat("HH:mm a").format(widget.task.dateTime).toLowerCase(),
                        style: cLightTextStyle
                      )
                    ],
                  ),
                  SizedBox(height: 4.0),

                  Text(
                    widget.task.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: cSubtitleTextStyle
                  ),

                  // Description
                  Visibility(
                    visible: widget.task.description != "",
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.task.description,
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
}