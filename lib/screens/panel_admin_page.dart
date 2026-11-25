import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';

/// Panel de administración con indicadores del campus.
class PanelAdminPage extends StatelessWidget {
  const PanelAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final todos = estado.reportes.toList();
    final total = todos.length;
    final resueltos = estado.contar(Estado.resuelto);
    final porcentaje = total == 0 ? 0 : (resueltos * 100 / total).round();
    final sinAsignar = todos
        .where((r) => r.tecnicoId == null && r.estado != Estado.resuelto)
        .length;
    final urgentes = todos
        .where((r) => r.prioridad == Prioridad.alta && r.estado != Estado.resuelto)
        .toList();

    final categorias = estado.porCategoria.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final edificios = estado.porEdificio.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCat = categorias.isEmpty ? 0 : categorias.first.value;
    final maxEdi = edificios.isEmpty ? 0 : edificios.first.value;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.7,
            children: [
              TarjetaDato(
                valor: '$total',
                titulo: 'Reportes totales',
                icono: Icons.assignment_outlined,
              ),
              TarjetaDato(
                valor: '$porcentaje%',
                titulo: 'Resueltos',
                icono: Icons.task_alt,
                color: Estado.resuelto.color,
              ),
              TarjetaDato(
                valor: '$sinAsignar',
                titulo: 'Sin técnico asignado',
                icono: Icons.person_off_outlined,
                color: Estado.pendiente.color,
              ),
              const TarjetaDato(
                valor: '1,8 días',
                titulo: 'Tiempo medio de solución',
                icono: Icons.timer_outlined,
                color: Color(0xFF9A6700),
              ),
            ],
          ),
        ),
        const TituloSeccion('Reportes por estado'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final e in Estado.values)
                BarraDato(
                  etiqueta: e.nombre,
                  valor: estado.contar(e),
                  maximo: total,
                  color: e.color,
                ),
            ],
          ),
        ),
        const TituloSeccion('Por categoría'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final c in categorias)
                BarraDato(
                  etiqueta: c.key.nombre,
                  valor: c.value,
                  maximo: maxCat,
                ),
            ],
          ),
        ),
        const TituloSeccion('Edificios con más reportes'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final e in edificios)
                BarraDato(etiqueta: e.key, valor: e.value, maximo: maxEdi),
            ],
          ),
        ),
        TituloSeccion('Urgentes sin resolver (${urgentes.length})'),
        if (urgentes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay reportes urgentes abiertos.'),
          )
        else
          for (final r in urgentes) TarjetaReporte(r, mostrarAutor: true),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Datos de ejemplo del prototipo.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
