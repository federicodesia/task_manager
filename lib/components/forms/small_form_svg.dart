import 'package:flutter/material.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class SmallFormSvg extends StatelessWidget {

  final String svgImage;
  final String header;
  final String description;
  final List<Widget> formChildren;
  final bool isLoading;
  final String buttonText;
  final void Function() onButtonPressed;
  final Widget? bottomWidget;

  const SmallFormSvg({
    Key? key, 
    required this.svgImage,
    required this.header,
    required this.description,
    required this.formChildren,
    required this.isLoading,
    required this.buttonText,
    required this.onButtonPressed,
    this.bottomWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight
                ),
                child: IntrinsicHeight(
                  child: IgnorePointer(
                    ignoring: isLoading,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(cPadding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                EmptySpace(
                                  svgImage: svgImage,
                                  svgBottomSpace: 64.0,
                                  header: header,
                                  description: description,
                                ),

                                const SizedBox(height: cPadding),
                                Column(
                                  children: formChildren,
                                )
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(cPadding),
                          child: Column(
                            children: [
                              if(isLoading) const Padding(
                                padding: EdgeInsets.only(bottom: 32.0),
                                child: CircularProgressIndicator(),
                              ),

                              RoundedTextButton(
                                text: buttonText,
                                onPressed: onButtonPressed,
                              ),

                              const SizedBox(height: cPadding),
                              bottomWidget ?? Container()
                            ],
                          ),
                        )
                      ]
                    ),
                  ),
                )
              )
            );
          }
        ),
      )
    );
  }
}