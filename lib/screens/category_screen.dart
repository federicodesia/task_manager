import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/models/category.dart';
import '../constants.dart';

class CategoryScreen extends StatefulWidget{

  final String categoryUuid;
  CategoryScreen({required this.categoryUuid});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,

      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (_, categoryState) {
          
          Category category = (categoryState as CategoryLoadSuccess).categories.firstWhere((c) => c.uuid == widget.categoryUuid);

          return CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            slivers: [

              SliverAppBar(
                backgroundColor: cCardBackgroundColor,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(cBorderRadius),
                  ),
                ),

                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      style: cTitleTextStyle.copyWith(fontSize: 17.0, height: 1.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),

                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert_rounded)
                  )
                ],
              ),
            ]
          );
        }
      )
    );
  }
}