import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/shimmer/shimmer_text.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/category_screen.dart';
import 'package:collection/collection.dart';
import 'package:task_manager/theme/theme.dart';

class CategoryCard extends StatelessWidget{

  final String? categoryId;
  final bool isShimmer;

  CategoryCard({
    this.categoryId,
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
              final category = categoryState.categories.firstWhereOrNull((c) => c.id == categoryId);
              if(category == null) return Container();

              List<Task> categoryTasks = taskState.tasks.where((t) => t.categoryId == categoryId).toList();

              String description;
              int tasksCount = categoryTasks.length;
              int completedTasks = categoryTasks.where((task) => task.isCompleted).length;
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
                          categoryId: categoryId
                        )..add(CategoryScreenLoaded()),
                        child: CategoryScreen(categoryId: categoryId),
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
    final customTheme = Theme.of(context).customTheme;
    
    return IgnorePointer(
      ignoring: isShimmer,
      child: ElevatedButton(
        onPressed: () => onPressed != null ? onPressed!() : null,
        onLongPress: () => onLongPress != null ? onLongPress!() : null,
        style: ElevatedButton.styleFrom(
          primary: customTheme.contentBackgroundColor,
          padding: EdgeInsets.all(cPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cBorderRadius),
          ),
          elevation: customTheme.elevation,
          shadowColor: customTheme.shadowColor
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerText(
              isShimmer: isShimmer,
              shimmerTextHeight: 0.8,
              shimmerMinTextLenght: 15,
              shimmerMaxTextLenght: 25,
              text: name,
              style: customTheme.boldTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2.0),

            ShimmerText(
              isShimmer: isShimmer,
              shimmerTextHeight: 0.8,
              shimmerMinTextLenght: 12,
              shimmerMaxTextLenght: 22,
              text: description,
              style: customTheme.lightTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 10.0),
            
            LinearPercentIndicator(
              lineHeight: cLineSize,
              padding: EdgeInsets.zero,
              progressColor: color,
              backgroundColor: isShimmer ? customTheme.shimmerColor : customTheme.extraLightColor,
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