import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/forms/form_input_header.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/main/center_app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/profile_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';
import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        authBloc: context.read<AuthBloc>()
      ),
      child: _ProfileScreen(),
    );
  }
}
class _ProfileScreen extends StatefulWidget{

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen>{

  double appBarHeight = 500.0;

  late AuthBloc authBloc = context.read<AuthBloc>();
  late StreamSubscription authSuscription;
  
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    nameController = TextEditingController(text: authBloc.state.user?.name);
    emailController = TextEditingController(text: authBloc.state.user?.email);

    authSuscription = authBloc.stream.listen((authState) {
      final name = authState.user?.name;
      if(name != null) nameController.text = name;

      final email = authState.user?.email;
      if(email != null) emailController.text = email;
    });

    super.initState();
  }

  @override
  void dispose() {
    authSuscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: appBarHeight,
                  collapsedHeight: appBarHeight,
                  
                  flexibleSpace: WidgetSize(
                    onChange: (Size size) => setState(() => appBarHeight = size.height),
                    child: CenterAppBar(
                      center: Text(
                        context.l10n.profile,
                        style: customTheme.subtitleTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: cPadding),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (_, authState) {
                            final user = authState.user;

                            return Column(
                              children: [

                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2.5,
                                      color: cPrimaryColor
                                    )
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    height: 96.0,
                                    decoration: BoxDecoration(
                                      color: customTheme.contentBackgroundColor,
                                      shape: BoxShape.circle
                                    ),
                                  ),
                                ),

                               const SizedBox(height: 32.0),

                                BlocBuilder<TaskBloc, TaskState>(
                                  builder: (_, taskState) {
                                    int? tasksCount, completedCount, remainingCount;
                                    
                                    tasksCount = taskState.tasks.length;
                                    completedCount = taskState.tasks.where((t) => t.isCompleted).length;
                                    remainingCount = tasksCount - completedCount;

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ProfileItem(
                                          count: tasksCount,
                                          name: context.l10n.tasks,
                                        ),

                                        ProfileItem(
                                          count: completedCount,
                                          name: context.l10n.enum_taskFilter_completed,
                                        ),

                                        ProfileItem(
                                          count: remainingCount,
                                          name: context.l10n.enum_taskFilter_remaining,
                                        )
                                      ],
                                    );
                                  }
                                ),

                                const SizedBox(height: 32.0),

                                if(user != null) BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (_, profileState) {

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        const FormInputHeader("Display name"),
                                        ProfileField(
                                          controller: nameController,
                                          enabled: profileState.nameStatus == FieldStatus.saveable,
                                          text: user.name,
                                          errorText: profileState.nameError,
                                          suffixKey: Key("DisplayName: ${profileState.nameStatus.name}"),
                                          suffixText: profileState.nameStatus == FieldStatus.editable ? "Edit"
                                            : profileState.nameStatus == FieldStatus.saveable ? "Save" : "Saving...",

                                          suffixPadding: 8.0,

                                          suffixWidget: profileState.nameStatus == FieldStatus.editable ? Icon(
                                            Icons.edit_rounded,
                                            size: 20.0,
                                            color: customTheme.lightColor,
                                          ) : profileState.nameStatus == FieldStatus.saveable ? Icon(
                                            Icons.done_rounded,
                                            color: customTheme.lightColor,
                                          ) : const SizedBox(
                                            height: 20.0,
                                            width: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                            ),
                                          ),

                                          onTap: () => context.read<ProfileCubit>().namePressed(
                                            context: context,
                                            name: nameController.text.trim()
                                          ),
                                        ),

                                        const FormInputHeader("Email"),
                                        ProfileField(
                                          controller: emailController,
                                          text: user.email,
                                          suffixText: "Change",
                                          suffixWidget: Icon(
                                            Icons.chevron_right_rounded,
                                            color: customTheme.lightColor,
                                          ),
                                          onTap: () {},
                                        ),

                                        const FormInputHeader("Password"),
                                        ProfileField(
                                          text: "••••••••••••",
                                          suffixText: "Change",
                                          suffixWidget: Icon(
                                            Icons.chevron_right_rounded,
                                            color: customTheme.lightColor,
                                          ),
                                          onTap: () {},
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              ],
                            );
                          }
                        ),
                      ),

                      /*const SizedBox(height: 16.0),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 16.0
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius)),
                          elevation: customTheme.elevation,
                          shadowColor: customTheme.shadowColor,
                          child: Container(
                            decoration: BoxDecoration(
                              color: customTheme.contentBackgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius))
                            ),
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(cPadding),
                                  child: Row(
                                    children: [

                                      // TODO: Add plans
                                      CircularPercentIndicator(
                                        radius: 32.0,
                                        lineWidth: cLineSize,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        animationDuration: cAnimationDuration.inMilliseconds,
                                        percent: 0.57,
                                        center: Text(
                                          "57%",
                                          style: customTheme.textStyle,
                                        ),
                                        circularStrokeCap: CircularStrokeCap.round,
                                        backgroundColor: cGoldenColor.withOpacity(customTheme.isDark ? 0.15 : 0.4),
                                        progressColor: cGoldenColor,
                                      ),

                                      const SizedBox(width: 16.0),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context.l10n.upgradeToPro_title,
                                              style: customTheme.boldTextStyle,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8.0),

                                            Text(
                                              context.l10n.upgradeToPro_description,
                                              style: customTheme.lightTextStyle,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(cPadding),
                                  decoration: BoxDecoration(
                                    color: cPrimaryColor.withOpacity(customTheme.isDark ? 0.85 : 1.0),
                                    borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius))
                                  ),
                                  child: Row(
                                    children: [

                                      Expanded(
                                        child: Text(
                                          context.l10n.plansAndBenefits_button,
                                          style: customTheme.textStyle.copyWith(color: CustomThemeData.dark.textColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      const SizedBox(width: 12.0),

                                      RoundedButton(
                                        autoWidth: true,
                                        color: cGoldenColor,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            context.l10n.upgradeToPro_button,
                                            style: customTheme.boldTextStyle.copyWith(color: CustomThemeData.light.textColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onPressed: () {}
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      )*/
                    ],
                  ),
                )
              ],
            );
          }
        ),
      )
    );
  }
}

