import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'data/app_state.dart';
import 'screens/splash_screen.dart';
import 'tema.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const EpnReportaApp(),
    ),
  );
}

class EpnReportaApp extends StatelessWidget {
  const EpnReportaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modo = context.select<AppState, ThemeMode>((s) => s.themeMode);
    return MaterialApp(
      title: 'EPN Reporta',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaOscuro(),
      themeMode: modo,
      home: const SplashScreen(),
    );
  }
}
