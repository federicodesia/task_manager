import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/active_session_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/models/geo_location.dart';
import 'package:task_manager/theme/theme.dart';

class LoginActivityCard extends StatelessWidget {

  final ActiveSession activeSession;
  LoginActivityCard({required this.activeSession});

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return InkWell(
      onTap: () {
        ModalBottomSheet(
          title: context.l10n.bottomSheet_sessionInformation, 
          context: context,
          content: ActiveSessionBottomSheet(
            activeSession: activeSession
          )
        ).show();
      },
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
                        if(activeSession.isThisDevice) TextSpan(
                          text: context.l10n.securitySettings_thisDevice + "  ",
                          style: customTheme.boldTextStyle.copyWith(color: Colors.green)
                        ),
                        // TODO: Device name
                        TextSpan(text: "Device name"),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    getLocationString(
                      context: context,
                      location: activeSession.geoLocation
                    ),
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

String getLocationString({required BuildContext context, GeoLocation? location}){
  if(location != null){
    List<String?> locationStrings;
    locationStrings = [location.city, location.region, location.country];
    locationStrings.removeWhere((s) => s == null || s.isEmpty);
    if(locationStrings.isNotEmpty) return locationStrings.map((s) => s.toString()).join(", ");
  }
  return context.l10n.locationNotAvailable;
}