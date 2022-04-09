import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_manager/theme/theme.dart';

class ShimmerText extends StatelessWidget{

  final bool isShimmer;
  final double shimmerTextHeight;
  final int shimmerMinTextLenght;
  final int shimmerMaxTextLenght;
  final double shimmerProbability;
  final String? text;
  final TextStyle? style;
  final int? maxLines;
  final Alignment alignment;

  const ShimmerText({
    Key? key, 
    required this.isShimmer,
    this.shimmerTextHeight = 0.9,
    required this.shimmerMinTextLenght,
    required this.shimmerMaxTextLenght,
    this.shimmerProbability = 1.0,
    required this.text,
    this.style,
    this.maxLines,
    this.alignment = Alignment.centerLeft
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    if(!isShimmer) {
      return Text(
        text ?? "",
        style: style,
        maxLines: maxLines
      );
    }

    bool shimmerText = Random().nextDouble() <= shimmerProbability;

    return shimmerText ? Stack(
      alignment: alignment,
      children: [
        Text(
          "",
          style: style,
          maxLines: 1
        ),

        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            color: customTheme.shimmerColor
          ),
          child: Opacity(
            opacity: 0,
            child: Text(
              (List.generate(shimmerMinTextLenght + Random().nextInt(shimmerMaxTextLenght - shimmerMinTextLenght), (_) => " ").join()),
              style: style != null ? style!.copyWith(height: shimmerTextHeight) : null,
              maxLines: 1
            ),
          ),
        )
      ],
    ) : Container();
  }
}