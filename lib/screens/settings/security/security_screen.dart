import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/components/cards/login_activity_card.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_alert_dialog.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../../../constants.dart';

class SecurityScreen extends StatefulWidget{
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen>{

  double appBarHeight = 500.0;

  @override
  void initState() {
    context.read<AuthBloc>().add(UpdateActiveSessionsRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: appBarHeight,
                  collapsedHeight: appBarHeight,
                  
                  flexibleSpace: WidgetSize(
                    onChange: (Size size) => setState(() => appBarHeight = size.height),
                    child: CenterAppBar(
                      center: Text(
                        context.l10n.settings_security,
                        style: customTheme.subtitleTextStyle,
                        maxLines: 1,
                      )
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListHeader(context.l10n.securitySettings_loginSecurity),
                        RoundedListTile(
                          title: context.l10n.securitySettings_changeEmail,
                          icon: Icons.email_outlined,
                          color: const Color(0xFF6A69E0),
                          onTap: () => AutoRouter.of(context).navigate(const ChangeEmailRoute()),
                        ),
                        RoundedListTile(
                          title: context.l10n.securitySettings_changePassword,
                          icon: Icons.lock_outlined,
                          color: const Color(0xFF31A7E1),
                          onTap: () => AutoRouter.of(context).navigate(const ChangePasswordRoute()),
                        ),
                        RoundedListTile(
                          title: context.l10n.securitySettings_signOutOnAllDevices,
                          icon: Icons.logout_outlined,
                          color: const Color(0xFFF57170),
                          onTap: () => showLogoutAllDialog(context),
                        ),

                        const SizedBox(height: 8.0),
                        ListHeader(context.l10n.securitySettings_relatedNotifications),
                        BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (_, settingsState) {
                            return RoundedListTileSwitch(
                              title: context.l10n.securitySettings_loginOnNewDevice,
                              icon: Icons.smartphone_outlined,
                              value: settingsState.loginOnNewDeviceNotification,
                              onSwitch: () => context.read<SettingsCubit>().toggleLoginOnNewDeviceNotification()
                            );
                          }
                        ),

                        const SizedBox(height: 8.0),
                        ListHeader(context.l10n.securitySettings_loginActivity),

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (_, authState){
                            final activeSessions = authState.activeSessions;

                            return DeclarativeAnimatedList(
                              items: activeSessions.toList(),
                              itemBuilder: (context, ActiveSession activeSession, index, animation){
                                
                                return ListItemAnimation(
                                  animation: animation,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: LoginActivityCard(
                                      activeSession: activeSession
                                    ),
                                  ),
                                );
                              }
                            );
                          },
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

void showLogoutAllDialog(BuildContext context){
  RoundedAlertDialog(
    buildContext: context,
    svgImage: "assets/svg/notify.svg",
    svgScale: 0.35,
    svgBottomSpace: 48.0,
    title: context.l10n.alertDialog_logoutAll,
    description: context.l10n.alertDialog_logoutAll_description,
    actions: [
      RoundedAlertDialogButton(
        text: context.l10n.cancel,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop()
      ),

      RoundedAlertDialogButton(
        text: context.l10n.logoutAll_button,
        backgroundColor: cPrimaryColor,
        onPressed: (){
          // Close AlertDialog
          Navigator.of(context, rootNavigator: true).pop();

          context.read<AuthBloc>().add(AuthLogoutAllRequested());
        },
      ),
    ],
  ).show();
}