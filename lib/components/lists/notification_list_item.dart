import 'package:flutter/material.dart';
import 'package:task_manager/components/calendar/calendar_group_hour.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/notification_data.dart';
import 'package:task_manager/theme/theme.dart';

class NotificationListItem extends StatelessWidget{
  final NotificationData data;

  const NotificationListItem({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Row(
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),

                            const SizedBox(width: 12.0),

                            Text(
                              (data.scheduledAt ?? data.createdAt).format(context, "HH:mm a"),
                              style: customTheme.lightTextStyle
                            )
                          ],
                        ),

                        const SizedBox(height: 8.0),

                        Text(
                          data.body,
                          style: customTheme.lightTextStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
  }
}