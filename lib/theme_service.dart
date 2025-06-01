import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode
      ? ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF000B24),
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF90CAF9),
            secondary: Color(0xFF90CAF9),
          ),
        )
      : ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1976D2),
            secondary: Color(0xFF1976D2),
          ),
        );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Méthode pour obtenir les couleurs communes
  Color get backgroundColor => _isDarkMode
      ? const Color.fromARGB(255, 0, 10, 27)
      : const Color.fromARGB(255, 242, 251, 255);

  Color get surfaceColor => _isDarkMode
      ? const Color.fromARGB(255, 0, 10, 27)
      : const Color(0xFFFAFDFD);

  Color get textColor => _isDarkMode
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 0, 0);

  Color get buttonColor => _isDarkMode
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 64, 255).withOpacity(0.6);

  Color get foregroundColor => _isDarkMode
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 195, 231, 255);
}
