import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/screens/settings/security_screen.dart';
import '../../constants.dart';

class SettingsScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (_, authState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: cPadding
                            ).add(EdgeInsets.only(top: 32.0)),
                            child: Row(
                              children: [
                                RoundedButton(
                                  width: cButtonSize,
                                  color: cCardBackgroundColor,
                                  child: Image.asset(
                                    "assets/icons/profile.png"
                                  ),
                                  onPressed: () {},
                                ),
                                SizedBox(width: 16.0),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Federico De Sía",
                                        style: cSubtitleTextStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.0),

                                      Text(
                                        "desiafederico@gmail.com",
                                        style: cLightTextStyle,
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

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: cPadding,
                          horizontal: cPadding - 4.0
                        ),
                        child: Column(
                          children: [
                            Divider(color: cDividerColor),
                            //SizedBox(height: 8.0),

                            RoundedListTile(
                              title: "Dark mode",
                              icon: Icons.dark_mode_rounded,
                              suffix: SizedBox(
                                height: double.minPositive,
                                child: Switch(
                                  activeColor: cPrimaryColor,
                                  value: true,
                                  onChanged: (value) {},
                                ),
                              ),
                              onTap: () {},
                            ),

                            RoundedListTile(
                              title: "Language",
                              icon: Icons.language_rounded,
                              color: Color(0xFF6A69E0),
                              value: "English",
                              onTap: () {},
                            ),
                            //Divider(color: cDividerColor),
                            
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
                              onTap: () {},
                            ),

                            //SizedBox(height: 8.0),
                            Divider(color: cDividerColor),
                            //SizedBox(height: 8.0),

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
                              onTap: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              )
            );
          }
        ),
      )
    );
  }
}