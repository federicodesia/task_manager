import 'package:flutter/material.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedAlertDialog{

  final BuildContext buildContext;
  final String? svgImage;
  final double svgScale;
  final double svgBottomSpace;
  final String title;
  final String description;
  final List<Widget>? actions;
  final MainAxisAlignment actionsAlignment;

  RoundedAlertDialog({
    required this.buildContext,
    this.svgImage,
    this.svgScale = 0.4,
    this.svgBottomSpace = 32.0,
    required this.title,
    required this.description,
    this.actions,
    this.actionsAlignment = MainAxisAlignment.center
  });

  void show(){
    final customTheme = Theme.of(buildContext).customTheme;

    showDialog(
      context: buildContext,
      barrierColor: cBarrierColor,
      builder: (_) => Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              color: customTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: EmptySpace(
                        svgImage: svgImage,
                        svgScale: svgScale,
                        svgBottomSpace: svgBottomSpace,
                        header: title,
                        description: description
                      ),
                    ),

                    if(actions != null) Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: actionsAlignment,
                          children: actions!,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

class RoundedAlertDialogButton extends StatelessWidget{
  final String text;
  final Color? backgroundColor;
  final void Function()? onPressed;

  const RoundedAlertDialogButton({
    Key? key, 
    required this.text,
    this.backgroundColor,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return TextButton(
      child: Text(
        text,
        style: customTheme.lightTextStyle.copyWith(
          color: backgroundColor != null ? Colors.white : null
        ),
        maxLines: 1,
      ),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
        ),
        elevation: backgroundColor != null ? customTheme.elevation : null,
        shadowColor: backgroundColor != null ? customTheme.shadowColor : null,
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0
        )
      ),
    );
  }
}