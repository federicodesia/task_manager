import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';

class CenteredListWidget extends StatefulWidget{
  
  final Widget child;
  CenteredListWidget({this.child});

  @override
  _CenteredListWidgetState createState() => _CenteredListWidgetState();
}

class _CenteredListWidgetState extends State<CenteredListWidget>{
  double childHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final availableHeight = BlocProvider.of<AvailableSpaceCubit>(context).state -
      BlocProvider.of<AppBarCubit>(context).state - cPadding * 2;

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