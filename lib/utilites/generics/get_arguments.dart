import 'package:flutter/material.dart' show BuildContext, ModalRoute;

/// Extension method/function of Type<T> to return T?(any type or null).
///
/// Return the retreived argument from the passing widget or return null if empty.
extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
