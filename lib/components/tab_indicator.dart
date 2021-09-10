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

    Rect rect = new Rect.fromCenter(
      center: Offset(
        offset.dx + tabWidth / 2,
        tabHeight - cTabIndicatorHeight / 2
      ),
      width: tabWidth,
      height: cTabIndicatorHeight
    );

    final Paint paint = Paint()
      ..color = cTabIndicatorColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: Radius.circular(8.0),
        topLeft: Radius.circular(8.0),
      ),
      paint,
    );
  }
}