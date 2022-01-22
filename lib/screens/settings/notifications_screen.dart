import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import '../../constants.dart';

class NotificationsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _NotificationsScreen(),
    );
  }
}
class _NotificationsScreen extends StatefulWidget{

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<_NotificationsScreen>{

  double appBarHeight = 500.0;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
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
                        "Notifications",
                        style: cSubtitleTextStyle,
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
                        
                        ListHeader("Task reminders"),
                        RoundedListTileSwitch(
                          title: "Before schedule",
                          description: "Receive a notification 15 minutes before a task starts.",
                          icon: Icons.schedule_outlined,
                          color: Color(0xFF6B68E1),
                          onChanged: (value) {},
                        ),

                        RoundedListTileSwitch(
                          title: "Task schedule",
                          description: "Receive a notification at the moment a task starts.",
                          icon: Icons.schedule_outlined,
                          color: Color(0xFF31A8E1),
                          onChanged: (value) {},
                        ),
                        

                        RoundedListTileSwitch(
                          title: "Uncompleted task",
                          description: "Receive a notification 1 hour later if the task was not completed.",
                          icon: Icons.schedule_outlined,
                          color: Color(0xFFB548C6),
                          onChanged: (value) {},
                        ),

                        SizedBox(height: 8.0),
                        ListHeader("Other"),
                        RoundedListTileSwitch(
                          title: "New updates available",
                          icon: Icons.system_update_alt_outlined,
                          color: Color(0xFF21B17D),
                          onChanged: (value) {},
                        ),

                        RoundedListTileSwitch(
                          title: "Announcements and offers",
                          icon: Icons.local_offer_outlined,
                          color: Color(0xFFFF8801),
                          onChanged: (value) {},
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