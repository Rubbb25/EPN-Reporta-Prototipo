import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../tema.dart';
import '../widgets/componentes.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  String _facultad = 'Ingeniería de Sistemas';

  static const _facultades = [
    'Ingeniería de Sistemas',
    'Ingeniería Eléctrica y Electrónica',
    'Ingeniería Civil y Ambiental',
    'Ingeniería Mecánica',
    'Ingeniería Química y Agroindustria',
    'Geología y Petróleos',
    'Ciencias',
  ];

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _crear() {
    if (!_formKey.currentState!.validate()) return;
    final error = context
        .read<AppState>()
        .registrar(_nombre.text, _correo.text, _facultad);
    if (error != null) {
      aviso(context, error);
      return;
    }
    aviso(context, 'Cuenta creada. Ya puedes iniciar sesión');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Escribe tu nombre' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo institucional',
                hintText: 'nombre.apellido@epn.edu.ec',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || !v.trim().endsWith('@epn.edu.ec'))
                  ? 'Usa tu correo @epn.edu.ec'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clave,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
            ),
            const SizedBox(height: 16),
            const Text('Facultad', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final f in _facultades)
                  ChoiceChip(
                    label: Text(f),
                    selected: _facultad == f,
                    onSelected: (_) => setState(() => _facultad = f),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: granate,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _crear,
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
