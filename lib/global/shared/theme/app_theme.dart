import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class AppTheme {
  static DialogThemeData dialogTheme(bool isDarkMode) => DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      );

  static TabBarThemeData tabBarTheme(bool isDarkMode) => TabBarThemeData(
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(decoration: TextDecoration.none),
      );

  static CupertinoThemeData cupertinoTheme(bool isDarkMode) =>
      CupertinoThemeData(
        primaryColor: primaryColor,
        textTheme: CupertinoTextThemeData(),
      );

  static BottomAppBarTheme bottomAppBarTheme(bool isDarkMode) =>
      BottomAppBarTheme(
        color: Colors.white,
        surfaceTintColor: Colors.white,
      );


  static BottomSheetThemeData bottomSheetTheme(bool isDarkMode) =>
      BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      );

  static AppBarTheme appBarTheme(bool isDarkMode) => const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      );

  static DropdownMenuThemeData dropdownMenuTheme(bool isDarkMode) =>
      DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          surfaceTintColor: WidgetStatePropertyAll(Colors.white),
        ),
      );

  static TextSelectionThemeData textSelectionTheme(bool isDarkMode) =>
      TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionHandleColor: primaryColor,
        selectionColor: primaryColor.withValues(alpha: 0.5),
      );

  static ThemeData mainThemeData(bool isDarkMode) {
    return ThemeData(
      useMaterial3: false,
      // One font everywhere (Alexandria, as in the new design): text and
      // inputs that don't set a font no longer fall back to Roboto.
      fontFamily: AppFontsFamily.alexandria,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,

      //* Functions
      appBarTheme: appBarTheme(isDarkMode),
      dialogTheme: dialogTheme(isDarkMode),
      tabBarTheme: tabBarTheme(isDarkMode),
      bottomSheetTheme: bottomSheetTheme(isDarkMode),
     // bottomAppBarTheme: bottomAppBarTheme(isDarkMode),
      dropdownMenuTheme: dropdownMenuTheme(isDarkMode),
      cupertinoOverrideTheme: cupertinoTheme(isDarkMode),
      textSelectionTheme: textSelectionTheme(isDarkMode),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
