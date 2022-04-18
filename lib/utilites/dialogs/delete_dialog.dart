import 'package:flutter/material.dart';
import 'package:mynotes/utilites/dialogs/generic_dialog.dart';

/// Function that returns [shoGenericDialog] of type bool.
/// ***Named Arguments:***
/// - Widget [BuildContext]
/// - Title of the dialog
/// - Text Content
/// - Map<String, <T>> of button options
///
/// ***Optionally returns***
/// - Callback function boolean if no value is returned(e.g. when user taps outside of dialog)
Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
