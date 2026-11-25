import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';

/// Administración de usuarios (activar/desactivar y ver detalle).
class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  Rol? _rol;

  void _detalle(Usuario u) {
    final estado = context.read<AppState>();
    final reportes = estado.reportes
        .where((r) => r.autorId == u.id || r.tecnicoId == u.id)
        .length;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: granate,
                    foregroundColor: Colors.white,
                    child: Text(u.iniciales),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.nombre,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        Text(u.rol.nombre),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Correo: ${u.correo}'),
              Text('Teléfono: ${u.telefono.isEmpty ? 'No registrado' : u.telefono}'),
              Text(u.detalle),
              Text('Reportes relacionados: $reportes'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    aviso(context, 'Enlace de restablecimiento enviado (simulado)');
                  },
                  child: const Text('Restablecer contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final lista = estado.usuarios.where((u) => _rol == null || u.rol == _rol).toList();

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('Todos'),
                  selected: _rol == null,
                  onSelected: (_) => setState(() => _rol = null),
                ),
              ),
              for (final r in Rol.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(r.nombre),
                    selected: _rol == r,
                    onSelected: (_) => setState(() => _rol = r),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: lista.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final u = lista[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: u.activo ? granate : Colors.grey,
                  foregroundColor: Colors.white,
                  child: Text(u.iniciales),
                ),
                title: Text(u.nombre),
                subtitle: Text('${u.rol.nombre} · ${u.correo}'),
                onTap: () => _detalle(u),
                trailing: Switch(
                  value: u.activo,
                  onChanged: (v) {
                    estado.cambiarActivo(u, v);
                    aviso(context,
                        v ? 'Cuenta activada' : 'Cuenta desactivada');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
