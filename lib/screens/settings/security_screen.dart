import 'package:flutter/material.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import '../../constants.dart';

class SecurityScreen extends StatelessWidget{

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

                      CenterAppBar(
                        center: Text(
                          "Account security",
                          style: cSubtitleTextStyle,
                        )
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            /*Padding(
                              padding: EdgeInsets.symmetric(horizontal: cPadding),
                              child: EmptySpace(
                                svgImage: "assets/svg/newsletter.svg",
                                svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                  ? MediaQuery.of(context).size.width * 0.3
                                  : MediaQuery.of(context).size.height * 0.3,
                                svgBottomMargin: 48.0,
                                header: "Protect your account",
                                description: "Please enter the 4 character verification code sent to your email address.",
                              ),
                            ),*/

                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: cPadding
                                ).add(EdgeInsets.only(bottom: cPadding)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    ListHeader("Login security"),
                                    RoundedListTile(
                                      title: "Change email",
                                      icon: Icons.email_outlined,
                                      color: Color(0xFF6A69E0),
                                      onTap: () {},
                                    ),
                                    RoundedListTile(
                                      title: "Change password",
                                      icon: Icons.lock_outlined,
                                      color: Color(0xFF31A7E1),
                                      onTap: () {},
                                    ),
                                    RoundedListTile(
                                      title: "Sign out on all devices",
                                      icon: Icons.logout_outlined,
                                      color: Color(0xFFF57170),
                                      onTap: () {},
                                    ),

                                    SizedBox(height: 8.0),
                                    ListHeader("Related notifications"),
                                    RoundedListTile(
                                      title: "Login on a new device",
                                      icon: Icons.smartphone_outlined,
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

                                    SizedBox(height: 8.0),
                                    ListHeader("Login activity"),
                                    
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
                                            color: cCardBackgroundColor
                                          ),
                                          child: Icon(
                                            Icons.place_outlined,
                                            color: Colors.grey,
                                            size: 18.0,
                                          ),
                                        ),

                                        SizedBox(width: 16.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Galaxy J2 Prime",
                                              style: cLightTextStyle,
                                            ),
                                            SizedBox(height: 2.0),
                                            Text(
                                              "Chivilcoy, Buenos Aires, Argentina",
                                              style: cSmallExtraLightTextStyle,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                              

                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
                                            color: cCardBackgroundColor
                                          ),
                                          child: Icon(
                                            Icons.place_outlined,
                                            color: Colors.grey,
                                            size: 18.0,
                                          ),
                                        ),

                                        SizedBox(width: 16.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Xiaomi Redmi 9A",
                                              style: cLightTextStyle,
                                            ),
                                            SizedBox(height: 2.0),
                                            Text(
                                              "Chivilcoy, Buenos Aires, Argentina",
                                              style: cSmallExtraLightTextStyle,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
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