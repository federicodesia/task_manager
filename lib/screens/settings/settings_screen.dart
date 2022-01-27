import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/cubits/theme_cubit.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../../constants.dart';

class SettingsScreen extends StatelessWidget {

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
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (_, authState) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 32.0,
                            horizontal: cPadding
                          ),
                          child: Row(
                            children: [
                              RoundedButton(
                                width: cButtonSize,
                                color: customTheme.contentBackgroundColor,
                                child: Image.asset(
                                  "assets/icons/profile.png"
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(width: 16.0),

                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      authState.user.name,
                                      style: customTheme.subtitleTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2.0),

                                    Text(
                                      authState.user.email,
                                      style: customTheme.lightTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),
                    child: Column(
                      children: [
                        Divider(),

                        RoundedListTileSwitch(
                          title: "Dark mode",
                          icon: Icons.dark_mode_rounded,
                          onChanged: (darkMode) {
                            context.read<ThemeCubit>().toggle();
                          },
                        ),

                        RoundedListTile(
                          title: "Language",
                          icon: Icons.language_rounded,
                          color: Color(0xFF6A69E0),
                          value: "English",
                          onTap: () {},
                        ),
                        //Divider(),
                        
                        RoundedListTile(
                          title: "Security",
                          icon: Icons.lock_rounded,
                          color: Color(0xFF31A7E1),
                          onTap: () => AutoRouter.of(context).navigate(SecurityRoute()),
                        ),
                        RoundedListTile(
                          title: "Notifications",
                          icon: Icons.notifications_rounded,
                          color: Color(0xFFB548C5),
                          onTap: () => AutoRouter.of(context).navigate(NotificationsRoute()),
                        ),

                        Divider(),

                        RoundedListTile(
                          title: "Help",
                          icon: Icons.help_rounded,
                          onTap: () {},
                        ),
                        RoundedListTile(
                          title: "Information",
                          icon: Icons.info_rounded,
                          onTap: () {},
                        ),
                        RoundedListTile(
                          title: "Sign out",
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