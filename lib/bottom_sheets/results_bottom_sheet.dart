import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:task_manager/components/animated_chip.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/task_filter.dart';
import 'package:task_manager/theme/theme.dart';

class ResultsBottomSheet extends StatefulWidget{

  final CategoryScreenBloc categoryScreenBloc;
  ResultsBottomSheet({required this.categoryScreenBloc});

  @override
  _ResultsBottomSheetState createState() => _ResultsBottomSheetState();
}

class _ResultsBottomSheetState extends State<ResultsBottomSheet>{

  late CategoryScreenBloc categoryScreenBloc = widget.categoryScreenBloc;
  late TaskFilter? taskFilter;

  @override
  void initState() {
    CategoryScreenState state = categoryScreenBloc.state;
    if(state is CategoryScreenLoadSuccess) taskFilter = state.activeFilter;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return BlocBuilder<CategoryScreenBloc, CategoryScreenState>(
      bloc: categoryScreenBloc,
      builder: (_, state) {

        return state is CategoryScreenLoadSuccess ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: cPadding),
              child: FormInputHeader(context.l10n.taskStatus),
            ),
            SizedBox(height: 4.0),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: cPadding),
              child: Row(
                children: List.generate(TaskFilter.values.length, (index){
                  TaskFilter filter = TaskFilter.values[index];
                  bool isSelected = filter == taskFilter;

                  return AnimatedChip(
                    text: getEnumValue(filter),
                    isLastItem: TaskFilter.values.length - 1 == index,
                    backgroundColor: isSelected ? cPrimaryColor : null,
                    onTap: () {
                      setState(() => taskFilter = filter);
                    },
                  );
                })
              )
            ),

            SizedBox(height: 32.0),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: cPadding),
              child: RoundedButton(
                width: double.infinity,
                child: Text(
                  context.l10n.done_button,
                  style: customTheme.primaryColorButtonTextStyle,
                ),
                onPressed: (){
                  if(taskFilter != null) categoryScreenBloc.add(CategoryScreenFilterUpdated(filter: taskFilter!));
                  Navigator.pop(context);
                }
              ),
            )
          ],
        ) : Container();
      }
    );
  }
}