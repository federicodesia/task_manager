import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';

class FillRemainingList extends StatefulWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;
  final Alignment alignment;
  final Widget child;
  final double subtractHeight;
  final bool subtractPadding;

  const FillRemainingList({
    Key? key, 
    required this.availableSpaceCubit,
    this.alignment = Alignment.center,
    required this.child,
    this.subtractHeight = 0.0,
    this.subtractPadding = true
  }) : super(key: key);

  @override
  _FillRemainingListState createState() => _FillRemainingListState();
}

class _FillRemainingListState extends State<FillRemainingList>{
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
          child: Align(
            alignment: widget.alignment,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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