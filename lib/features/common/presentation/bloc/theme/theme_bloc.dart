import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/core/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_bloc.freezed.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  final SharedPreferences _sharedPreferences;

  ThemeBloc(this._sharedPreferences) : super(ThemeMode.light) {
    on<ThemeEvent>((event, emit) async {
      await event.when(
          getThemeMode: () async {
            bool? isDark = _sharedPreferences.getBool(AppConstant.themeKey);
            if (null == isDark) {
              await _sharedPreferences.setBool(AppConstant.themeKey, false);
              isDark = false;
            }
            emit(isDark ? ThemeMode.dark : ThemeMode.light);
          },
        themeChanged: (bool isDark) async {
          await _sharedPreferences.setBool(AppConstant.themeKey, isDark);
          emit(isDark ? ThemeMode.dark : ThemeMode.light);
        }
      );
    });
  }

  bool getStoredDarkMode() {
    return _sharedPreferences.getBool(AppConstant.themeKey) ?? false;
  }

  bool getIsDarkMode() {
    return state == ThemeMode.dark;
  }

}
