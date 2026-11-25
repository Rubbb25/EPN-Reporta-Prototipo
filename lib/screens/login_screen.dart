import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'home_shell.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correo = TextEditingController(text: 'maria.pazmino@epn.edu.ec');
  final _clave = TextEditingController(text: '123456');
  bool _ocultar = true;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _entrar() {
    final estado = context.read<AppState>();
    final error = estado.ingresar(_correo.text, _clave.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    _irAlInicio();
  }

  void _irAlInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  void _usarPerfil(Rol rol) {
    final u = context.read<AppState>().usuarioDemo(rol);
    setState(() {
      _correo.text = u.correo;
      _clave.text = '123456';
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: granate,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.report_problem_outlined,
                      color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'EPN Reporta',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Inicia sesión',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text('Usa tu correo institucional.'),
            const SizedBox(height: 16),
            TextField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo institucional',
                prefixIcon: Icon(Icons.mail_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _clave,
              obscureText: _ocultar,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_ocultar ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _ocultar = !_ocultar),
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => aviso(
                  context,
                  'Te enviamos un enlace para restablecer tu contraseña (simulado)',
                ),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: granate,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _entrar,
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegistroScreen()),
              ),
              child: const Text('Crear cuenta'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Prototipo: entra con un perfil de ejemplo',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (final rol in Rol.values)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(rol.icono, color: granate),
                  title: Text(rol.nombre),
                  subtitle: Text(estado.usuarioDemo(rol).nombre),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _usarPerfil(rol);
                    estado.ingresarComo(rol);
                    _irAlInicio();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
