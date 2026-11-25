import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../widgets/componentes.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          const TituloSeccion('Notificaciones'),
          SwitchListTile(
            title: const Text('Avisos en el teléfono'),
            subtitle: const Text('Cuando cambie el estado de tus reportes'),
            value: estado.notifPush,
            onChanged: (v) => estado.cambiarAjuste(push: v),
          ),
          SwitchListTile(
            title: const Text('Avisos por correo'),
            subtitle: const Text('Un resumen semanal a tu correo EPN'),
            value: estado.notifCorreo,
            onChanged: (v) => estado.cambiarAjuste(correo: v),
          ),
          SwitchListTile(
            title: const Text('Avisar cuando se resuelva'),
            value: estado.notifResueltos,
            onChanged: (v) => estado.cambiarAjuste(resueltos: v),
          ),
          const TituloSeccion('Apariencia'),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: estado.modoOscuro,
            onChanged: (v) => estado.cambiarAjuste(oscuro: v),
          ),
          const TituloSeccion('Datos'),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Restablecer datos de ejemplo'),
            subtitle: const Text('Vuelve a cargar los reportes iniciales'),
            onTap: () => aviso(
              context,
              'Cierra y abre la app para recargar los datos de ejemplo',
            ),
          ),
        ],
      ),
    );
  }
}
