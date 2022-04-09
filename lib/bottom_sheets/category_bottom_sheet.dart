import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/theme/theme.dart';

List<Color> colors = [
  const Color(0xFF0063AE),
  const Color(0xFF008FFD),
  const Color(0xFF00C0FD),
  const Color(0xFF07B9AE),
  const Color(0xFF00B96D),
  const Color(0xFFFF6B55),
  const Color(0xFFEC0039),
  const Color(0xFFBE118E),
  const Color(0xFFFA6EE3),
  const Color(0xFF7F43FF),
  const Color(0xFF4743FF),
  const Color(0xFF9295A2)
];

class CategoryBottomSheet{

  final BuildContext context;
  final Category? editCategory;

  CategoryBottomSheet(
    this.context,
    {this.editCategory}
  );

  void show(){
    ModalBottomSheet(
      title: editCategory != null
        ? context.l10n.bottomSheet_editCategory
        : context.l10n.bottomSheet_createCategory,
      context: context,
      content: _CategoryBottomSheet(this)
    ).show();
  }
}

class _CategoryBottomSheet extends StatefulWidget{
  
  final CategoryBottomSheet data;
  const _CategoryBottomSheet(this.data);

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<_CategoryBottomSheet>{

  late Category? editCategory = widget.data.editCategory;

  late String categoryName = editCategory != null ? editCategory!.name : "";
  late Color categoryColor = editCategory != null ? editCategory!.color : colors.first;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool formValidated = false;

  double? colorWidth;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: cPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                FormInputHeader(context.l10n.textField_name),
                RoundedTextFormField(
                  hintText: context.l10n.category,
                  initialValue: categoryName,
                  onChanged: (value) => categoryName = value,
                  validator: (value){
                    value = value ?? "";
                    if(value.isEmpty) return context.l10n.error_enterName;
                    if(value.length > 20) return context.l10n.error_maxLength(20);
                    return null;
                  },
                ),

                FormInputHeader(context.l10n.selectColor),
                const SizedBox(height: 4.0),

                LayoutBuilder(
                  builder: (_, constraints){                    
                    int colorsPerRow = colorWidth != null ? ((constraints.maxWidth / colorWidth!).floor()).clamp(0, colors.length) : 0;
                    
                    return Wrap(
                      spacing: colorWidth == null ? 2.0 : (constraints.maxWidth - colorsPerRow * colorWidth!) / colorsPerRow,
                      runSpacing: 2.0,
                      children: List.generate(colors.length, (index){
                        final color = colors[index];
                        final isSelected = categoryColor == color;

                        return GestureDetector(
                          child: WidgetSize(
                            onChange: (Size size) => setState(() => colorWidth = size.width),
                            child: AnimatedContainer(
                              duration: cFastAnimationDuration,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? customTheme.lightColor : Colors.transparent,
                                  width: 1.5
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(12.0))
                              ),
                              child: Container(
                                height: 16.0,
                                width: 16.0,
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: const BorderRadius.all(Radius.circular(6.0))
                                ),
                              ),
                            ),
                          ),
                          onTap: () => setState(() => categoryColor = color)
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: cPadding),
            child: RoundedTextButton(
              text: context.l10n.done_button,
              onPressed: (){
                setState(() => formValidated = true);
                if (formKey.currentState!.validate()){
                  formKey.currentState!.save();

                  if(editCategory != null) {
                    context.read<CategoryBloc>().add(CategoryUpdated(editCategory!.copyWith(
                      name: categoryName,
                      color: categoryColor
                    )));
                  } else {
                    context.read<CategoryBloc>().add(CategoryAdded(Category.create(
                      name: categoryName,
                      color: categoryColor
                    )));
                  }

                  Navigator.pop(context);
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}