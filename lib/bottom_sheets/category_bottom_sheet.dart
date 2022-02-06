import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/theme/theme.dart';
import 'package:uuid/uuid.dart';

List<Color> colors = [
  Color(0xFF0063AE),
  Color(0xFF008FFD),
  Color(0xFF00C0FD),
  Color(0xFF07B9AE),
  Color(0xFF00B96D),
  Color(0xFFFF6B55),
  Color(0xFFEC0039),
  Color(0xFFBE118E),
  Color(0xFFFA6EE3),
  Color(0xFF7F43FF),
  Color(0xFF4743FF),
  Color(0xFF9295A2)
];

class CategoryBottomSheet extends StatefulWidget{
  
  final Category? editCategory;
  CategoryBottomSheet({this.editCategory});

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet>{

  late Category? editCategory = widget.editCategory;

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
            padding: EdgeInsets.symmetric(horizontal: cPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                FormInputHeader("Name"),
                RoundedTextFormField(
                  hintText: "Category name",
                  initialValue: categoryName,
                  onChanged: (value) => categoryName = value,
                  validator: (value){
                    value = value ?? "";
                    if(value.isEmpty) return "Please enter a name";
                    if(value.length > 20) return "Maximum 20 characters";
                    return null;
                  },
                ),

                FormInputHeader("Select a color"),
                SizedBox(height: 4.0),

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
                                borderRadius: BorderRadius.all(Radius.circular(12.0))
                              ),
                              child: Container(
                                height: 16.0,
                                width: 16.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.all(Radius.circular(6.0))
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

          SizedBox(height: 32.0),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: cPadding),
            child: RoundedButton(
              width: double.infinity,
              child: Text(
                "Done",
                style: customTheme.primaryColorButtonTextStyle,
              ),
              onPressed: (){
                setState(() => formValidated = true);
                if (formKey.currentState!.validate()){
                  formKey.currentState!.save();

                  if(editCategory != null) BlocProvider.of<CategoryBloc>(context).add(CategoryUpdated(editCategory!.copyWith(
                    name: categoryName,
                    color: categoryColor
                  )));

                  else BlocProvider.of<CategoryBloc>(context).add(CategoryAdded(Category.create(
                    name: categoryName,
                    color: categoryColor
                  )));

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