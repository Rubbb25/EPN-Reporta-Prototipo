import 'package:material_ui/material_ui.dart';

import '../tema.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: granate,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.report_problem_outlined,
                    size: 48, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'EPN Reporta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const Text('Versión 0.1 · Prototipo'),
              const SizedBox(height: 16),
              const Text(
                'Aplicación para reportar daños en aulas, laboratorios y baños '
                'de la Escuela Politécnica Nacional y darles seguimiento hasta '
                'su solución.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Este prototipo usa datos de ejemplo guardados solo en memoria.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
