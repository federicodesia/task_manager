import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/constants.dart';

class EmptySpace extends StatelessWidget{

  final String? svgImage;
  final double? svgHeight;
  final double svgBottomMargin;
  final String header;
  final String description;

  const EmptySpace({
    this.svgImage,
    this.svgHeight,
    this.svgBottomMargin = 32.0,
    required this.header,
    required this.description,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: cPadding),
      child: Column(
        children: [
          if(svgImage != null) Container(
            height: svgHeight,
            margin: EdgeInsets.only(bottom: svgBottomMargin),
            child: SvgPicture.asset(svgImage!)
          ),

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