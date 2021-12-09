import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class ShimmerText extends StatelessWidget{

  final bool isShimmer;
  final double shimmerTextHeight;
  final int shimmerMinTextLenght;
  final int shimmerMaxTextLenght;
  final String? text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  ShimmerText({
    required this.isShimmer,
    this.shimmerTextHeight = 0.8,
    required this.shimmerMinTextLenght,
    required this.shimmerMaxTextLenght,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Opacity(
          opacity: isShimmer ? 0.0 : 1.0,
          child: Text(
            text ?? "",
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),

        Opacity(
          opacity: isShimmer ? 1.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              color: cShimmerColor
            ),
            child: Opacity(
              opacity: 0,
              child: Text(
                (List.generate(shimmerMinTextLenght + Random().nextInt(shimmerMaxTextLenght - shimmerMinTextLenght), (_) => " ").join()),
                style: style != null ? style!.copyWith(height: shimmerTextHeight) : null,
                maxLines: maxLines,
                overflow: overflow,
              ),
            ),
          ),
        ),
      ],
    );
  }
}