import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/config/global/app_settings.dart';

class CustomSnackBar {
  static void showSnackBar(String? title, String message, String type, {BuildContext? context}) {
    ScaffoldMessenger.of(context ?? AppSettings.rootNavigatorKey.currentState!.context)
        .showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.only(top: 20),
        content: Container(
          padding: const EdgeInsets.all(0),
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: type == 'success'
                      ? CommonStyles.successMsgBgColor
                      : type == 'error'
                          ? CommonStyles.errorMsgBgColor
                          : type == 'warning'
                              ? CommonStyles.warningMsgBgColor
                              : CommonStyles.infoMsgBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 48,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (null != title)
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 0.65),
                          ),
                        Text(message,
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.white))
                      ],
                    )),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        iconSize: 14,
                        onPressed: () {
                          ScaffoldMessenger.of(context ?? AppSettings
                                  .rootNavigatorKey.currentState!.context)
                              .hideCurrentSnackBar();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),

              /// Splash SVG asset
              Positioned(
                bottom: 0,
                left: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'asset/svg/snackBar/bubbles.svg',
                        width: 40,
                        height: 40,
                        color: type == 'success'
                            ? CommonStyles.successDarkColor.withOpacity(0.5)
                            : type == 'error'
                                ? CommonStyles.errorDarkColor.withOpacity(0.65)
                                : type == 'warning'
                                    ? CommonStyles.warningDarkColor
                                        .withOpacity(0.65)
                                    : CommonStyles.infoDarkColor.withOpacity(0.65),
                      )
                    ],
                  ),
                ),
              ),

              // Bubble Icon
              Positioned(
                top: -15,
                left: 8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'asset/svg/snackBar/back.svg',
                      // width: 40,
                      height: 36,
                      color: type == 'success'
                          ? CommonStyles.successDarkColor
                          : type == 'error'
                              ? CommonStyles.errorDarkColor
                              : type == 'warning'
                                  ? CommonStyles.warningDarkColor
                                  : CommonStyles.infoDarkColor,
                    ),
                    Positioned(
                      top: 8,
                      child: SvgPicture.asset(
                        type == 'success'
                            ? 'asset/svg/snackBar/success.svg'
                            : type == 'error'
                                ? 'asset/svg/snackBar/failure.svg'
                                : type == 'warning'
                                    ? 'asset/svg/snackBar/warning.svg'
                                    : 'asset/svg/snackBar/info.svg',
                        // width: 10,
                        height: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
