import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../widgets/componentes.dart';

class EdificioScreen extends StatelessWidget {
  const EdificioScreen({super.key, required this.edificio});

  final Edificio edificio;

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final lista = estado.reportesDeEdificio(edificio.nombre);
    final esEstudiante = estado.usuario?.rol == Rol.estudiante;

    return Scaffold(
      appBar: AppBar(title: Text(edificio.nombre)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TarjetaDato(
                    valor: '${estado.contar(Estado.pendiente, lista: lista)}',
                    titulo: 'Pendientes',
                    icono: Icons.schedule,
                    color: Estado.pendiente.color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TarjetaDato(
                    valor: '${estado.contar(Estado.enRevision, lista: lista)}',
                    titulo: 'En revisión',
                    icono: Icons.manage_search,
                    color: Estado.enRevision.color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TarjetaDato(
                    valor: '${estado.contar(Estado.resuelto, lista: lista)}',
                    titulo: 'Resueltos',
                    icono: Icons.check_circle_outline,
                    color: Estado.resuelto.color,
                  ),
                ),
              ],
            ),
          ),
          if (lista.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: EstadoVacio('Este edificio no tiene reportes',
                  icono: Icons.verified_outlined),
            )
          else
            for (final r in lista) TarjetaReporte(r, mostrarAutor: !esEstudiante),
        ],
      ),
    );
  }
}
