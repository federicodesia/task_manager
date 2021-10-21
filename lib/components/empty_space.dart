import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/constants.dart';

class EmptySpace extends StatelessWidget{

  final String svgImage;
  final double svgHeight;
  final String header;
  final String description;

  const EmptySpace({
    this.svgImage,
    this.svgHeight,
    this.header,
    this.description,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: cPadding),
      child: Column(
        children: [
          SizedBox(
            height: svgHeight,
            child: SvgPicture.asset(svgImage)
          ),

          SizedBox(height: 48.0),

          Text(
            header,
            textAlign: TextAlign.center,
            style: cTitleTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.0),

          FractionallySizedBox(
            widthFactor: 0.9,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: cLightTextStyle,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}