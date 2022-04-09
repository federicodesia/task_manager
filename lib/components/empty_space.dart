import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/theme/theme.dart';

class EmptySpace extends StatelessWidget{

  final EdgeInsets padding;
  final String? svgImage;
  final double svgScale;
  final double svgBottomSpace;
  final String header;
  final int headerMaxLines;
  final bool headerFillLines;
  final String description;
  final int descriptionMaxLines;
  final bool descriptionFillLines;

  const EmptySpace({
    Key? key, 
    this.padding = const EdgeInsets.symmetric(vertical: cPadding),
    this.svgImage,
    this.svgScale = 0.35,
    this.svgBottomSpace = 32.0,
    required this.header,
    this.headerMaxLines = 2,
    this.headerFillLines = false,
    required this.description,
    this.descriptionMaxLines = 4,
    this.descriptionFillLines = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    final mediaQuery = MediaQuery.of(context);
    
    return Padding(
      padding: padding,
      child: Column(
        children: [
          if(svgImage != null) Container(
            height: mediaQuery.orientation == Orientation.portrait
              ? mediaQuery.size.width * svgScale
              : mediaQuery.size.height * svgScale,
            margin: EdgeInsets.only(bottom: svgBottomSpace),
            child: SvgPicture.asset(svgImage!)
          ),

          FractionallySizedBox(
            widthFactor: mediaQuery.orientation == Orientation.portrait ? 0.9 : 0.45,
            child: Column(
              children: [
                Text(
                  header.fillLines(headerFillLines ? headerMaxLines : 0),
                  textAlign: TextAlign.center,
                  style: customTheme.titleTextStyle,
                  maxLines: headerMaxLines
                ),

                const SizedBox(height: 16.0),
                Text(
                  description.fillLines(descriptionFillLines ? descriptionMaxLines : 0),
                  textAlign: TextAlign.center,
                  style: customTheme.lightTextStyle,
                  maxLines: descriptionMaxLines
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}