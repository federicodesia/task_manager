import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';

class CategoryCard extends StatelessWidget{

  final Category category;
  CategoryCard({this.category});

  @override
  Widget build(BuildContext context) {

    String _description;
    if(category.tasks.length == 0) _description = "Nothing yet!";
    else if(category.allTaskCompleted()) _description = "All done!";
    else{
      int remainingTasks = category.tasks.length - category.completedTasksCount();
      if(remainingTasks == 1) _description = "$remainingTasks Task";
      else _description = "$remainingTasks Tasks";
    }

    return Container(
      decoration: BoxDecoration(
        color: cCardBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
      ),
      padding: EdgeInsets.all(cPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cButtonSize,
            padding: EdgeInsets.all(cButtonPadding),
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
            ),
            child: Icon(
              category.icon,
              color: Colors.white,
            ),
          ),

          SizedBox(height: cPadding),

          Text(
            category.name,
            style: cHeaderTextStyle.copyWith(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.0),
          Text(
            _description,
            style: cLightTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );
  }
}