import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/cards/login_activity_card.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';
import '../../constants.dart';

class SecurityScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _SecurityScreen(),
    );
  }
}
class _SecurityScreen extends StatefulWidget{

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<_SecurityScreen>{

  double appBarHeight = 500.0;

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: appBarHeight,
                  collapsedHeight: appBarHeight,
                  
                  flexibleSpace: WidgetSize(
                    onChange: (Size size){
                      setState(() => appBarHeight = size.height);
                      BlocProvider.of<AvailableSpaceCubit>(context).setHeight(constraints.maxHeight - size.height);
                    },
                    child: CenterAppBar(
                      center: Text(
                        context.l10n.settings_security,
                        style: customTheme.subtitleTextStyle,
                      )
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListHeader(context.l10n.securitySettings_loginSecurity),
                        RoundedListTile(
                          title: context.l10n.securitySettings_changeEmail,
                          icon: Icons.email_outlined,
                          color: Color(0xFF6A69E0),
                          onTap: () {},
                        ),
                        RoundedListTile(
                          title: context.l10n.securitySettings_changePassword,
                          icon: Icons.lock_outlined,
                          color: Color(0xFF31A7E1),
                          onTap: () {},
                        ),
                        RoundedListTile(
                          title: context.l10n.securitySettings_signOutOnAllDevices,
                          icon: Icons.logout_outlined,
                          color: Color(0xFFF57170),
                          onTap: () {},
                        ),

                        SizedBox(height: 8.0),
                        ListHeader(context.l10n.securitySettings_relatedNotifications),
                        RoundedListTileSwitch(
                          title: context.l10n.securitySettings_loginOnNewDevice,
                          icon: Icons.smartphone_outlined,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: 8.0),
                        ListHeader(context.l10n.securitySettings_loginActivity),
                        
                        LoginActivityCard(
                          deviceName: "Galaxy J2 Prime",
                          location: "Chivilcoy, Buenos Aires, Argentina",
                          isThisDevice: true,
                          onTap: () {},
                        ),
                        SizedBox(height: 4.0),
                        LoginActivityCard(
                          deviceName: "Xiaomi Redmi 9A",
                          location: "Chivilcoy, Buenos Aires, Argentina",
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        ),
      )
    );
  }
}