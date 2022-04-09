import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';
import '../../constants.dart';

class SettingsNotificationsScreen extends StatelessWidget {
  const SettingsNotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _SettingsNotificationsScreen(),
    );
  }
}
class _SettingsNotificationsScreen extends StatefulWidget{

  @override
  _SettingsNotificationsScreenState createState() => _SettingsNotificationsScreenState();
}

class _SettingsNotificationsScreenState extends State<_SettingsNotificationsScreen>{

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
                    child: CenterAppBar(
                      center: Text(
                        context.l10n.settings_notifications,
                        style: customTheme.subtitleTextStyle,
                        maxLines: 1,
                      )
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(cPadding, 0, cPadding, cPadding),

                    child: BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (_, settingsState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            ListHeader(context.l10n.notificationsSettings_taskReminders),
                            RoundedListTileSwitch(
                              title: context.l10n.notificationsSettings_beforeSchedule,
                              description: context.l10n.notificationsSettings_beforeSchedule_description,
                              icon: Icons.schedule_outlined,
                              color: const Color(0xFF6B68E1),
                              value: settingsState.beforeScheduleNotification,
                              onSwitch: () => context.read<SettingsCubit>().toggleBeforeScheduleNotification()
                            ),

                            RoundedListTileSwitch(
                              title: context.l10n.notificationsSettings_taskSchedule,
                              description: context.l10n.notificationsSettings_taskSchedule_description,
                              icon: Icons.schedule_outlined,
                              color: const Color(0xFF31A8E1),
                              value: settingsState.taskScheduleNotification,
                              onSwitch: () => context.read<SettingsCubit>().toggleTaskScheduleNotification()
                            ),
                            

                            RoundedListTileSwitch(
                              title: context.l10n.notificationsSettings_uncompletedTask,
                              description: context.l10n.notificationsSettings_uncompletedTask_description,
                              icon: Icons.schedule_outlined,
                              color: const Color(0xFFB548C6),
                              value: settingsState.uncompletedTaskNotification,
                              onSwitch: () => context.read<SettingsCubit>().toggleUncompletedTaskNotification()
                            ),

                            const SizedBox(height: 8.0),
                            ListHeader(context.l10n.notificationsSettings_other),
                            RoundedListTileSwitch(
                              title: context.l10n.notificationsSettings_newUpdatesAvailable,
                              icon: Icons.system_update_alt_outlined,
                              color: const Color(0xFF21B17D),
                              value: settingsState.newUpdatesAvailableNotification,
                              onSwitch: () => context.read<SettingsCubit>().toggleNewUpdatesAvailableNotification()
                            ),

                            RoundedListTileSwitch(
                              title: context.l10n.notificationsSettings_announcementsAndOffers,
                              icon: Icons.local_offer_outlined,
                              color: const Color(0xFFFF8801),
                              value: settingsState.announcementsAndOffersNotification,
                              onSwitch: () => context.read<SettingsCubit>().toggleAnnouncementsAndOffersNotification()
                            ),
                          ],
                        );
                      }
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