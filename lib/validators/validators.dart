import 'package:flutter/material.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/l10n/l10n.dart';

abstract class Validators{

  static String? validateName(BuildContext context, String value) {
    if(value.isEmpty) return context.l10n.error_enterYourName;
    if(value.length > 128) return context.l10n.error_maxLength(128);
    return null;
  }

  static String? validateEmail(BuildContext context, String value) {
    if(value.isEmpty) return context.l10n.error_enterYourEmail;

    bool isValid = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
    if(!isValid) return context.l10n.error_enterValidEmail;
    return null;
  }

  static String? validateNewEmail(BuildContext context, String newEmail, String currentEmail) {
    if(newEmail.isEmpty) return context.l10n.error_enterYourNewEmail;
    if(newEmail == currentEmail) return context.l10n.error_thisIsYourCurrentEmail;
    return validateEmail(context, newEmail);
  }

  static String? validateEqualEmails(BuildContext context, String email, String emailConfirmation){
    if(email != emailConfirmation) return context.l10n.error_emailsDontMatch;
    return null;
  }

  static String? validatePassword(BuildContext context, String value) {
    if(value.isEmpty) return context.l10n.error_enterYourPassword;
    if(value.length < 8) return context.l10n.error_minLength(8);
    if(value.length > 128) return context.l10n.error_maxLength(128);

    if(!RegExp(r'[0-9]').hasMatch(value)) return context.l10n.error_atLeastOneNumber;
    if(!RegExp(r'[a-z]').hasMatch(value)) return context.l10n.error_atLeastOneLowercaseLetter;
    if(!RegExp(r'[A-Z]').hasMatch(value)) return context.l10n.error_atLeastOneUppercaseLetter;
    return null;
  }

  static String? validateCurrentPassword(BuildContext context, String currentPassword){
    if(currentPassword.isEmpty) return context.l10n.error_enterYourCurrentPassword;
    if(validatePassword(context, currentPassword) != null)  return context.l10n.error_wrongPassword;
    return null;
  }

  static String? validateNewPassword(BuildContext context, String currentPassword, String newPassword){
    if(newPassword.isEmpty) return context.l10n.error_enterYourNewPassword;
    if(newPassword == currentPassword) return context.l10n.error_samePasswords;
    return validatePassword(context, newPassword);
  }

  static String? validateEmailVerificationCode(BuildContext context, String value) {
    if(value.isEmpty) return context.l10n.error_enterCode;
    if(value.length < 4) return context.l10n.error_enterCompleteCode;
    if(!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) return context.l10n.error_enterValidCode;
    return null;
  }

  static String? validateEmailResponse(BuildContext context, ResponseMessage responseMessage){
    if(responseMessage.contains("user not found")) return context.l10n.error_userNotFound;
    if(responseMessage.contains("email is already taken")) return context.l10n.error_emailAlreadyTaken;
    return null;
  }

  static String? validatePasswordResponse(BuildContext context, ResponseMessage responseMessage){
    if(responseMessage.contains("wrong password")) return context.l10n.error_wrongPassword;
    return null;
  }

  static String? validateEmailVerificationCodeResponse(BuildContext context, ResponseMessage responseMessage){
    if(responseMessage.contains("invalid code")) return context.l10n.error_invalidCode;
    if(responseMessage.contains("expired code")) return context.l10n.error_expiredCode;
    return null;
  }
}