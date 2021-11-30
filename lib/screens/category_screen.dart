import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/results_bottom_sheet.dart';
import 'package:task_manager/components/popup_menu_icon_item.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_alert_dialog.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/models/category.dart';
import '../constants.dart';

class CategoryScreen extends StatefulWidget{

  final String categoryUuid;
  CategoryScreen({required this.categoryUuid,});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>{

  double appBarHeight = 500.0;
  GlobalKey<PopupMenuButtonState> popupMenuKey = GlobalKey<PopupMenuButtonState>();
  bool categoryDeleted = false;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,

      body: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previousState, currentState){
          if(currentState is CategoryLoadSuccess) return !categoryDeleted;
          return true;
        },
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

                              PopupMenuButton(
                                key: popupMenuKey,
                                color: cCardBackgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                                elevation: 4,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: PopupMenuIconItem(
                                      icon: Icons.edit_outlined,
                                      text: "Edit"
                                    ),
                                  ),

                                  PopupMenuItem(
                                    value: 1,
                                    child: PopupMenuIconItem(
                                      icon: Icons.delete_outlined,
                                      text: "Delete"
                                    ),
                                  ),
                                ],
                                onSelected: (value){
                                  if(value == 0){
                                    ModalBottomSheet(
                                      title: "Edit category", 
                                      context: context, 
                                      content: CategoryBottomSheet(editCategory: category)
                                    ).show();
                                  }
                                  else if(value == 1){
                                    RoundedAlertDialog(
                                      buildContext: context,
                                      title: "Delete this category?",
                                      description: "Do you really want to delete this category? All tasks will be unlinked without being deleted. This process cannot be undone.",
                                      actions: [
                                        RoundedAlertDialogButton(
                                          text: "Cancel",
                                          onPressed: () => Navigator.of(context).pop()
                                        ),

                                        RoundedAlertDialogButton(
                                          text: "Delete",
                                          backgroundColor: cRedColor,
                                          onPressed: (){
                                            // Close AlertDialog
                                            Navigator.of(context).pop();

                                            setState(() => categoryDeleted = true);
                                            BlocProvider.of<CategoryBloc>(context).add(CategoryDeleted(category));
                                            
                                            // Close screen
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ).show();
                                  }
                                },
                                child: IconButton(
                                  color: Colors.white.withOpacity(0.75),
                                  icon: Icon(Icons.more_vert_rounded),
                                  splashRadius: 32.0,
                                  onPressed: () {
                                    popupMenuKey.currentState!.showButtonMenu();
                                  },
                                ),
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
                                onPressed: () {
                                  ModalBottomSheet(
                                    title: "Results", 
                                    context: context, 
                                    content: ResultsBottomSheet()
                                  ).show();
                                },
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