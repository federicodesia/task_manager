import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/components/calendar/calendar_group_hour.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/rounded_snack_bar.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/notification_data.dart';
import 'package:task_manager/theme/theme.dart';

class NotificationListItem extends StatelessWidget{
  final BuildContext buildContext;
  final NotificationData data;

  const NotificationListItem({
    Key? key,
    required this.buildContext,
    required this.data
  }) : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext _) {
    final customTheme = Theme.of(buildContext).customTheme;

    final item = Row(
      children: [

        // Invisible text to maintain consistency with other items of the same style.
        const CalendarGroupHourText(text: "12:00", visible: false),

        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: customTheme.contentBackgroundColor,
              padding: const EdgeInsets.all(cListItemPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cBorderRadius),
              ),
              elevation: 0
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  
                  Container(
                    width: cLineSize,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                      color: data.type.color
                    )
                  ),
                  const SizedBox(width: 16.0),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.title,
                                style: customTheme.boldTextStyle,
                                maxLines: 1,
                              ),
                            ),

                            const SizedBox(width: 12.0),

                            Text(
                              (data.scheduledAt ?? data.createdAt).format(buildContext, "HH:mm a"),
                              style: customTheme.lightTextStyle,
                              maxLines: 1,
                            )
                          ],
                        ),

                        const SizedBox(height: 8.0),

                        Text(
                          data.body,
                          style: customTheme.lightTextStyle,
                          maxLines: 3
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        )
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: cListItemSpace),
      child: RoundedDismissible(
        text: buildContext.l10n.markAsRead,
        icon: Icons.done_all_rounded,
        color: Colors.blueAccent,
        child: item,
        onDismissed: (_) {
          final tempData = data;
          buildContext.read<NotificationsCubit>().markAsRead(tempData);

          RoundedSnackBar(
            context: buildContext,
            text: buildContext.l10n.notificationMarkedAsRead,
            action: SnackBarAction(
              label: buildContext.l10n.snackBar_undo,
              textColor: cPrimaryColor,
              onPressed: () => buildContext.read<NotificationsCubit>().undoMarkAsRead(tempData)
            )
          ).show();
        },
      ),
    );
  }
}