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
Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
