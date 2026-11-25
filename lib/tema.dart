import 'package:material_ui/material_ui.dart';

const granate = Color(0xFF7A1F2B);

ThemeData temaClaro() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: granate),
    appBarTheme: const AppBarTheme(
      backgroundColor: granate,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: granate,
      foregroundColor: Colors.white,
    ),
  );
}

ThemeData temaOscuro() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: granate,
      brightness: Brightness.dark,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9B2D3C),
      foregroundColor: Colors.white,
    ),
  );
}
