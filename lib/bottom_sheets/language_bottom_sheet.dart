import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/locale_helper.dart';
import 'package:task_manager/l10n/l10n.dart';

class LanguageBottomSheet{

  final BuildContext context;
  LanguageBottomSheet(this.context);

  void show(){
    ModalBottomSheet(
      title: context.l10n.settings_selectLanguage, 
      context: context,
      content: const _LanguageBottomSheet()
    ).show();
  }
}

class _LanguageBottomSheet extends StatefulWidget{
  const _LanguageBottomSheet({Key? key}) : super(key: key);

  @override
  _LanguageBottomSheetState createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<_LanguageBottomSheet>{
  late Locale selectedLocale = Localizations.localeOf(context);

  @override
  Widget build(BuildContext context) {
    final supportedLocales = context.findAncestorWidgetOfExactType<MaterialApp>()?.supportedLocales.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        const SizedBox(height: cPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: cPadding),
          child: Column(
            children: supportedLocales != null ? supportedLocales.map((locale){
              return RoundedListTile(
                title: locale.name,
                icon: selectedLocale == locale ? Icons.check_rounded : null,
                suffix: Container(),
                onTap: () => setState(() => selectedLocale = locale),
              );
            }).toList() : [],
          )
        ),
        

        const SizedBox(height: 32.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: cPadding),
          child: RoundedTextButton(
            text: context.l10n.done_button,
            onPressed: (){
              context.read<SettingsCubit>().changeLocale(selectedLocale);
              Navigator.pop(context);
            }
          ),
        )
      ],
    );
  }
}