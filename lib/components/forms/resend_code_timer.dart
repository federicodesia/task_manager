import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

class ResendCodeTimer extends StatelessWidget{

  final CustomTimerController controller;
  final void Function() onResend;

  const ResendCodeTimer({
    Key? key, 
    required this.controller,
    required this.onResend
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return CustomTimer(
      controller: controller,
      begin: const Duration(minutes: 2),
      end: const Duration(),
      builder: (time) {
        return Text(
          context.l10n.emailVerification_resendCodeIn("${time.minutes}:${time.seconds}\n"),
          style: customTheme.smallLightTextStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );
      },
      stateBuilder: (time, state) {
        return GestureDetector(
          child: RichText(
            text: TextSpan(
              style: customTheme.smallLightTextStyle,
              children: [
                TextSpan(text: context.l10n.emailVerification_didntReceiveCode + " "),
                TextSpan(
                  text: context.l10n.emailVerification_resend + "\n",
                  style: customTheme.smallTextButtonStyle
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          onTap: onResend,
        );
      },
      animationBuilder: (child) {
        return AnimatedSwitcher(
          duration: cTransitionDuration,
          child: child,
        );
      },
    );
  }
}