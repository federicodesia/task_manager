import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/bottom_sheets/language_bottom_sheet.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/locale_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../../constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _SettingsScreen(),
    );
  }
}

class _SettingsScreen extends StatefulWidget{

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen>{

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
                    onChange: (Size size){
                      setState(() => appBarHeight = size.height);
                      context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height);
                    },
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (_, authState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 32.0,
                            horizontal: cPadding
                          ),
                          child: GestureDetector(
                            onTap: () => AutoRouter.of(context).navigate(const ProfileRoute()),
                            child: Row(
                              children: [
                                RoundedButton(
                                  expandWidth: false,
                                  width: cButtonSize,
                                  color: customTheme.contentBackgroundColor,
                                  child: Image.asset(
                                    "assets/icons/profile.png"
                                  ),
                                  onPressed: () => AutoRouter.of(context).navigate(const ProfileRoute()),
                                ),
                                const SizedBox(width: 16.0),

                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        authState.user?.name ?? "",
                                        style: customTheme.subtitleTextStyle,
                                        maxLines: 1
                                      ),
                                      const SizedBox(height: 2.0),

                                      Text(
                                        authState.user?.email ?? "",
                                        style: customTheme.lightTextStyle,
                                        maxLines: 1
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),
                    child: Column(
                      children: [
                        const Divider(),

                        RoundedListTileSwitch(
                          title: context.l10n.settings_darkMode,
                          icon: Icons.dark_mode_rounded,
                          value: Theme.of(context).brightness == Brightness.dark,
                          onSwitch: () => context.read<SettingsCubit>().toggleThemeMode(context)
                        ),

                        RoundedListTile(
                          title: context.l10n.settings_language,
                          icon: Icons.language_rounded,
                          color: const Color(0xFF6A69E0),
                          value: Localizations.localeOf(context).name,
                          onTap: () => LanguageBottomSheet(context).show()
                        ),
                        //Divider(),
                        
                        RoundedListTile(
                          title: context.l10n.settings_security,
                          icon: Icons.lock_rounded,
                          color: const Color(0xFF31A7E1),
                          onTap: () => AutoRouter.of(context).navigate(const SecurityRoute()),
                        ),
                        RoundedListTile(
                          title: context.l10n.settings_notifications,
                          icon: Icons.notifications_rounded,
                          color: const Color(0xFFB548C5),
                          onTap: () => AutoRouter.of(context).navigate(const SettingsNotificationsRoute()),
                        ),

                        const Divider(),

                        RoundedListTile(
                          title: context.l10n.settings_help,
                          icon: Icons.help_rounded,
                          onTap: () {},
                        ),
                        RoundedListTile(
                          title: context.l10n.settings_information,
                          icon: Icons.info_rounded,
                          onTap: () {},
                        ),
                        RoundedListTile(
                          title: context.l10n.settings_signOut,
                          icon: Icons.logout_rounded,
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                          },
                        ),
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