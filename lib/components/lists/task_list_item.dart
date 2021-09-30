import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';

class TaskListItem extends StatefulWidget{

  final Task task;
  final Function()? onPressed;
  final Function(bool value)? onChanged;
  TaskListItem({
    required this.task,
    this.onPressed,
    this.onChanged
  });

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem>{

  //late bool _completed = widget.task.completed;
  
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
            unselectedWidgetColor: Color(0xFF2C2F39),
          ),
          child: Checkbox(
            value: widget.task.completed,
            activeColor: cPrimaryColor,
            onChanged: (value){
              /*setState(() {
                _completed = !_completed;
              });*/
              widget.onChanged!(value!);
            }
          ),
        ),

        SizedBox(width: 4.0),

        Expanded(
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              primary: cListItemBackgroundColor,
              padding: EdgeInsets.all(cListItemPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cBorderRadius),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.task.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: cTitleTextStyle
                      ),
                    ),

                    SizedBox(width: 12.0),

                    Text(
                      DateFormat("HH:mm a").format(widget.task.dateTime),
                      style: cTitleTextStyle
                    )
                  ],
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
                      style: cLightTextStyle
                    ),
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