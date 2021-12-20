import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/center_text_icon_button.dart';
import 'package:task_manager/components/lists/dot_indicator_list.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/responsive/centered_page_view_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
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

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [

                  CenteredPageViewWidget(
                    availableSpaceCubit: availableSpaceCubit,
                    onPageChanged: (index){
                      setState(() => currentSlidingPage = index);
                    },
                    physics: BouncingScrollPhysics(),
                    children: List.generate(3, (index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: cPadding),
                        child: EmptySpace(
                          svgImage: "assets/svg/completed_tasks.svg",
                          svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width * 0.4
                            : MediaQuery.of(context).size.height * 0.4,
                          svgBottomMargin: 48.0,
                          header: "Organize your works",
                          description: "Let's organize your works with priority and do everything without stress.",
                        ),
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
                            count: 3,
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
                            onPressed: () {},
                          ),
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