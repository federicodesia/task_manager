import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedListTile extends StatelessWidget {

  RoundedListTile({
    required this.title,
    required this.icon,
    this.color = cPrimaryColor,
    this.suffix,
    this.arrowEnabled = true,
    this.onTap
  });

  final String title;
  final IconData icon;
  final Color color;
  final String? suffix;
  final bool arrowEnabled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cBorderRadius),
      
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: Color.alphaBlend(color.withOpacity(0.1), cBackgroundColor),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18.0,
              )
            ),
            SizedBox(width: 16.0),

            Expanded(
              child: Text(
                title,
                style: cLightTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if(suffix != null) Container(
              margin: EdgeInsets.only(right: 12.0),
              height: 28.0,
              width: 28.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: cRedColor,
              ),
              child: Text(
                suffix ?? "",
                textAlign: TextAlign.center,
                style: cSmallLightTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ),

            if(arrowEnabled) Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16.0,
            )
          ],
        ),
      ),
    );
  }
}