import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/constants.dart';

class EmptySpace extends StatelessWidget{

  final EdgeInsets padding;
  final String? svgImage;
  final double? svgHeight;
  final double svgBottomMargin;
  final String header;
  final int headerMaxLines;
  final bool headerFillLines;
  final String description;
  final int descriptionMaxLines;
  final bool descriptionFillLines;
  final double descriptionWidthFactor;

  const EmptySpace({
    this.padding = const EdgeInsets.symmetric(vertical: cPadding),
    this.svgImage,
    this.svgHeight,
    this.svgBottomMargin = 32.0,
    required this.header,
    this.headerMaxLines = 2,
    this.headerFillLines = false,
    required this.description,
    this.descriptionMaxLines = 4,
    this.descriptionFillLines = false,
    this.descriptionWidthFactor = 0.9
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          if(svgImage != null) Container(
            height: svgHeight,
            margin: EdgeInsets.only(bottom: svgBottomMargin),
            child: SvgPicture.asset(svgImage!)
          ),

          Text(
            header + (List.generate(headerFillLines ? headerMaxLines : 0, (_) => "\n").join()),
            textAlign: TextAlign.center,
            style: cTitleTextStyle,
            maxLines: headerMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.0),

          FractionallySizedBox(
            widthFactor: descriptionWidthFactor,
            child: Text(
              description + (List.generate(descriptionFillLines ? descriptionMaxLines : 0, (_) => "\n").join()),
              textAlign: TextAlign.center,
              style: cLightTextStyle,
              maxLines: descriptionMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}