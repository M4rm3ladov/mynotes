import 'package:flutter/material.dart';
import 'package:mynotes/utilites/dialogs/generic_dialog.dart';

/// ***Named Arguments:***
/// - Widget [BuildContext]
/// - Title of the dialog
/// - Text Content
/// - Map<String, <T>> of button options
///
/// ***Optionally returns***
/// - Callback function boolean if no value is returned(e.g. when user taps outside of dialog)
Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to logout?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
