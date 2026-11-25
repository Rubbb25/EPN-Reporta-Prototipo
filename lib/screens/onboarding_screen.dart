import 'package:material_ui/material_ui.dart';

import '../tema.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controlador = PageController();
  int _pagina = 0;

  static const _paginas = [
    (
      Icons.camera_alt_outlined,
      'Reporta en segundos',
      'Elige el tipo de daño, indica el aula y adjunta una foto. '
          'Sin papeles ni filas.',
    ),
    (
      Icons.timeline,
      'Sigue cada paso',
      'Mira en qué estado está tu reporte y recibe avisos cuando '
          'el personal técnico lo atienda.',
    ),
    (
      Icons.map_outlined,
      'Conoce tu campus',
      'Revisa qué edificios tienen más daños y qué ya se resolvió.',
    ),
  ];

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _terminar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ultima = _pagina == _paginas.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _terminar,
                child: const Text('Saltar'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controlador,
                itemCount: _paginas.length,
                onPageChanged: (i) => setState(() => _pagina = i),
                itemBuilder: (context, i) {
                  final p = _paginas[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: granate.withAlpha(28),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(p.$1, size: 70, color: granate),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          p.$2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(p.$3, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _paginas.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _pagina ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _pagina ? granate : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: granate),
                  onPressed: () {
                    if (ultima) {
                      _terminar();
                    } else {
                      _controlador.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(ultima ? 'Comenzar' : 'Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
