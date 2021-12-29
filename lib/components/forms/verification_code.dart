import 'package:boxy/flex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/components/forms/form_validator.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';

class VerificationCode extends StatefulWidget{

  final int length;
  final TextInputType textInputType;
  final bool closeKeyboardOnFinish;
  final String? Function(String?)? validator;

  VerificationCode({
    required this.length,
    this.textInputType = TextInputType.number,
    this.closeKeyboardOnFinish = true,
    this.validator
  });

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode>{

  late int length = widget.length;
  late List<FocusNode> focusNodes;
  late List<FocusNode> focusNodeKeyboardListeners;
  late List<TextEditingController> textEditingControllers;

  @override
  void initState() {
    focusNodes = List.generate(length, (index) => FocusNode());
    focusNodeKeyboardListeners = List.generate(length, (index) => FocusNode());
    textEditingControllers = List.generate(length, (index) => TextEditingController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormValidator(
      errorTextPadding: EdgeInsets.symmetric(vertical: 16.0),
      widget: (state) => Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: BoxyRow(
            children: [
              Dominant(
                child: Opacity(
                  opacity: 0,
                  child: Container(
                    width: double.minPositive,
                    child: RoundedTextFormField()
                  ),
                )
              ),

              Row(
                children: List.generate(length, (index){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: RawKeyboardListener(
                        focusNode: focusNodeKeyboardListeners.elementAt(index),
                        onKey: (event){

                          if((event.runtimeType == RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.backspace)
                            || event.physicalKey == PhysicalKeyboardKey.backspace){

                            if(index > 0){
                              textEditingControllers.elementAt(index - 1).clear();
                              focusNodes.elementAt(index - 1).requestFocus();
                            }
                          }
                        },
                        child: RoundedTextFormField(
                          controller: textEditingControllers.elementAt(index),
                          focusNode: focusNodes.elementAt(index),
                          textAlign: TextAlign.center,
                          textInputType: widget.textInputType,
                          maxLength: 1,
                          counterText: "",
                          errorText: state.errorText,
                          errorStyle: TextStyle(height: 0.0),
                          onChanged: (String value){

                            if(value.isNotEmpty){
                              if(index < length - 1){
                                textEditingControllers.elementAt(index + 1).clear();
                                focusNodes.elementAt(index + 1).requestFocus();
                              }
                              else if(widget.closeKeyboardOnFinish){
                                FocusScope.of(context).unfocus();
                              }
                            }
                          },
                        ),
                      )
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
      validator: (value){
        String code = "";
        textEditingControllers.forEach((t) => code += t.text);

        if(widget.validator != null) return widget.validator!(code);
        else return null;
      }
    );
  }
}