import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedListTile extends StatelessWidget {

  RoundedListTile({
    required this.title,
    this.description,
    required this.icon,
    this.color = Colors.grey,
    this.counter,
    this.value,
    this.suffix,
    this.onTap
  });

  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final String? counter;
  final String? value;
  final Widget? suffix;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cBorderRadius),
      
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [

            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Color.alphaBlend(color.withOpacity(0.1), Theme.of(context).scaffoldBackgroundColor),
                          //color: color
                        ),
                        child: Icon(
                          icon,
                          //color: color == customTheme.contentBackgroundColor ? Colors.white.withOpacity(0.5) : Colors.white,
                          color: color,
                          size: 16.0,
                        )
                      ),

                      SizedBox(width: 16.0),

                      Expanded(
                        child: Text(
                          title,
                          style: customTheme.lightTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),

                  if(description != null) Row(
                    children: [
                      SizedBox(width: 36.0),
                      SizedBox(width: 16.0),

                      Expanded(
                        child: Text(
                          description!,
                          style: customTheme.smallExtraLightTextStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 16.0),

            if(value != null) Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                value ?? "",
                style: customTheme.extraLightTextStyle,
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
                style: customTheme.smallLightTextStyle,
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

class RoundedListTileSwitch extends StatefulWidget{

  RoundedListTileSwitch({
    required this.title,
    this.description,
    required this.icon,
    this.color = Colors.grey,
    this.initialValue = true,
    this.onChanged
  });

  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final bool initialValue;
  final void Function(bool)? onChanged;

  @override
  State<RoundedListTileSwitch> createState() => _RoundedListTileSwitchState();
}

class _RoundedListTileSwitchState extends State<RoundedListTileSwitch> {

  late bool switchValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return RoundedListTile(
      title: widget.title,
      description: widget.description,
      icon: widget.icon,
      color: widget.color,
      suffix: SizedBox(
        height: double.minPositive,
        child: Switch(
          activeColor: cPrimaryColor,
          inactiveThumbColor: Color.alphaBlend(customTheme.extraLightColor, customTheme.backgroundColor),
          value: switchValue,
          onChanged: (value) {},
        ),
      ),
      onTap: (){
        setState(() => switchValue = !switchValue);
        if(widget.onChanged != null) widget.onChanged!(switchValue);
      },
    );
  }
}