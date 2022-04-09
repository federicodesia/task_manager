import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/active_session_bottom_sheet.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/models/geo_location.dart';
import 'package:task_manager/theme/theme.dart';

class LoginActivityCard extends StatelessWidget {

  final ActiveSession activeSession;

  const LoginActivityCard({
    Key? key,
    required this.activeSession
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return InkWell(
      onTap: () {
        ActiveSessionBottomSheet(
          context,
          activeSession: activeSession
        ).show();
      },
      borderRadius: BorderRadius.circular(cBorderRadius),
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Material(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              elevation: customTheme.elevation,
              shadowColor: customTheme.shadowColor,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  color: customTheme.contentBackgroundColor
                ),
                child: const Icon(
                  Icons.place_outlined,
                  color: Colors.grey,
                  size: 18.0,
                ),
              ),
            ),

            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      style: customTheme.textStyle,
                      children: <TextSpan>[
                        if(activeSession.isThisDevice) TextSpan(
                          text: context.l10n.securitySettings_thisDevice + "  ",
                          style: customTheme.boldTextStyle.copyWith(color: Colors.green)
                        ),
                        
                        TextSpan(text: activeSession.deviceNameLocalization(context)),
                      ],
                    ),
                    maxLines: 1
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    getLocationString(
                      context: context,
                      location: activeSession.geoLocation
                    ),
                    style: customTheme.smallLightTextStyle,
                    maxLines: 1
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