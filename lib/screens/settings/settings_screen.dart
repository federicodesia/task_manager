import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/rounded_button.dart';
import '../../constants.dart';


class SettingsScreen extends StatefulWidget{

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{

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
                  child: Padding(
                    padding: EdgeInsets.all(cPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (_, authState) {
                            return Row(
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

                                Column(
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
                                )
                              ],
                            );
                          },
                        ),

                        SizedBox(height: cPadding),
                        Divider(color: cDividerColor),
                        SizedBox(height: cPadding - 16.0),
                        
                        ListHeader("Login security"),
                        Column(
                          children: [
                            RoundedListTile(
                              title: "Change email",
                              icon: Icons.email_rounded,
                              color: Color(0xFFED2F7F),
                              onTap: () {},
                            ),
                            RoundedListTile(
                              title: "Change password",
                              icon: Icons.lock_rounded,
                              color: Color(0xFF12B9D5),
                              onTap: () {},
                            ),
                            RoundedListTile(
                              title: "Login activity",
                              icon: Icons.person_pin_rounded,
                              color: Color(0xFF1853A4),
                              suffix: "2",
                              onTap: () {},
                            ),
                          ]
                        ),

                        SizedBox(height: cPadding - 16.0),
                        Divider(color: cDividerColor),
                        SizedBox(height: cPadding - 16.0),

                        Column(
                          children: [
                            
                            RoundedListTile(
                              title: "Help",
                              icon: Icons.help_rounded,
                              color: Colors.grey,
                              onTap: () {},
                            ),
                            RoundedListTile(
                              title: "Information",
                              icon: Icons.info_rounded,
                              color: Colors.grey,
                              onTap: () {},
                            ),
                            RoundedListTile(
                              title: "Sign out",
                              icon: Icons.logout_rounded,
                              color: Colors.grey,
                              onTap: () {},
                            ),
                          ]
                        ),
                        
                      ],
                    ),
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