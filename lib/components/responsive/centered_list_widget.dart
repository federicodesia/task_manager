import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';

class CenteredListWidget extends StatefulWidget{
  final Widget child;
  final BuildContext context;

  CenteredListWidget({this.context, this.child});

  @override
  _CenteredListWidgetState createState() => _CenteredListWidgetState();
}

class _CenteredListWidgetState extends State<CenteredListWidget>{
  double childHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom -
      BlocProvider.of<AppBarCubit>(context).state;

    return SizedBox(
      height: availableHeight > childHeight ? availableHeight : childHeight,
      child: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetSize(
                onChange: (Size size) {
                  setState(() => childHeight = size.height);
                },
                child: widget.child,
              )
            ],
          ),
        ),
      ),
    );
  }
}