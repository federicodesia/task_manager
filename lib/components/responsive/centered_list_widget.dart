import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';

class CenteredListWidget extends StatefulWidget{
  
  final Widget child;
  final double subtractHeight;

  CenteredListWidget({
    required this.child,
    this.subtractHeight = 0.0
  });

  @override
  _CenteredListWidgetState createState() => _CenteredListWidgetState();
}

class _CenteredListWidgetState extends State<CenteredListWidget>{
  double childHeight = 0.0;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AvailableSpaceCubit, double>(
      builder: (_, state) {
        final availableHeight = state - cPadding * 2 - widget.subtractHeight;

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