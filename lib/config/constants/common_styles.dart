import 'package:flutter/material.dart';
import 'package:route_nxt/config/global/app_settings.dart';

class CommonStyles {

  static const Color successMsgBgColor = Color(0xFF14A44D);
  static const Color successDarkColor = Color(0xFF2e7d32);
  static const Color warningMsgBgColor = Color(0xFFFFB300);
  static const Color warningDarkColor = Color(0xFFFB8C00);
  static const Color infoMsgBgColor = Color(0xff2196F3);
  static const Color infoDarkColor = Color(0xFF1976D2);
  static const Color errorMsgBgColor = Color(0xFFDC4C64);
  static const Color errorDarkColor = Color(0xffc72c41);

  static ButtonStyle mainButtonStyles(
      {Color? backgroundColor, double? minimumSizeHeight}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ??
          Theme.of(AppSettings.rootNavigatorKey.currentContext!)
              .colorScheme
              .primary,
      minimumSize: Size.fromHeight(minimumSizeHeight ?? 50),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(28.0), // Adjust the radius as needed
      ),
      // fixedSize: fixedSize ?? const Size(280, 56),
    );
  }

  static TextStyle mainButtonTextStyle({Color? color}) {
    return TextStyle(
        fontSize: 15,
        letterSpacing: 1,
        color: color ??
            Theme.of(AppSettings.rootNavigatorKey.currentContext!)
                .colorScheme
                .onPrimary,
        fontWeight: FontWeight.bold);
  }

  static Gradient lightCardGradient2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Theme.of(AppSettings.rootNavigatorKey.currentContext!)
          .colorScheme
          .primaryFixed,
      Theme.of(AppSettings.rootNavigatorKey.currentContext!)
          .colorScheme
          .surface,
    ],
  );

}
