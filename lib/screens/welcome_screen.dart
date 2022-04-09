import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/center_text_icon_button.dart';
import 'package:task_manager/components/lists/dot_indicator_list.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/responsive/centered_page_view_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/sliding_page.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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

  late AvailableSpaceCubit availableSpaceCubit = context.read<AvailableSpaceCubit>();
  int currentSlidingPage = 0;

  // TODO: Internationalize
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
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              child: Column(
                children: [

                  CenteredPageViewWidget(
                    availableSpaceCubit: availableSpaceCubit,
                    onPageChanged: (index){
                      setState(() => currentSlidingPage = index);
                    },
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(slidingPages.length, (index){
                      SlidingPage slidingPage = slidingPages[index];

                      return EmptySpace(
                        padding: const EdgeInsets.all(cPadding),
                        svgImage: slidingPage.svg,
                        svgBottomSpace: 48.0,
                        header: slidingPage.header,
                        headerMaxLines: 1,
                        headerFillLines: true,
                        description: slidingPage.description,
                        descriptionMaxLines: 3,
                        descriptionFillLines: true,
                      );
                    }),
                  ),

                  WidgetSize(
                    onChange: (Size size){
                      context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          DotIndicatorList(
                            count: slidingPages.length,
                            selectedIndex: currentSlidingPage,
                          ),
                          const SizedBox(height: cPadding),

                          CenterTextIconButton(
                            text: context.l10n.welcomeScreen_continueWithMethod("Facebook"),
                            iconAsset: "assets/icons/facebook.png",
                            onPressed: () {},
                          ),
                          const SizedBox(height: 12.0),

                          CenterTextIconButton(
                            text: context.l10n.welcomeScreen_continueWithMethod("Google"),
                            iconAsset: "assets/icons/google.png",
                            onPressed: () {},
                          ),
                          const SizedBox(height: 12.0),

                          CenterTextIconButton(
                            text: context.l10n.welcomeScreen_continueWithMethod("email"),
                            iconAsset: "assets/icons/email.png",
                            onPressed: () {
                              AutoRouter.of(context).navigate(const LoginRoute());
                            },
                          ),
                          const SizedBox(height: cPadding),

                          FractionallySizedBox(
                            widthFactor: 0.75,
                            child: Text(
                              context.l10n.welcomeScreen_agreeTerms,
                              style: customTheme.smallLightTextStyle.copyWith(color: customTheme.extraLightTextColor),
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