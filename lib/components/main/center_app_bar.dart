import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class CenterAppBar extends StatelessWidget {

  final Widget center;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  
  const CenterAppBar({
    Key? key, 
    required this.center,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if(leading != null) leading!
                else if(automaticallyImplyLeading && canPop) IconButton(
                  color: customTheme.lightColor,
                  icon: const Icon(Icons.navigate_before_rounded,),
                  splashRadius: cSplashRadius,
                  onPressed: () => Navigator.of(context).maybePop()
                ),
              ],
            ),
          ),
          
          center,

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions != null ? actions! : []
            ),
          )
        ],
      ),
    );
  }
}