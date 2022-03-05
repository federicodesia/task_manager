import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/theme/theme.dart';
import 'package:latlong2/latlong.dart';

class ActiveSessionBottomSheet{

  final BuildContext context;
  final ActiveSession activeSession;

  ActiveSessionBottomSheet(
    this.context,
    {required this.activeSession}
  );

  void show(){
    ModalBottomSheet(
      title: context.l10n.bottomSheet_sessionInformation,
      context: context,
      content: _ActiveSessionBottomSheet(this)
    ).show();
  }
}

class _ActiveSessionBottomSheet extends StatelessWidget{

  final ActiveSessionBottomSheet data;
  _ActiveSessionBottomSheet(this.data);

  late final activeSession = data.activeSession;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    final geoLocation = activeSession.geoLocation;
    final lat = geoLocation?.lat;
    final lon = geoLocation?.lon;
    final locationPoint = lat != null && lon != null ? LatLng(lat, lon) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: cPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          FormInputHeader(activeSession.deviceNameLocalization(context)),
          const SizedBox(height: 4.0),

          Text(
            "${context.l10n.ipAdress}: ${activeSession.ipAddress}",
            style: customTheme.lightTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            "${context.l10n.loginDate}: ${activeSession.createdAt.format(context, "d MMM y HH:mm a")}",
            style: customTheme.lightTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            "${context.l10n.lastActivity}: ${activeSession.lastTimeOfUse.format(context, "d MMM y HH:mm a")}",
            style: customTheme.lightTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          if(locationPoint != null) Container(
            margin: const EdgeInsets.only(top: cPadding),
            height: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius)),
              child: FlutterMap(
                options: MapOptions(
                  center: locationPoint,
                  interactiveFlags: InteractiveFlag.none,
                  zoom: 12.0,
                ),
                layers: [
                  TileLayerOptions(
                    tileProvider: const CachedTileProvider(),
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],

                    backgroundColor: customTheme.backgroundColor,
                    opacity: customTheme.isDark ? 0.5 : 0.85,
                    tileBuilder: (context, tileWidget, tile) {
                      return InvertColors(
                        invert: customTheme.isDark,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation
                          ),
                          child: tileWidget
                        ),
                      );
                    },
                    attributionBuilder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "© OpenStreetMap contributors ",
                          style: customTheme.smallLightTextStyle
                        ),
                      );
                    },
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 148.0,
                        height: 148.0,
                        point: locationPoint,
                        builder: (_){
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cPrimaryColor.withOpacity(0.25),
                              border: Border.all(
                                width: 2.0,
                                color: cPrimaryColor.withOpacity(0.5)
                              )
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32.0),

          RoundedButton(
            width: double.infinity,
            child: Text(
              context.l10n.logout_button,
              style: customTheme.primaryColorButtonTextStyle,
            ),
            onPressed: (){
              context.read<AuthBloc>().add(AuthLogoutSessionRequested(sessionId: activeSession.id));
              Navigator.pop(context);
            }
          )
        ],
      ),
    );
  }
}

class InvertColors extends StatelessWidget {
  
  final Widget child;
  final bool invert;

  const InvertColors({
    Key? key, 
    required this.child,
    this.invert = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return invert ? ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        -1, 0, 0, 0,
        255, 0, -1, 0, 0,
        255, 0, 0, -1, 0,
        255, 0, 0, 0, 1, 0,
      ]),
      child: child,
    ) : child;
  }
}

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
    );
  }
}