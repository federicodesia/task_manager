import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/results_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_dynamic_task_list.dart';
import 'package:task_manager/components/lists/checkbox_task_list_item.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/main/floating_action_button.dart';
import 'package:task_manager/components/popup_menu_icon_item.dart';
import 'package:task_manager/components/responsive/fill_remaining_list.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_alert_dialog.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/shimmer/shimmer_list.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task_filter.dart';
import '../constants.dart';

class CategoryScreen extends StatelessWidget {

  final String? categoryId;
  CategoryScreen({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _CategoryScreen(categoryId: categoryId),
    );
  }
}

class _CategoryScreen extends StatefulWidget{

  final String? categoryId;
  _CategoryScreen({required this.categoryId});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<_CategoryScreen>{

  double appBarHeight = 500.0;
  GlobalKey<PopupMenuButtonState> popupMenuKey = GlobalKey<PopupMenuButtonState>();
  bool categoryDeleted = false;

  bool showFloatingActionButton = true;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
      floatingActionButton: AnimatedFloatingActionButton(
        visible: showFloatingActionButton,
        onPressed: () {
          ModalBottomSheet(
            title: "Create a task",
            context: context,
            content: TaskBottomSheet(
              initialcategoryId: widget.categoryId,
            ),
          ).show();
        },
      ),
      
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {

            return AnimatedFloatingActionButtonScrollNotification(
              currentState: showFloatingActionButton,
              onChange: (value) => setState(() => showFloatingActionButton = value),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
                ),
                slivers: [

                  BlocBuilder<CategoryBloc, CategoryState>(
                    buildWhen: (previousState, currentState){
                      if(currentState is CategoryLoadSuccess) return !categoryDeleted;
                      return true;
                    },
                    builder: (_, categoryState){

                      Category category = (categoryState as CategoryLoadSuccess).categories
                        .firstWhere((c) => c.id == widget.categoryId);

                      return SliverAppBar(
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        toolbarHeight: appBarHeight,
                        collapsedHeight: appBarHeight,

                        flexibleSpace: WidgetSize(
                          onChange: (Size size){
                            setState(() => appBarHeight = size.height);
                            BlocProvider.of<AvailableSpaceCubit>(context).setHeight(constraints.maxHeight - size.height);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              CenterAppBar(
                                center: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      style: cSubtitleTextStyle.copyWith(height: 1.0),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                actions: [
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
                                        enabled: !category.isGeneral,
                                        child: PopupMenuIconItem(
                                          icon: Icons.edit_outlined,
                                          text: "Edit"
                                        ),
                                      ),

                                      PopupMenuItem(
                                        value: 1,
                                        enabled: !category.isGeneral,
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
                                      color: cIconColor,
                                      icon: Icon(Icons.more_vert_rounded),
                                      splashRadius: cSplashRadius,
                                      onPressed: () {
                                        popupMenuKey.currentState!.showButtonMenu();
                                      },
                                    ),
                                  )
                                ],
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
                                                color: cLightGrayColor,
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
                                        color: cIconColor
                                      ),
                                      onPressed: () {
                                        ModalBottomSheet(
                                          title: "Results", 
                                          context: context, 
                                          content: ResultsBottomSheet(
                                            categoryScreenBloc: context.read<CategoryScreenBloc>(),
                                          )
                                        ).show();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                      child: BlocBuilder<CategoryScreenBloc, CategoryScreenState>(
                        builder: (_, state){

                          if(state is CategoryScreenLoadSuccess){

                            return Padding(
                              padding: EdgeInsets.only(top: cPadding - cListItemSpace),
                              child: AlignedAnimatedSwitcher(
                                alignment: Alignment.topCenter,
                                duration: cTransitionDuration,
                                child: state.items.isNotEmpty ? AnimatedDynamicTaskList(
                                  items: state.items,
                                  taskListItemType: TaskListItemType.Checkbox,
                                  context: context,
                                  onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task)),
                                  objectBuilder: (object){
                                    if(object is DateTime){
                                      DateTime now = DateTime.now();
                                      DateTime dateTime = object;

                                      String header;
                                      int difference = dateDifference(dateTime, now);
                                      if(difference == -1) header = "Yasterday";
                                      else if(difference == 0) header = "Today";
                                      else if(difference == 1) header = "Tomorrow";
                                      else if(dateTime.year != now.year) header = DateFormat('E, dd MMM y').format(dateTime);
                                      else header = DateFormat('E, dd MMM').format(dateTime);

                                      return ListHeader(header);
                                    }
                                    return Container();
                                  }
                                ) : FillRemainingList(
                                  availableSpaceCubit: BlocProvider.of<AvailableSpaceCubit>(context),
                                  child: EmptySpace(
                                    svgImage: "assets/svg/completed_tasks.svg",
                                    svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                      ? MediaQuery.of(context).size.width * 0.4
                                      : MediaQuery.of(context).size.height * 0.4,
                                    header: state.activeFilter == TaskFilter.All
                                      ? "You haven't tasks in this category!"
                                      : "You haven't ${getEnumValue(state.activeFilter).toLowerCase()} tasks!",
                                    description: state.activeFilter == TaskFilter.All
                                      ? "Categories help you organize easily. Add a new task by pressing the button below."
                                      : "There are no tasks with the current filter. Change it by pressing the button above.",
                                  )
                                )
                              ),
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(top: cPadding),
                            child: ShimmerList(
                              minItems: 3,
                              maxItems: 5,
                              child: CheckboxTaskListItem(isShimmer: true)
                            ),
                          );
                        }
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}