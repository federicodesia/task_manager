import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';
import '../constants.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _ProfileScreen(),
    );
  }
}
class _ProfileScreen extends StatefulWidget{

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen>{

  double appBarHeight = 500.0;

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: appBarHeight,
                  collapsedHeight: appBarHeight,
                  
                  flexibleSpace: WidgetSize(
                    onChange: (Size size){
                      setState(() => appBarHeight = size.height);
                      BlocProvider.of<AvailableSpaceCubit>(context).setHeight(constraints.maxHeight - size.height);
                    },
                    child: CenterAppBar(
                      center: Text(
                        context.l10n.profile,
                        style: customTheme.subtitleTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight - appBarHeight
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: cPadding),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (_, authState) {
                                return Column(
                                  children: [

                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 3.0,
                                          color: cPrimaryColor
                                        )
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(4.0),
                                        height: 128.0,
                                        decoration: BoxDecoration(
                                          color: customTheme.contentBackgroundColor,
                                          shape: BoxShape.circle
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 32.0),

                                    Text(
                                      authState.user.name,
                                      style: customTheme.titleTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.0),

                                    Text(
                                      authState.user.email,
                                      style: customTheme.lightTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(height: 32.0),

                                    BlocBuilder<TaskBloc, TaskState>(
                                      builder: (_, taskState) {
                                        int? tasksCount, completedCount, remainingCount;
                                        if(taskState is TaskLoadSuccess){
                                          tasksCount = taskState.tasks.length;
                                          completedCount = taskState.tasks.where((t) => t.isCompleted).length;
                                          remainingCount = tasksCount - completedCount;
                                        }

                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ProfileItem(
                                              count: tasksCount,
                                              name: context.l10n.tasks,
                                            ),

                                            ProfileItem(
                                              count: completedCount,
                                              name: context.l10n.enum_taskFilter_completed,
                                            ),

                                            ProfileItem(
                                              count: remainingCount,
                                              name: context.l10n.enum_taskFilter_remaining,
                                            )
                                          ],
                                        );
                                      }
                                    ),
                                  ],
                                );
                              }
                            ),
                          ),

                          SizedBox(height: 16.0),
                          Spacer(),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 16.0
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
                              elevation: customTheme.elevation,
                              shadowColor: customTheme.shadowColor,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: customTheme.contentBackgroundColor,
                                  borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
                                ),
                                child: Column(
                                  children: [

                                    Padding(
                                      padding: EdgeInsets.all(cPadding),
                                      child: Row(
                                        children: [

                                          // TODO: Add plans
                                          CircularPercentIndicator(
                                            radius: 56.0,
                                            lineWidth: cLineSize,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            animationDuration: cAnimationDuration.inMilliseconds,
                                            percent: 0.57,
                                            center: Text(
                                              "57%",
                                              style: customTheme.textStyle,
                                            ),
                                            circularStrokeCap: CircularStrokeCap.round,
                                            backgroundColor: cGoldenColor.withOpacity(customTheme.isDark ? 0.15 : 0.4),
                                            progressColor: cGoldenColor,
                                          ),

                                          SizedBox(width: 16.0),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.l10n.upgradeToPro_title,
                                                  style: customTheme.boldTextStyle,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8.0),

                                                Text(
                                                  context.l10n.upgradeToPro_description,
                                                  style: customTheme.lightTextStyle,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: EdgeInsets.all(cPadding),
                                      decoration: BoxDecoration(
                                        color: cPrimaryColor.withOpacity(customTheme.isDark ? 0.85 : 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
                                      ),
                                      child: Row(
                                        children: [

                                          Expanded(
                                            child: Text(
                                              context.l10n.plansAndBenefits_button,
                                              style: customTheme.textStyle.copyWith(color: CustomThemeData.dark.textColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          SizedBox(width: 12.0),

                                          RoundedButton(
                                            autoWidth: true,
                                            color: cGoldenColor,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                context.l10n.upgradeToPro_button,
                                                style: customTheme.boldTextStyle.copyWith(color: CustomThemeData.light.textColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            onPressed: () {}
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        ),
      )
    );
  }
}

class ProfileItem extends StatelessWidget{

  final int? count;
  final String name;

  ProfileItem({
    required this.count,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Text(
              count != null ? count.toString() : "-",
              style: customTheme.subtitleTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.0),
            Text(
              name,
              style: customTheme.lightTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}