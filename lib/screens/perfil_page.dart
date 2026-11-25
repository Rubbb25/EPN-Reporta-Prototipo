import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'acerca_screen.dart';
import 'ajustes_screen.dart';
import 'ayuda_screen.dart';
import 'editar_perfil_screen.dart';
import 'login_screen.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final u = estado.usuario!;

    void ir(Widget pantalla) =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: granate,
                foregroundColor: Colors.white,
                child: Text(u.iniciales, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 12),
              Text(
                u.nombre,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(u.correo),
              const SizedBox(height: 8),
              Chip(
                avatar: Icon(u.rol.icono, size: 18),
                label: Text(u.rol.nombre),
              ),
              Text(u.detalle, textAlign: TextAlign.center),
            ],
          ),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Editar perfil'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ir(const EditarPerfilScreen()),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Ajustes'),
          subtitle: const Text('Notificaciones y apariencia'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ir(const AjustesScreen()),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Ayuda y preguntas frecuentes'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ir(const AyudaScreen()),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de EPN Reporta'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ir(const AcercaScreen()),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          onTap: () async {
            final navegador = Navigator.of(context);
            final ok = await confirmar(
              context,
              titulo: 'Cerrar sesión',
              mensaje: '¿Quieres salir de tu cuenta?',
              accion: 'Salir',
            );
            if (!ok) return;
            estado.cerrarSesion();
            navegador.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
