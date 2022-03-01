import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class TabIndicatorDecoration extends Decoration{
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return TabIndicatorPainter();
  }
}

class TabIndicatorPainter extends BoxPainter{
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {

    final tabWidth = configuration.size!.width;
    final tabHeight = configuration.size!.height;

    Rect rect = Rect.fromCenter(
      center: Offset(
        offset.dx + tabWidth / 2,
        offset.dy + tabHeight / 2
      ),
      width: tabWidth,
      height: tabHeight
    );

    final Paint paint = Paint();
    paint.color = cPrimaryColor;
    paint.style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(cBorderRadius)),
      paint
    );
  }
}