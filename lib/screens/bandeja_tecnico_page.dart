import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../widgets/componentes.dart';

enum _Vista { porAtender, mios, resueltos }

/// Bandeja del personal técnico: qué atender, qué tiene asignado y qué cerró.
class BandejaTecnicoPage extends StatefulWidget {
  const BandejaTecnicoPage({super.key});

  @override
  State<BandejaTecnicoPage> createState() => _BandejaTecnicoPageState();
}

class _BandejaTecnicoPageState extends State<BandejaTecnicoPage> {
  _Vista _vista = _Vista.porAtender;

  static const _nombres = {
    _Vista.porAtender: 'Por atender',
    _Vista.mios: 'Mis casos',
    _Vista.resueltos: 'Resueltos',
  };

  int _orden(Prioridad p) => p == Prioridad.alta ? 0 : (p == Prioridad.media ? 1 : 2);

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final yo = estado.usuario!;
    final todos = estado.reportes.toList();

    final porAtender = todos
        .where((r) => r.estado == Estado.pendiente && r.tecnicoId == null)
        .toList();
    final mios = todos
        .where((r) => r.tecnicoId == yo.id && r.estado != Estado.resuelto)
        .toList();
    final resueltos = todos
        .where((r) => r.estado == Estado.resuelto && r.tecnicoId == yo.id)
        .toList();

    final List<Reporte> lista = switch (_vista) {
      _Vista.porAtender => porAtender,
      _Vista.mios => mios,
      _Vista.resueltos => resueltos,
    };
    lista.sort((a, b) => _orden(a.prioridad).compareTo(_orden(b.prioridad)));

    final conteos = {
      _Vista.porAtender: porAtender.length,
      _Vista.mios: mios.length,
      _Vista.resueltos: resueltos.length,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TarjetaDato(
                  valor: '${porAtender.length}',
                  titulo: 'Sin atender',
                  icono: Icons.notification_important_outlined,
                  color: Estado.pendiente.color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TarjetaDato(
                  valor: '${mios.length}',
                  titulo: 'En mi cargo',
                  icono: Icons.engineering_outlined,
                  color: Estado.enRevision.color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TarjetaDato(
                  valor: '${resueltos.length}',
                  titulo: 'Cerrados',
                  icono: Icons.task_alt,
                  color: Estado.resuelto.color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final v in _Vista.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${_nombres[v]} (${conteos[v]})'),
                    selected: _vista == v,
                    onSelected: (_) => setState(() => _vista = v),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? const EstadoVacio('No hay reportes en esta lista',
                  icono: Icons.task_alt)
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 6, bottom: 24),
                  itemCount: lista.length,
                  itemBuilder: (context, i) => Column(
                    children: [
                      TarjetaReporte(lista[i], mostrarAutor: true),
                      if (_vista == _Vista.porAtender)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                estado.tomarReporte(lista[i]);
                                aviso(context,
                                    'Tomaste el reporte #${lista[i].id}');
                              },
                              icon: const Icon(Icons.assignment_ind_outlined),
                              label: const Text('Tomar reporte'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
