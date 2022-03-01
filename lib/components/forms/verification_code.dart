import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/components/forms/form_validator.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';

class VerificationCode extends StatefulWidget{

  final TextEditingController? controller;
  final int length;
  final TextInputType textInputType;
  final bool closeKeyboardOnFinish;
  final String? Function(String?)? validator;
  final String? errorText;

  const VerificationCode({
    Key? key, 
    this.controller,
    required this.length,
    this.textInputType = TextInputType.number,
    this.closeKeyboardOnFinish = true,
    this.validator,
    this.errorText
  }) : super(key: key);

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

  void previous(int index){
    if(index > 0){
      textEditingControllers.elementAt(index - 1).clear();
      focusNodes.elementAt(index - 1).requestFocus();
    }
  }

  void next(int index){
    if(index < length - 1){
      textEditingControllers.elementAt(index + 1).clear();
      focusNodes.elementAt(index + 1).requestFocus();
    }
    else if(widget.closeKeyboardOnFinish){
      FocusScope.of(context).unfocus();
    }
  }

  String getCode(){
    String code = "";
    for (TextEditingController t in textEditingControllers) {
      code += t.text;
    }
    if(widget.controller != null) widget.controller?.text = code;
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return FormValidator(
      errorTextPadding: const EdgeInsets.symmetric(vertical: 16.0),
      widget: (state) => Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: IntrinsicHeight(
            child: Row(
              children: [
                const Opacity(
                  opacity: 0,
                  child: SizedBox(
                    width: double.minPositive,
                    child: RoundedTextFormField()
                  ),
                ),

                Row(
                  children: List.generate(length, (index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: RawKeyboardListener(
                          focusNode: focusNodeKeyboardListeners.elementAt(index),
                          onKey: (event){

                            if((event.runtimeType == RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.backspace)
                              || event.physicalKey == PhysicalKeyboardKey.backspace){

                              previous(index);
                            }
                          },
                          child: RoundedTextFormField(
                            controller: textEditingControllers.elementAt(index),
                            focusNode: focusNodes.elementAt(index),
                            textAlign: TextAlign.center,
                            textInputType: widget.textInputType,
                            textInputAction: index == length - 1 ? TextInputAction.done : TextInputAction.next,
                            maxLength: 1,
                            counterText: "",
                            errorText: widget.errorText ?? state.errorText,
                            errorStyle: const TextStyle(height: 0.0),
                            onChanged: (String value){
                              if(value.isNotEmpty) next(index);

                              getCode();
                            },
                            onFieldSubmitted: (_) => next(index)
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
      ),
      errorText: widget.errorText,
      validator: (value){
        if(widget.validator != null) return widget.validator!(getCode());
        return null;
      }
    );
  }
}