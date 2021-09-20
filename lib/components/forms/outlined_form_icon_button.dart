import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class OutlinedFormIconButton extends StatelessWidget{

  final IconData icon;
  final String text;
  final Color? outlineColor;
  final Function() onPressed;
  OutlinedFormIconButton({required this.icon, required this.text, this.outlineColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF9192A6)
          ),

          Expanded(
            child: Text(
              text,
              style: cLightTextStyle.copyWith(fontSize: 13.5),
              textAlign: TextAlign.center
            ),
          )
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0
        ),
        side: BorderSide(
          width: 1.0,
          color: outlineColor ?? Color(0xFF2B3039)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}