import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
                        "Profile",
                        style: customTheme.subtitleTextStyle,
                      )
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 32.0),

                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
                        elevation: customTheme.elevation,
                        shadowColor: customTheme.shadowColor,
                        child: Container(
                          margin: EdgeInsets.all(16.0),
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
                                            "Usage of your free plan",
                                            style: customTheme.boldTextStyle,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8.0),

                                          Text(
                                            "Access all full features by subscribing to our package!",
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
                                  color: cPrimaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
                                ),
                                child: Row(
                                  children: [

                                    Expanded(
                                      child: Text(
                                        "See the Pro benefits",
                                        style: customTheme.textStyle.copyWith(color: CustomThemeData.dark.textColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    SizedBox(width: 16.0),

                                    RoundedButton(
                                      autoWidth: true,
                                      color: cGoldenColor,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "Upgrade to Pro",
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
                      )
                    ],
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