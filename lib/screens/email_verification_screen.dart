import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/forms/resend_code_timer.dart';
import 'package:task_manager/components/forms/verification_code.dart';
import 'package:task_manager/cubits/email_verification_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/components/forms/small_form_svg.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailVerificationCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>()
      ),
      child: _EmailVerificationScreen(),
    );
  }
}

class _EmailVerificationScreen extends StatelessWidget{

  final codeController = TextEditingController();
  final customTimerController = CustomTimerController(
    initialState: CustomTimerState.counting
  );

  @override
  Widget build(BuildContext context){
    
    return BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
      builder: (_, formState) {

        return SmallFormSvg(
          svgImage: "assets/svg/newsletter.svg",
          header: context.l10n.emptySpace_verifyYourEmail,
          description: context.l10n.emptySpace_verifyYourEmail_description,
          formChildren: [

            const SizedBox(height: 8.0),
            VerificationCode(
              controller: codeController,
              textInputType: TextInputType.text,
              length: 4,
              errorText: formState.codeError,
            )
          ],
          isLoading: formState.isLoading,
          buttonText: context.l10n.confirm,
          onButtonPressed: () async {
            try{
              context.read<EmailVerificationCubit>().submitted(
                context: context,
                code: codeController.text
              );
            }
            catch(_){}
          },
          bottomWidget: ResendCodeTimer(
            controller: customTimerController,
            onResend: () {
              customTimerController.reset();
              customTimerController.start();
              context.read<EmailVerificationCubit>().sendAccountVerificationCode();
            }
          ),
        );
      }
    );
  }
}