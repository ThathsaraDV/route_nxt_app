part of 'theme_bloc.dart';

@freezed
class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.getThemeMode() = _GetThemeMode;

  const factory ThemeEvent.themeChanged(bool isDark) = _ThemeChanged;
}
