import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilites/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: "We've sent you a password reset link. Please check your email.",
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
