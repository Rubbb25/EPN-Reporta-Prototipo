import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'edificio_screen.dart';

/// Mapa esquemático del campus con el número de reportes por edificio.
class MapaPage extends StatelessWidget {
  const MapaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final cs = Theme.of(context).colorScheme;

    int abiertos(String edificio) => estado
        .reportesDeEdificio(edificio)
        .where((r) => r.estado != Estado.resuelto)
        .length;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Toca un edificio para ver sus reportes. El número indica los '
            'reportes abiertos.',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: AspectRatio(
            aspectRatio: 1.1,
            child: LayoutBuilder(
              builder: (context, caja) {
                return Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: caja.maxWidth * 0.05,
                        right: caja.maxWidth * 0.05,
                        top: caja.maxHeight * 0.44,
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: cs.outlineVariant,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      Positioned(
                        top: caja.maxHeight * 0.06,
                        bottom: caja.maxHeight * 0.06,
                        left: caja.maxWidth * 0.5,
                        child: Container(
                          width: 14,
                          decoration: BoxDecoration(
                            color: cs.outlineVariant,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      for (final e in AppState.edificios)
                        Positioned(
                          left: caja.maxWidth * e.x - 28,
                          top: caja.maxHeight * e.y - 28,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EdificioScreen(edificio: e),
                              ),
                            ),
                            child: _Pin(
                              sigla: e.sigla,
                              cantidad: abiertos(e.nombre),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const TituloSeccion('Edificios'),
        for (final e in AppState.edificios)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: granate.withAlpha(30),
              foregroundColor: granate,
              child: const Icon(Icons.apartment),
            ),
            title: Text(e.nombre),
            subtitle: Text(
              '${abiertos(e.nombre)} abiertos · '
              '${estado.reportesDeEdificio(e.nombre).length} en total',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EdificioScreen(edificio: e)),
            ),
          ),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.sigla, required this.cantidad});

  final String sigla;
  final int cantidad;

  @override
  Widget build(BuildContext context) {
    final color = cantidad == 0
        ? const Color(0xFF18794E)
        : (cantidad >= 3 ? const Color(0xFFB42318) : const Color(0xFF9A6700));
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              sigla,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '$cantidad',
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