class ProfileItem extends StatelessWidget{

  final int? count;
  final String name;

  const ProfileItem({
    Key? key, 
    required this.count,
    required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Text(
              count != null ? count.toString() : "-",
              style: customTheme.subtitleTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              name,
              style: customTheme.lightTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {

  final TextEditingController? controller;
  final bool enabled;
  final String text;
  final String? errorText;
  final Key? suffixKey;
  final Widget suffixWidget;
  final double suffixPadding;
  final String suffixText;
  final Function()? onTap;

  const ProfileField({
    Key? key,
    this.controller,
    this.enabled = false,
    required this.text,
    this.errorText,
    this.suffixKey,
    required this.suffixWidget,
    this.suffixPadding = 0.0,
    required this.suffixText,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    final suffix = AlignedAnimatedSwitcher(
      duration: cFastAnimationDuration,
      alignment: Alignment.centerRight,
      child: Row(
        key: suffixKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            suffixText,
            style: customTheme.lightTextStyle,
          ),
          SizedBox(width: suffixPadding),
          suffixWidget
        ],
      ),
    );

    return Stack(
      alignment: Alignment.topRight,
      children: [
        RoundedTextFormField(
          controller: controller,
          initialValue: controller == null ? text : null,
          enabled: enabled,
          errorText: errorText,
          suffixIcon: Opacity(
            opacity: 0,
            child: suffix,
          ),
          textInputAction: TextInputAction.done,
        ),
        
        GestureDetector(
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avoid center alignment change when
                // there is an error in the text field.
                const SizedBox(
                  width: double.minPositive,
                  child: Opacity(
                    opacity: 0,
                    child: RoundedTextFormField()
                  )
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 18.0),
                  child: suffix,
                )
              ],
            ),
          ),
          onTap: onTap
        ),
      ],
    );
  }
}