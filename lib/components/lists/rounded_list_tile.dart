import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedListTile extends StatelessWidget {

  const RoundedListTile({
    Key? key, 
    required this.title,
    this.description,
    required this.icon,
    this.color = Colors.grey,
    this.counter,
    this.value,
    this.suffix,
    this.onTap
  }) : super(key: key);

  final String title;
  final String? description;
  final IconData? icon;
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [

            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedOpacity(
                        opacity: icon != null ? 1.0 : 0.0,
                        duration: cFastAnimationDuration,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            color: Color.alphaBlend(
                              color.withOpacity(0.25),
                              customTheme.backgroundColor
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 16.0,
                          )
                        ),
                      ),

                      const SizedBox(width: 16.0),

                      Expanded(
                        child: Text(
                          title,
                          style: customTheme.textStyle,
                          maxLines: 1
                        ),
                      )
                    ],
                  ),

                  if(description != null) Row(
                    children: [
                      const SizedBox(width: 36.0),
                      const SizedBox(width: 16.0),

                      Expanded(
                        child: Text(
                          description!,
                          style: customTheme.lightTextStyle,
                          maxLines: 3
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16.0),

            if(value != null) Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                value ?? "",
                style: customTheme.lightTextStyle,
                maxLines: 1
              ),
            ),

            if(counter != null) Container(
              margin: const EdgeInsets.only(right: 12.0),
              height: 28.0,
              width: 28.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: cRedColor,
              ),
              child: Text(
                counter ?? "",
                textAlign: TextAlign.center,
                style: customTheme.smallLightTextStyle,
                maxLines: 1
              )
            ),

            suffix == null ? const Padding(
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

class RoundedListTileSwitch extends StatelessWidget {

  const RoundedListTileSwitch({
    Key? key, 
    required this.title,
    this.description,
    required this.icon,
    this.color = Colors.grey,
    this.value = true,
    this.onSwitch
  }) : super(key: key);

  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final bool value;
  final void Function()? onSwitch;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return RoundedListTile(
      title: title,
      description: description,
      icon: icon,
      color: color,
      suffix: SizedBox(
        height: double.minPositive,
        child: Switch(
          activeColor: cPrimaryColor,
          inactiveThumbColor: Color.alphaBlend(customTheme.extraLightColor, customTheme.backgroundColor),
          value: value,
          onChanged: (value) {},
        ),
      ),
      onTap: (){
        if(onSwitch != null) onSwitch!();
      },
    );
  }
}