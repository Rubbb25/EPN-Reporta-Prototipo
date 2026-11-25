import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'ayuda_screen.dart';
import 'nuevo_reporte_screen.dart';

class InicioEstudiantePage extends StatelessWidget {
  const InicioEstudiantePage({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final usuario = estado.usuario!;
    final mios = estado.misReportes;
    final recientes = mios.take(3).toList();
    final primerNombre = usuario.nombre.split(' ').first;

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            'Hola, $primerNombre',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('¿Viste algo dañado en el campus?'),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.0,
            children: [
              TarjetaDato(
                valor: '${estado.contar(Estado.pendiente, lista: mios)}',
                titulo: 'Pendientes',
                icono: Icons.schedule,
                color: Estado.pendiente.color,
              ),
              TarjetaDato(
                valor: '${estado.contar(Estado.enRevision, lista: mios)}',
                titulo: 'En revisión',
                icono: Icons.manage_search,
                color: Estado.enRevision.color,
              ),
              TarjetaDato(
                valor: '${estado.contar(Estado.resuelto, lista: mios)}',
                titulo: 'Resueltos',
                icono: Icons.check_circle_outline,
                color: Estado.resuelto.color,
              ),
            ],
          ),
        ),
        const TituloSeccion('Reportar rápido'),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final c in Categoria.values)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NuevoReporteScreen(categoriaInicial: c),
                      ),
                    ),
                    child: Container(
                      width: 92,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: granate.withAlpha(24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(c.icono, color: granate),
                          const SizedBox(height: 6),
                          Text(
                            c.nombre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const TituloSeccion('Mis últimos reportes'),
        if (recientes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Aún no has enviado reportes.'),
          )
        else
          for (final r in recientes) TarjetaReporte(r),
        const TituloSeccion('Consejos'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            leading: const Icon(Icons.help_outline, color: granate),
            title: const Text('¿Cómo hacer un buen reporte?'),
            subtitle: const Text('Indica el aula exacta y adjunta una foto.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AyudaScreen()),
            ),
          ),
        ),
      ],
    );
  }
}
