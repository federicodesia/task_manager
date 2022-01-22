import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedListTile extends StatelessWidget {

  RoundedListTile({
    required this.title,
    required this.icon,
    this.color = Colors.grey,
    this.counter,
    this.value,
    this.suffix,
    this.onTap
  });

  final String title;
  final IconData icon;
  final Color color;
  final String? counter;
  final String? value;
  final Widget? suffix;
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
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Color.alphaBlend(color.withOpacity(0.1), cBackgroundColor),
                //color: color
              ),
              child: Icon(
                icon,
                //color: color == cCardBackgroundColor ? Colors.white.withOpacity(0.5) : Colors.white,
                color: color,
                size: 16.0,
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

            if(value != null) Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                value ?? "",
                style: cExtraLightTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if(counter != null) Container(
              margin: EdgeInsets.only(right: 12.0),
              height: 28.0,
              width: 28.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: cRedColor,
              ),
              child: Text(
                counter ?? "",
                textAlign: TextAlign.center,
                style: cSmallLightTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ),

            suffix == null ? Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 14.0,
              ),
            ) : suffix!
          ],
        ),
      ),
    );
  }
}