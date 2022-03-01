import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/constants.dart';
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
  final double descriptionWidthFactor;

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
    this.descriptionWidthFactor = 0.9
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Padding(
      padding: padding,
      child: Column(
        children: [
          if(svgImage != null) Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * svgScale
              : MediaQuery.of(context).size.height * svgScale,
            margin: EdgeInsets.only(bottom: svgBottomSpace),
            child: SvgPicture.asset(svgImage!)
          ),

          Text(
            header + (List.generate(headerFillLines ? headerMaxLines : 0, (_) => "\n").join()),
            textAlign: TextAlign.center,
            style: customTheme.titleTextStyle,
            maxLines: headerMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),

          FractionallySizedBox(
            widthFactor: descriptionWidthFactor,
            child: Text(
              description + (List.generate(descriptionFillLines ? descriptionMaxLines : 0, (_) => "\n").join()),
              textAlign: TextAlign.center,
              style: customTheme.lightTextStyle,
              maxLines: descriptionMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}