import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/center_text_icon_button.dart';
import 'package:task_manager/components/lists/dot_indicator_list.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/responsive/centered_page_view_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/models/sliding_page.dart';
import 'package:task_manager/screens/login_screen.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _WelcomeScreen(),
    );
  }
}

class _WelcomeScreen extends StatefulWidget{

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<_WelcomeScreen>{

  late AvailableSpaceCubit availableSpaceCubit = BlocProvider.of<AvailableSpaceCubit>(context);
  int currentSlidingPage = 0;

  List<SlidingPage> slidingPages = [
    SlidingPage(
      header: "Organize your works",
      description: "Let's organize your works with priority and do everything without stress.",
      svg: "assets/svg/completed_tasks.svg",
    ),
    SlidingPage(
      header: "Keep everything in one place",
      description: "Access your account from anywhere, all your tasks are in the cloud!",
      svg: "assets/svg/going_offline.svg",
    ),
    SlidingPage(
      header: "Receive notifications",
      description: "Don't forget your work anymore! Receive reminders without Internet.",
      svg: "assets/svg/to_do.svg",
    ),
  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              child: Column(
                children: [

                  CenteredPageViewWidget(
                    availableSpaceCubit: availableSpaceCubit,
                    onPageChanged: (index){
                      setState(() => currentSlidingPage = index);
                    },
                    physics: BouncingScrollPhysics(),
                    children: List.generate(slidingPages.length, (index){
                      SlidingPage slidingPage = slidingPages[index];

                      return EmptySpace(
                        padding: EdgeInsets.all(cPadding),
                        svgImage: slidingPage.svg,
                        svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.35
                          : MediaQuery.of(context).size.height * 0.35,
                        svgBottomMargin: 48.0,
                        header: slidingPage.header,
                        headerMaxLines: 1,
                        headerFillLines: true,
                        description: slidingPage.description,
                        descriptionMaxLines: 3,
                        descriptionFillLines: true,
                        descriptionWidthFactor: MediaQuery.of(context).orientation == Orientation.portrait ? 0.9 : 0.55
                      );
                    }),
                  ),

                  WidgetSize(
                    onChange: (Size size){
                      context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          DotIndicatorList(
                            count: slidingPages.length,
                            selectedIndex: currentSlidingPage,
                          ),
                          SizedBox(height: cPadding),

                          CenterTextIconButton(
                            text: "Continue with Facebook",
                            iconAsset: "assets/icons/facebook.png",
                            onPressed: () {},
                          ),
                          SizedBox(height: 12.0),

                          CenterTextIconButton(
                            text: "Continue with Google",
                            iconAsset: "assets/icons/google.png",
                            onPressed: () {},
                          ),
                          SizedBox(height: 12.0),

                          CenterTextIconButton(
                            text: "Continue with email",
                            iconAsset: "assets/icons/email.png",
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => LoginScreen())
                              );
                            },
                          ),
                          SizedBox(height: cPadding),

                          FractionallySizedBox(
                            widthFactor: 0.75,
                            child: Text(
                              "By continuing, you agree Terms of Service and Privacy Policy.",
                              style: cExtraLightTextStyle.copyWith(
                                fontSize: 13.0,
                                color: cLightTextColor.withOpacity(0.5)
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            );
          }
        ),
      ),
    );
  }
}