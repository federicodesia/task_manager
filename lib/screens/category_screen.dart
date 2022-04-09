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
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/lists/animated_dynamic_task_list.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/main/floating_action_button.dart';
import 'package:task_manager/components/popup_menu_icon_item.dart';
import 'package:task_manager/components/responsive/fill_remaining_list.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_alert_dialog.dart';
import 'package:task_manager/components/rounded_button.dart';
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

  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: customTheme.backgroundColor,
        floatingActionButton: TaskFloatingActionButton(
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
                        if(currentState.categories.firstWhereOrNull((c) => c.id == widget.categoryId) != null){
                          return true;
                        }
                        return false;
                      },
                      builder: (_, categoryState){

                        final category = categoryState.categories
                          .firstWhere((c) => c.id == widget.categoryId);

                        return SliverAppBar(
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          toolbarHeight: appBarHeight,
                          collapsedHeight: appBarHeight,

                          flexibleSpace: WidgetSize(
                            onChange: (Size size){
                              setState(() => appBarHeight = size.height);
                              context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height);
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
                                        maxLines: 1
                                      )
                                    ],
                                  ),
                                  actions: [
                                    _CategoryScreenPopupButton(category: category)
                                  ],
                                ),
                               const SizedBox(height: cPadding - 16.0),
                                
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: cPadding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RoundedTextFormField(
                                          controller: searchTextController,
                                          hintText: context.l10n.searchTask,
                                          textInputAction: TextInputAction.done,
                                          prefixIcon: Icon(
                                            Icons.search_rounded,
                                            color: customTheme.lightColor,
                                          ),
                                          onChanged: (searchText){
                                            context.read<CategoryScreenBloc>().add(SearchTextChanged(searchText));
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 12.0),
                                      RoundedButton(
                                        expandWidth: false,
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

                            return Padding(
                              padding: const EdgeInsets.only(top: cPadding - cListItemSpace),
                              child: AlignedAnimatedSwitcher(
                                alignment: Alignment.topCenter,
                                child: state.items.isNotEmpty ? AnimatedDynamicTaskList(
                                  key: const Key("AnimatedDynamicTaskList"),
                                  items: state.items,
                                  taskListItemType: TaskListItemType.checkbox,
                                  buildContext: context,
                                  onUndoDismissed: (task) => context.read<TaskBloc>().add(TaskUndoDeleted(task)),
                                  objectBuilder: (object){
                                    if(object is DateTime){
                                      final DateTime dateTime = object;
                                      return ListHeader(dateTime.humanFormat(context));
                                    }
                                    return Container();
                                  }
                                ) : FillRemainingList(
                                  key: Key(state.searchText.isEmpty
                                    ? "EmptySpace ${state.activeFilter}"
                                    : "EmptySpace NotFound"
                                  ),
                                  availableSpaceCubit: context.read<AvailableSpaceCubit>(),
                                  child: state.searchText.isEmpty ? EmptySpace(
                                    svgImage: "assets/svg/completed_tasks.svg",
                                    header: state.activeFilter == TaskFilter.all
                                      ? context.l10n.emptySpace_youHaventTasksInCategory
                                      : context.l10n.emptySpace_youHaventTasksWithActiveFilter(
                                        state.activeFilter.nameLocalization(context).toLowerCase()
                                      ),
                                    description: state.activeFilter == TaskFilter.all
                                      ? context.l10n.emptySpace_youHaventTasksInCategory_description
                                      : context.l10n.emptySpace_youHaventTasksWithActiveFilter_description,
                                  ) : EmptySpace(
                                    svgImage: "assets/svg/not_found.svg",
                                    header: context.l10n.emptySpace_noResultsFound,
                                    description: context.l10n.emptySpace_noResultsFound_description
                                  )
                                )
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
                  context.read<CategoryBloc>().add(CategoryDeleted(category));
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