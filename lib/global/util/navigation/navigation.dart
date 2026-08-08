import 'package:flutter/material.dart';

/// A utility function to navigate to a screen using a [MaterialPageRoute].
Future<T?> push<T>(BuildContext context, Widget screen,
    {Route<T>? customRoute,
    bool replace = false,
    bool removeUntil = false,
    bool Function(Route<dynamic> route)? predicate}) {
  final navigator = Navigator.of(context);
  final route = customRoute ?? MaterialPageRoute(builder: (context) => screen);

  if (removeUntil) {
    return navigator.pushAndRemoveUntil(route, predicate ?? (route) => false);
  } else if (replace) {
    return navigator.pushReplacement(route);
  } else {
    return navigator.push(route);
  }
}

Future<T?> pushNamed<T>(BuildContext context, String routeName,
    {bool replace = false,
    bool removeUntil = false,
    bool Function(Route<dynamic> route)? predicate}) {
  final navigator = Navigator.of(context);

  if (removeUntil) {
    return navigator.pushNamedAndRemoveUntil(
        routeName, predicate ?? (route) => false);
  } else if (replace) {
    return navigator.pushReplacementNamed(routeName);
  } else {
    return navigator.pushNamed(routeName);
  }
}

/// A utility function to pop the current screen from the navigation stack.
void pop<T extends Object?>(BuildContext context, {T? result}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop(result);
  }
}

/// A utility function to pop the current screen from the navigation stack.
void popUntil(BuildContext context,
    {bool Function(Route<dynamic> route)? predicate}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).popUntil(predicate ?? (route) => false);
  }
}

///////////* <------ Custom Page Route Builder ------> *///////////

/// A utility function to create an opaque page route that allows the previous screen to be visible in the background.
/// This is useful for scenarios where you want to display a page with a non-blocking background, such as a dialog or bottom sheet.
PageRouteBuilder opaquePage(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) => page,
  );
}

/// A custom transition for bottom sheet navigation with slide-in effect.
PageRouteBuilder<T> bottomSheetRoute<T>(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, animation, __, child) {
      final tween =
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero);
      final offsetAnimation =
          animation.drive(tween.chain(CurveTween(curve: Curves.easeInOut)));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
