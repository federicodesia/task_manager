import 'package:flutter/material.dart';

class CenterAppBar extends StatelessWidget {

  final Widget center;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  
  CenterAppBar({
    required this.center,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if(leading != null) leading!
                else if(automaticallyImplyLeading && canPop) IconButton(
                  color: Colors.white.withOpacity(0.75),
                  icon: Icon(Icons.navigate_before_rounded),
                  splashRadius: 32.0,
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