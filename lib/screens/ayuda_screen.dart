import 'package:material_ui/material_ui.dart';

import '../tema.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  static const _preguntas = [
    (
      '¿Cómo reporto un daño?',
      'Toca "Reportar daño", elige el tipo de problema, indica el edificio '
          'y el aula, y cuéntanos qué pasó. Puedes adjuntar una foto.',
    ),
    (
      '¿Qué significan los estados?',
      'Pendiente: aún nadie lo atiende. En revisión: el personal técnico '
          'ya está trabajando en ello. Resuelto: el problema fue solucionado.',
    ),
    (
      '¿Puedo editar o cancelar un reporte?',
      'Sí, mientras esté en estado Pendiente puedes editarlo o eliminarlo '
          'desde su detalle.',
    ),
    (
      '¿Cuánto tarda la solución?',
      'Depende de la urgencia y del tipo de daño. Los reportes de prioridad '
          'alta se atienden primero.',
    ),
    (
      '¿Quién ve mi reporte?',
      'Lo ven el personal técnico y la administración de mantenimiento, '
          'junto con tu nombre para poder contactarte.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Preguntas frecuentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          for (final p in _preguntas)
            ExpansionTile(
              title: Text(p.$1),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(p.$2)],
            ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('¿Necesitas más ayuda?',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const ListTile(
            leading: Icon(Icons.mail_outline, color: granate),
            title: Text('mantenimiento@epn.edu.ec'),
            subtitle: Text('Coordinación de mantenimiento'),
          ),
          const ListTile(
            leading: Icon(Icons.phone_outlined, color: granate),
            title: Text('(02) 297 6300'),
            subtitle: Text('Lunes a viernes, 08:00 a 17:00'),
          ),
        ],
      ),
    );
  }
}
