import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/models/category.dart';
import '../constants.dart';

class CategoryScreen extends StatefulWidget{

  final String categoryUuid;
  CategoryScreen({required this.categoryUuid});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>{

  double appBarHeight = 500.0;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,

      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (_, categoryState) {
          
          Category category = (categoryState as CategoryLoadSuccess).categories.firstWhere((c) => c.uuid == widget.categoryUuid);

          return SafeArea(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [

                SliverAppBar(
                  backgroundColor: Colors.transparent,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(cBorderRadius),
                    ),
                  ),

                  automaticallyImplyLeading: false,
                  collapsedHeight: appBarHeight,
                  flexibleSpace: WidgetSize(
                    onChange: (Size size) => setState(() => appBarHeight = size.height),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                color: Colors.white.withOpacity(0.75),
                                icon: Icon(Icons.navigate_before_rounded),
                                splashRadius: 32.0,
                                onPressed: () {
                                  Navigator.of(context).maybePop();
                                },
                              ),

                              Row(
                                children: [
                                  Container(
                                    height: 8.0,
                                    width: 8.0,
                                    decoration: BoxDecoration(
                                      color: category.color,
                                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                                    )
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    category.name,
                                    style: cTitleTextStyle.copyWith(fontSize: 16.0, height: 1.0),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),

                              IconButton(
                                color: Colors.white.withOpacity(0.75),
                                icon: Icon(Icons.more_vert_rounded),
                                splashRadius: 32.0,
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: cPadding - 16.0),
                        
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: cPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
                                    color: cCardBackgroundColor
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search_rounded,
                                          color: Colors.white.withOpacity(0.25),
                                        ),
                                        SizedBox(width: 12.0),
                                        Text(
                                          "Search task...",
                                          style: cLightTextStyle.copyWith(height: 1.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12.0),
                              RoundedButton(
                                width: 56.0,
                                height: 56.0,
                                color: cCardBackgroundColor,
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white.withOpacity(0.75)
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: cPadding),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          );
        }
      )
    );
  }
}