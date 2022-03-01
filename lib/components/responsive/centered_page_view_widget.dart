import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

class CenteredPageViewWidget extends StatefulWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;
  final PageController? controller;
  final ScrollPhysics? physics;
  final void Function(int)? onPageChanged;
  final List<Widget> children;

  const CenteredPageViewWidget({
    Key? key, 
    required this.availableSpaceCubit,
    this.controller,
    this.physics,
    this.onPageChanged,
    required this.children
  }) : super(key: key);

  @override
  _CenteredPageViewWidgetState createState() => _CenteredPageViewWidgetState();
}

class _CenteredPageViewWidgetState extends State<CenteredPageViewWidget>{
  double childHeight = 0.0;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AvailableSpaceCubit, double>(
      bloc: widget.availableSpaceCubit,
      builder: (_, availableHeight) {
        
        return SizedBox(
          height: availableHeight > childHeight ? availableHeight : childHeight,
          child: PageView.builder(
            controller: widget.controller,
            physics: widget.physics,
            onPageChanged: widget.onPageChanged,
            itemCount: widget.children.length,
            itemBuilder: (context, index){

              return Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetSize(
                        onChange: (Size size) {
                          setState(() => childHeight = size.height);
                        },
                        child: widget.children.elementAt(index)
                      )
                    ],
                  ),
                ),
              );
            }
          )
        );
      }
    );
  }
}