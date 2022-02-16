import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/settings_bloc/settings_bloc.dart';
import 'package:task_manager/components/lists/rounded_list_tile.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/locale_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

class LanguageBottomSheet extends StatefulWidget{

  @override
  _LanguageBottomSheetState createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet>{
  late Locale selectedLocale = Localizations.localeOf(context);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    final supportedLocales = context.findAncestorWidgetOfExactType<MaterialApp>()?.supportedLocales.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        SizedBox(height: cPadding),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: cPadding),
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
              context.read<SettingsBloc>().add(LocaleChangeRequested(selectedLocale));
              Navigator.pop(context);
            }
          ),
        )
      ],
    );
  }
}