import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'detalle_reporte_screen.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final lista = estado.notificaciones;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (estado.noLeidas > 0)
            TextButton(
              onPressed: estado.marcarTodasLeidas,
              child: const Text('Marcar leídas',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: lista.isEmpty
          ? const EstadoVacio('No tienes notificaciones',
              icono: Icons.notifications_none)
          : ListView.separated(
              itemCount: lista.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final n = lista[i];
                return ListTile(
                  tileColor: n.leida ? null : granate.withAlpha(16),
                  leading: CircleAvatar(
                    backgroundColor: granate.withAlpha(30),
                    foregroundColor: granate,
                    child: Icon(n.reporteId == null
                        ? Icons.campaign_outlined
                        : Icons.assignment_outlined),
                  ),
                  title: Text(
                    n.titulo,
                    style: TextStyle(
                      fontWeight: n.leida ? FontWeight.w400 : FontWeight.w700,
                    ),
                  ),
                  subtitle: Text('${n.mensaje}\n${hace(n.fecha)}'),
                  isThreeLine: true,
                  onTap: () {
                    estado.marcarLeida(n);
                    final id = n.reporteId;
                    if (id != null && estado.buscar(id) != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleReporteScreen(id: id),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
