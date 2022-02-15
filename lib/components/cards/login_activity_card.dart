import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

class LoginActivityCard extends StatelessWidget {

  LoginActivityCard({
    required this.deviceName,
    required this.location,
    this.isThisDevice = false,
    this.onTap
  });

  final String deviceName;
  final String location;
  final bool isThisDevice;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cBorderRadius),
      
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Material(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              elevation: customTheme.elevation,
              shadowColor: customTheme.shadowColor,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: customTheme.contentBackgroundColor
                ),
                child: Icon(
                  Icons.place_outlined,
                  color: Colors.grey,
                  size: 18.0,
                ),
              ),
            ),

            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: customTheme.textStyle,
                      children: <TextSpan>[
                        if(isThisDevice) TextSpan(
                          text: context.l10n.securitySettings_thisDevice + "  ",
                          style: customTheme.boldTextStyle.copyWith(color: Colors.green)
                        ),
                        TextSpan(text: deviceName),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    location,
                    style: customTheme.smallLightTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}