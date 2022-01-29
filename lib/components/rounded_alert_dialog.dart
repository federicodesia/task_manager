import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedAlertDialog{

  final BuildContext buildContext;
  final String? svgImage;
  final String title;
  final String description;
  final List<Widget>? actions;
  final MainAxisAlignment actionsAlignment;

  RoundedAlertDialog({
    required this.buildContext,
    this.svgImage,
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
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Card(
                  color: customTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cBorderRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        if(svgImage != null) Container(
                          height: MediaQuery.of(buildContext).orientation == Orientation.portrait
                            ? MediaQuery.of(buildContext).size.width * 0.4
                            : MediaQuery.of(buildContext).size.height * 0.4,
                          margin: EdgeInsets.only(bottom: 32.0),
                          child: SvgPicture.asset(svgImage!)
                        ),

                        Text(
                          title,
                          style: customTheme.subtitleTextStyle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 24.0),

                        Text(
                          description,
                          style: customTheme.lightTextStyle,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if(actions != null) Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
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
              )
            ],
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

  RoundedAlertDialogButton({
    required this.text,
    this.backgroundColor,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return TextButton(
      child: Text(
        text,
        style: customTheme.lightTextStyle.copyWith(
          color: backgroundColor != null ? Colors.white : null
        ),
      ),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
        ),
        elevation: backgroundColor != null ? customTheme.elevation : null,
        shadowColor: backgroundColor != null ? customTheme.shadowColor : null,
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 28.0
        )
      ),
    );
  }
}