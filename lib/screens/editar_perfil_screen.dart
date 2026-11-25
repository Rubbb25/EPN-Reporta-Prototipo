import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../tema.dart';
import '../widgets/componentes.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  late final TextEditingController _nombre;
  late final TextEditingController _detalle;
  late final TextEditingController _telefono;

  @override
  void initState() {
    super.initState();
    final u = context.read<AppState>().usuario!;
    _nombre = TextEditingController(text: u.nombre);
    _detalle = TextEditingController(text: u.detalle);
    _telefono = TextEditingController(text: u.telefono);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _detalle.dispose();
    _telefono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final u = context.read<AppState>().usuario!;
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(
              labelText: 'Nombre completo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: TextEditingController(text: u.correo),
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Correo institucional',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _detalle,
            decoration: const InputDecoration(
              labelText: 'Facultad / área',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _telefono,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: granate,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              if (_nombre.text.trim().length < 3) {
                aviso(context, 'Escribe un nombre válido');
                return;
              }
              context.read<AppState>().actualizarPerfil(
                    nombre: _nombre.text,
                    detalle: _detalle.text,
                    telefono: _telefono.text,
                  );
              final mensajes = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              mensajes.showSnackBar(
                const SnackBar(content: Text('Perfil actualizado')),
              );
            },
            child: const Text('Guardar cambios'),
          ),
        ],
      ),
    );
  }
}
