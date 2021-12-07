import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/category_screen.dart';

class CategoryCard extends StatelessWidget{

  final String? categoryUuid;
  CategoryCard({required this.categoryUuid});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, taskState) {

        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (_, categoryState) {

            if(taskState is TaskLoadSuccess && categoryState is CategoryLoadSuccess){
              Category category = categoryState.categories.firstWhere((c) => c.uuid == categoryUuid);
              List<Task> categoryTasks = taskState.tasks.where((t) => t.categoryUuid == categoryUuid).toList();

              String description;
              int tasksCount = categoryTasks.length;
              int completedTasks = categoryTasks.where((task) => task.completed).length;
              if(tasksCount > 0 && tasksCount == completedTasks) description = "All done";
              else{
                int remainingTasks = tasksCount - completedTasks;
                if(remainingTasks == 1) description = "$remainingTasks task";
                else description = "$remainingTasks tasks";
              }

              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){
                      return BlocProvider(
                        create: (BuildContext context) => CategoryScreenBloc(
                          taskBloc: BlocProvider.of<TaskBloc>(context),
                          categoryUuid: categoryUuid
                        )..add(CategoryScreenLoaded()),
                        child: CategoryScreen(categoryUuid: categoryUuid),
                      );
                    })
                  );
                },
                onLongPress: !category.isGeneral ? () {
                  ModalBottomSheet(
                    title: "Edit category",
                    context: context,
                    content: CategoryBottomSheet(editCategory: category)
                  ).show();
                } : null,
                style: ElevatedButton.styleFrom(
                  primary: cCardBackgroundColor,
                  padding: EdgeInsets.all(cPadding),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cBorderRadius),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: cHeaderTextStyle.copyWith(fontSize: 15.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.0),

                    Text(
                      description,
                      style: cLightTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.0),
                    
                    LinearPercentIndicator(
                      lineHeight: 6.0,
                      padding: EdgeInsets.zero,
                      progressColor: category.color,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      percent: tasksCount > 0 ? completedTasks / tasksCount : 0,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: cAnimationDuration.inMilliseconds,
                    )
                  ],
                )
              );
            }

            return Container();
          }
        );
      }
    );
  }
}