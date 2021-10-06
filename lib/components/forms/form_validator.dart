import 'package:flutter/material.dart';

class FormValidator extends StatelessWidget{

  final Widget widget;
  final String Function(bool) validator;
  
  FormValidator({
    this.widget,
    this.validator
  });

  @override
  Widget build(BuildContext context) {

    ThemeData themeData = Theme.of(context);

    return FormField(
      builder: (FormFieldState<bool> state){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget,
            
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              alignment: Alignment.centerLeft,
              crossFadeState: state.hasError ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 16.0
                ),
                child: Text(
                  state.errorText.toString(),
                  style: themeData.textTheme.caption.copyWith(color: themeData.errorColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              secondChild: Container()
            )
          ],
        );
      },
      validator: validator,
    );
  }
}