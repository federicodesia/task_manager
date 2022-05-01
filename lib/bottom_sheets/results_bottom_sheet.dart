import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/animated_chip.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/task_filter.dart';

class ResultsBottomSheet{

  final BuildContext context;
  final CategoryScreenBloc categoryScreenBloc;

  ResultsBottomSheet(
    this.context,
    {required this.categoryScreenBloc}
  );

  void show(){
    ModalBottomSheet(
      title: context.l10n.results, 
      context: context, 
      content: _ResultsBottomSheet(this)
    ).show();
  }
}

class _ResultsBottomSheet extends StatefulWidget{

  final ResultsBottomSheet data;
  const _ResultsBottomSheet(this.data);

  @override
  _ResultsBottomSheetState createState() => _ResultsBottomSheetState();
}

class _ResultsBottomSheetState extends State<_ResultsBottomSheet>{

  late CategoryScreenBloc categoryScreenBloc = widget.data.categoryScreenBloc;
  late TaskFilter taskFilter = categoryScreenBloc.state.activeFilter;

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<CategoryScreenBloc, CategoryScreenState>(
      bloc: categoryScreenBloc,
      builder: (_, state) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: cPadding),
              child: FormInputHeader(context.l10n.taskStatus),
            ),
            const SizedBox(height: 4.0),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: cPadding),
              child: Row(
                children: List.generate(TaskFilter.values.length, (index){
                  TaskFilter filter = TaskFilter.values[index];
                  bool isSelected = filter == taskFilter;

                  return AnimatedChip(
                    text: filter.nameLocalization(context),
                    textColor: isSelected ? Colors.white : null,
                    isLastItem: TaskFilter.values.length - 1 == index,
                    backgroundColor: isSelected ? cPrimaryColor : null,
                    onTap: () {
                      setState(() => taskFilter = filter);
                    },
                  );
                })
              )
            ),

            const SizedBox(height: 32.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: cPadding),
              child: RoundedTextButton(
                text: context.l10n.done_button,
                onPressed: (){
                  categoryScreenBloc.add(FilterUpdated(taskFilter));
                  Navigator.pop(context);
                }
              ),
            )
          ],
        );
      }
    );
  }
}