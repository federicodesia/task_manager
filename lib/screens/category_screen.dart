import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
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
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task_filter.dart';
import 'package:task_manager/theme/theme.dart';
import 'package:collection/collection.dart';
import '../constants.dart';

class CategoryScreen extends StatelessWidget {

  final String? categoryId;

  const CategoryScreen({
    Key? key,
    required this.categoryId
  }) : super(key: key);

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
  const _CategoryScreen({required this.categoryId});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<_CategoryScreen>{

  double appBarHeight = 500.0;

  bool showFloatingActionButton = true;

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      floatingActionButton: AnimatedFloatingActionButton(
        visible: showFloatingActionButton,
        onPressed: () {
          TaskBottomSheet(
            context,
            initialcategoryId: widget.categoryId,
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
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
                ),
                slivers: [

                  BlocBuilder<CategoryBloc, CategoryState>(
                    buildWhen: (previousState, currentState){
                      if(currentState is CategoryLoadSuccess){
                        if(currentState.categories.firstWhereOrNull((c) => c.id == widget.categoryId) != null) return true;
                        return false;
                      }
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
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0))
                                      )
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      category.name,
                                      style: customTheme.subtitleTextStyle.copyWith(height: 1.0),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                actions: [
                                  _CategoryScreenPopupButton(category: category)
                                ],
                              ),
                             const  SizedBox(height: cPadding - 16.0),
                              
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: cPadding),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius)),
                                          color: customTheme.contentBackgroundColor
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.search_rounded,
                                                color: customTheme.lightColor,
                                              ),
                                              const SizedBox(width: 12.0),
                                              Text(
                                                context.l10n.searchTask,
                                                style: customTheme.lightTextStyle.copyWith(height: 1.0),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12.0),
                                    RoundedButton(
                                      width: 56.0,
                                      height: 56.0,
                                      color: customTheme.contentBackgroundColor,
                                      child: Icon(
                                        Icons.tune_rounded,
                                        color: customTheme.lightColor
                                      ),
                                      onPressed: () => ResultsBottomSheet(
                                        context,
                                        categoryScreenBloc: context.read<CategoryScreenBloc>()
                                      ).show(),
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
                      padding: const EdgeInsets.symmetric(horizontal: cPadding),
                      child: BlocBuilder<CategoryScreenBloc, CategoryScreenState>(
                        builder: (_, state){

                          if(state is CategoryScreenLoadSuccess){

                            return Padding(
                              padding: const EdgeInsets.only(top: cPadding - cListItemSpace),
                              child: AlignedAnimatedSwitcher(
                                alignment: Alignment.topCenter,
                                duration: cTransitionDuration,
                                child: state.items.isNotEmpty ? AnimatedDynamicTaskList(
                                  items: state.items,
                                  taskListItemType: TaskListItemType.checkbox,
                                  buildContext: context,
                                  onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskUndoDeleted(task)),
                                  objectBuilder: (object){
                                    if(object is DateTime){
                                      final DateTime dateTime = object;
                                      return ListHeader(dateTime.humanFormat(context));
                                    }
                                    return Container();
                                  }
                                ) : FillRemainingList(
                                  availableSpaceCubit: BlocProvider.of<AvailableSpaceCubit>(context),
                                  child: EmptySpace(
                                    svgImage: "assets/svg/completed_tasks.svg",
                                    header: state.activeFilter == TaskFilter.all
                                      ? context.l10n.emptySpace_youHaventTasksInCategory
                                      : context.l10n.emptySpace_youHaventTasksWithActiveFilter(state.activeFilter.nameLocalization(context).toLowerCase()),
                                    description: state.activeFilter == TaskFilter.all
                                      ? context.l10n.emptySpace_youHaventTasksInCategory_description
                                      : context.l10n.emptySpace_youHaventTasksWithActiveFilter_description,
                                  )
                                )
                              ),
                            );
                          }

                          return const Padding(
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

class _CategoryScreenPopupButton extends StatelessWidget{

  final Category category;
  const _CategoryScreenPopupButton({required this.category});

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    final popupMenuKey = GlobalKey<PopupMenuButtonState>();

    return PopupMenuButton(
      key: popupMenuKey,
      color: customTheme.contentBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      elevation: 4,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          enabled: !category.isGeneral,
          child: PopupMenuIconItem(
            icon: Icons.edit_outlined,
            text: context.l10n.edit
          ),
        ),

        PopupMenuItem(
          value: 1,
          enabled: !category.isGeneral,
          child: PopupMenuIconItem(
            icon: Icons.delete_outlined,
            text: context.l10n.delete
          ),
        ),
      ],
      onSelected: (value){
        if(value == 0){
          CategoryBottomSheet(
            context,
            editCategory: category
          ).show();
        }
        else if(value == 1){
          RoundedAlertDialog(
            buildContext: context,
            title: context.l10n.alertDialog_deleteCategory,
            description: context.l10n.alertDialog_deleteCategory_description,
            actions: [
              RoundedAlertDialogButton(
                text: context.l10n.delete,
                backgroundColor: cRedColor,
                onPressed: (){
                  // Close AlertDialog
                  Navigator.of(context, rootNavigator: true).pop();
                  BlocProvider.of<CategoryBloc>(context).add(CategoryDeleted(category));
                  // Close screen
                  Navigator.of(context).pop();
                },
              ),

              RoundedAlertDialogButton(
                text: context.l10n.cancel,
                onPressed: () => Navigator.of(context, rootNavigator: true).pop()
              ),
            ],
          ).show();
        }
      },
      child: IconButton(
        color: customTheme.lightColor,
        icon: const Icon(Icons.more_vert_rounded),
        splashRadius: cSplashRadius,
        onPressed: () {
          popupMenuKey.currentState!.showButtonMenu();
        },
      ),
    );
  }
}