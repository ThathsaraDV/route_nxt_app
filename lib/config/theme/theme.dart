import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006e24),
      surfaceTint: Color(0xff006e24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff28d654),
      onPrimaryContainer: Color(0xff00360d),
      secondary: Color(0xff3f5357),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff63787c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4e616c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffadc1cd),
      onTertiaryContainer: Color(0xff20333c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff0f4ff),
      onSurface: Color(0xff1c1b1c),
      onSurfaceVariant: Color(0xff444749),
      outline: Color(0xff747779),
      outlineVariant: Color(0xffc4c7c8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313031),
      inversePrimary: Color(0xff3de35f),
      primaryFixed: Color(0xff6dff7f),
      onPrimaryFixed: Color(0xff002106),
      primaryFixedDim: Color(0xff3de35f),
      onPrimaryFixedVariant: Color(0xff005319),
      secondaryFixed: Color(0xffd0e6eb),
      onSecondaryFixed: Color(0xff091e22),
      secondaryFixedDim: Color(0xffb4cacf),
      onSecondaryFixedVariant: Color(0xff364a4e),
      tertiaryFixed: Color(0xffd1e6f2),
      onTertiaryFixed: Color(0xff0a1e27),
      tertiaryFixedDim: Color(0xffb5c9d6),
      onTertiaryFixedVariant: Color(0xff374953),
      surfaceDim: Color(0xffdcd9da),
      surfaceBright: Color(0xfffcf8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f3),
      surfaceContainer: Color(0xfff0eded),
      surfaceContainerHigh: Color(0xffebe7e8),
      surfaceContainerHighest: Color(0xffe5e2e2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004e17),
      surfaceTint: Color(0xff006e24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00872e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff32464a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff63787c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff33454f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff647782),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f9),
      onSurface: Color(0xff1c1b1c),
      onSurfaceVariant: Color(0xff404345),
      outline: Color(0xff5c5f61),
      outlineVariant: Color(0xff787b7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313031),
      inversePrimary: Color(0xff3de35f),
      primaryFixed: Color(0xff00872e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006b22),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff63787c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4b5f63),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff647782),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4c5f69),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdcd9da),
      surfaceBright: Color(0xfffcf8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f3),
      surfaceContainer: Color(0xfff0eded),
      surfaceContainerHigh: Color(0xffebe7e8),
      surfaceContainerHighest: Color(0xffe5e2e2),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002908),
      surfaceTint: Color(0xff006e24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004e17),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff112529),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff32464a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff11252e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff33454f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff212426),
      outline: Color(0xff404345),
      outlineVariant: Color(0xff404345),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313031),
      inversePrimary: Color(0xffb0ffaf),
      primaryFixed: Color(0xff004e17),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00350d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff32464a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1c3033),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff33454f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1c2f39),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdcd9da),
      surfaceBright: Color(0xfffcf8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f3),
      surfaceContainer: Color(0xfff0eded),
      surfaceContainerHigh: Color(0xffebe7e8),
      surfaceContainerHighest: Color(0xffe5e2e2),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff49ed68),
      surfaceTint: Color(0xff3de35f),
      onPrimary: Color(0xff00390e),
      primaryContainer: Color(0xff00c145),
      onPrimaryContainer: Color(0xff002206),
      secondary: Color(0xffb4cacf),
      onSecondary: Color(0xff1f3437),
      secondaryContainer: Color(0xff63787c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffc7dbe7),
      onTertiary: Color(0xff20333c),
      tertiaryContainer: Color(0xff9eb1bd),
      onTertiaryContainer: Color(0xff13262f),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131314),
      onSurface: Color(0xffe5e2e2),
      onSurfaceVariant: Color(0xffc4c7c8),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444749),
      shadow: Color(0xffffffff),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e2),
      inversePrimary: Color(0xff006e24),
      primaryFixed: Color(0xff6dff7f),
      onPrimaryFixed: Color(0xff002106),
      primaryFixedDim: Color(0xff3de35f),
      onPrimaryFixedVariant: Color(0xff005319),
      secondaryFixed: Color(0xffd0e6eb),
      onSecondaryFixed: Color(0xff091e22),
      secondaryFixedDim: Color(0xffb4cacf),
      onSecondaryFixedVariant: Color(0xff364a4e),
      tertiaryFixed: Color(0xffd1e6f2),
      onTertiaryFixed: Color(0xff0a1e27),
      tertiaryFixedDim: Color(0xffb5c9d6),
      onTertiaryFixedVariant: Color(0xff374953),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff39393a),
      surfaceContainerLowest: Color(0xff0e0e0f),
      surfaceContainerLow: Color(0xff1c1b1c),
      surfaceContainer: Color(0xff201f20),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353435),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff49ed68),
      surfaceTint: Color(0xff3de35f),
      onPrimary: Color(0xff002106),
      primaryContainer: Color(0xff00c145),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb9cfd3),
      onSecondary: Color(0xff04191c),
      secondaryContainer: Color(0xff7f9499),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc7dbe7),
      onTertiary: Color(0xff11252e),
      tertiaryContainer: Color(0xff9eb1bd),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131314),
      onSurface: Color(0xfffdfafa),
      onSurfaceVariant: Color(0xffc9cbcc),
      outline: Color(0xffa0a3a5),
      outlineVariant: Color(0xff818385),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e2),
      inversePrimary: Color(0xff005419),
      primaryFixed: Color(0xff6dff7f),
      onPrimaryFixed: Color(0xff001603),
      primaryFixedDim: Color(0xff3de35f),
      onPrimaryFixedVariant: Color(0xff004011),
      secondaryFixed: Color(0xffd0e6eb),
      onSecondaryFixed: Color(0xff011417),
      secondaryFixedDim: Color(0xffb4cacf),
      onSecondaryFixedVariant: Color(0xff25393d),
      tertiaryFixed: Color(0xffd1e6f2),
      onTertiaryFixed: Color(0xff01131c),
      tertiaryFixedDim: Color(0xffb5c9d6),
      onTertiaryFixedVariant: Color(0xff263942),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff39393a),
      surfaceContainerLowest: Color(0xff0e0e0f),
      surfaceContainerLow: Color(0xff1c1b1c),
      surfaceContainer: Color(0xff201f20),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353435),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0ffeb),
      surfaceTint: Color(0xff3de35f),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff42e763),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff2fdff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb9cfd3),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff7fbff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb9ceda),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131314),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff9fbfc),
      outline: Color(0xffc9cbcc),
      outlineVariant: Color(0xffc9cbcc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e2),
      inversePrimary: Color(0xff00320c),
      primaryFixed: Color(0xff90ff96),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff42e763),
      onPrimaryFixedVariant: Color(0xff001b04),
      secondaryFixed: Color(0xffd5ebef),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb9cfd3),
      onSecondaryFixedVariant: Color(0xff04191c),
      tertiaryFixed: Color(0xffd5eaf6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb9ceda),
      onTertiaryFixedVariant: Color(0xff041821),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff39393a),
      surfaceContainerLowest: Color(0xff0e0e0f),
      surfaceContainerLow: Color(0xff1c1b1c),
      surfaceContainer: Color(0xff201f20),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353435),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32))),
          elevation: 20,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.onTertiary,
          foregroundColor: colorScheme.onTertiary,
          elevation: 30,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          shadowColor: colorScheme.primaryContainer.withOpacity(0.12),
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
