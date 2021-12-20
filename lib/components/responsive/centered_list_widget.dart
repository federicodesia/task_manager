import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';

class CenteredListWidget extends StatefulWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;
  final Widget child;
  final double subtractHeight;
  final bool subtractPadding;

  CenteredListWidget({
    required this.availableSpaceCubit,
    required this.child,
    this.subtractHeight = 0.0,
    this.subtractPadding = true
  });

  @override
  _CenteredListWidgetState createState() => _CenteredListWidgetState();
}

class _CenteredListWidgetState extends State<CenteredListWidget>{
  double childHeight = 0.0;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AvailableSpaceCubit, double>(
      bloc: widget.availableSpaceCubit,
      builder: (_, state) {
        double availableHeight = state - widget.subtractHeight;
        if(widget.subtractPadding) availableHeight -= cPadding * 2;

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
    );
  }
}