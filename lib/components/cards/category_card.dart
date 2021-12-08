import 'dart:math';

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
  final bool isShimmer;

  CategoryCard({
    this.categoryUuid,
    this.isShimmer = false
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, taskState) {

        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (_, categoryState) {

            if(isShimmer) return CategoryCardContent(isShimmer: true);

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

              return CategoryCardContent(
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
                onLongPress: () {
                  if(!category.isGeneral) ModalBottomSheet(
                    title: "Edit category",
                    context: context,
                    content: CategoryBottomSheet(editCategory: category)
                  ).show();
                },
                name: category.name,
                description: description,
                color: category.color,
                tasksCount: tasksCount,
                completedTasks: completedTasks
              );
            }

            return Container();
          }
        );
      }
    );
  }
}

class CategoryCardContent extends StatelessWidget{

  final void Function()? onPressed;
  final void Function()? onLongPress;
  final String? name;
  final String? description;
  final Color color;
  final int tasksCount;
  final int completedTasks;
  final bool isShimmer;

  CategoryCardContent({
    this.onPressed,
    this.onLongPress,
    this.name,
    this.description,
    this.color = Colors.transparent,
    this.tasksCount = 0,
    this.completedTasks = 0,
    this.isShimmer = false
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isShimmer,
      child: ElevatedButton(
        onPressed: () => onPressed,
        onLongPress: () => onLongPress,
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
            ShimmerText(
              isShimmer: isShimmer,
              text: name ?? (List.generate(15 + Random().nextInt(10), (_) => " ").join()),
              style: cHeaderTextStyle.copyWith(fontSize: 15.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2.0),

            ShimmerText(
              isShimmer: isShimmer,
              shimmerTextHeight: 0.75,
              text: description ?? (List.generate(12 + Random().nextInt(10), (_) => " ").join()),
              style: cLightTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 10.0),
            
            LinearPercentIndicator(
              lineHeight: 6.0,
              padding: EdgeInsets.zero,
              progressColor: color,
              backgroundColor: Colors.white.withOpacity(isShimmer ? 0.03 : 0.25),
              percent: tasksCount > 0 ? completedTasks / tasksCount : 0,
              animation: true,
              animateFromLastPercent: true,
              animationDuration: cAnimationDuration.inMilliseconds,
            )
          ],
        )
      ),
    );
  }
}

class ShimmerText extends StatelessWidget{

  final bool isShimmer;
  final double shimmerTextHeight;
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  ShimmerText({
    required this.isShimmer,
    this.shimmerTextHeight = 0.8,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Opacity(
          opacity: isShimmer ? 0.0 : 1.0,
          child: Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),

        Opacity(
          opacity: isShimmer ? 1.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              color: Colors.white.withOpacity(0.03)
            ),
            child: Opacity(
              opacity: 0,
              child: Text(
                text,
                style: style != null ? style!.copyWith(height: shimmerTextHeight) : null,
                maxLines: maxLines,
                overflow: overflow,
              ),
            ),
          ),
        ),
      ],
    );
  }
}