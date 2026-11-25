import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'detalle_reporte_screen.dart';

/// Crea un reporte nuevo en 3 pasos, o edita uno existente.
class NuevoReporteScreen extends StatefulWidget {
  const NuevoReporteScreen({super.key, this.categoriaInicial, this.editar});

  final Categoria? categoriaInicial;
  final Reporte? editar;

  @override
  State<NuevoReporteScreen> createState() => _NuevoReporteScreenState();
}

class _NuevoReporteScreenState extends State<NuevoReporteScreen> {
  int _paso = 0;
  late Categoria _categoria;
  late String _edificio;
  late final TextEditingController _lugar;
  late final TextEditingController _descripcion;
  Prioridad _prioridad = Prioridad.media;
  bool _foto = false;
  String? _error;

  bool get _editando => widget.editar != null;

  @override
  void initState() {
    super.initState();
    final r = widget.editar;
    _categoria = r?.categoria ?? widget.categoriaInicial ?? Categoria.proyector;
    _edificio = r?.edificio ?? AppState.edificios.first.nombre;
    _lugar = TextEditingController(text: r?.lugar ?? '');
    _descripcion = TextEditingController(text: r?.descripcion ?? '');
    _foto = r?.tieneFoto ?? false;
    _prioridad = r?.prioridad ?? Prioridad.media;
  }

  @override
  void dispose() {
    _lugar.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  bool _validarPaso() {
    if (_paso == 1 && _lugar.text.trim().isEmpty) {
      setState(() => _error = 'Indica el aula, laboratorio o lugar exacto');
      return false;
    }
    if (_paso == 2 && _descripcion.text.trim().length < 10) {
      setState(() => _error = 'Describe el daño (mínimo 10 caracteres)');
      return false;
    }
    setState(() => _error = null);
    return true;
  }

  void _siguiente() {
    if (!_validarPaso()) return;
    if (_paso < 2) {
      setState(() => _paso++);
      return;
    }
    final estado = context.read<AppState>();
    if (_editando) {
      estado.editarReporte(
        widget.editar!,
        categoria: _categoria,
        edificio: _edificio,
        lugar: _lugar.text.trim(),
        descripcion: _descripcion.text.trim(),
      );
      final mensajes = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      mensajes.showSnackBar(
        const SnackBar(content: Text('Reporte actualizado')),
      );
      return;
    }
    final r = estado.crearReporte(
      categoria: _categoria,
      edificio: _edificio,
      lugar: _lugar.text.trim(),
      descripcion: _descripcion.text.trim(),
      prioridad: _prioridad,
      tieneFoto: _foto,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ReporteEnviadoScreen(id: r.id)),
    );
  }

  Widget _pasoCategoria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Qué se dañó?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            for (final c in Categoria.values)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _categoria = c),
                child: Container(
                  decoration: BoxDecoration(
                    color: _categoria == c
                        ? granate
                        : granate.withAlpha(24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(c.icono,
                          size: 30,
                          color: _categoria == c ? Colors.white : granate),
                      const SizedBox(height: 6),
                      Text(
                        c.nombre,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: _categoria == c ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _pasoUbicacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Dónde está?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        const Text('Edificio', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final e in AppState.edificios)
              ChoiceChip(
                label: Text(e.nombre),
                selected: _edificio == e.nombre,
                onSelected: (_) => setState(() => _edificio = e.nombre),
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _lugar,
          decoration: const InputDecoration(
            labelText: 'Aula, laboratorio o lugar',
            hintText: 'Ej: Aula 204',
            prefixIcon: Icon(Icons.meeting_room_outlined),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _pasoDetalle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cuéntanos el problema',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextField(
          controller: _descripcion,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        if (!_editando) ...[
          const Text('Urgencia',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final p in Prioridad.values)
                ChoiceChip(
                  label: Text(p.nombre),
                  selected: _prioridad == p,
                  onSelected: (_) => setState(() => _prioridad = p),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (_foto)
          Column(
            children: [
              FotoSimulada(categoria: _categoria),
              TextButton.icon(
                onPressed: () => setState(() => _foto = false),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Quitar foto'),
              ),
            ],
          )
        else
          OutlinedButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              builder: (ctx) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Tomar foto'),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _foto = true);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Elegir de la galería'),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _foto = true);
                      },
                    ),
                  ],
                ),
              ),
            ),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Adjuntar foto'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pasos = [_pasoCategoria(), _pasoUbicacion(), _pasoDetalle()];
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar reporte' : 'Nuevo reporte'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_paso + 1) / 3,
            color: granate,
            minHeight: 4,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Paso ${_paso + 1} de 3'),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: pasos[_paso],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_paso > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _paso--;
                        _error = null;
                      }),
                      child: const Text('Atrás'),
                    ),
                  ),
                if (_paso > 0) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: granate),
                    onPressed: _siguiente,
                    child: Text(
                      _paso < 2
                          ? 'Siguiente'
                          : (_editando ? 'Guardar cambios' : 'Enviar reporte'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de confirmación luego de enviar un reporte.
class ReporteEnviadoScreen extends StatelessWidget {
  const ReporteEnviadoScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  size: 96, color: Color(0xFF18794E)),
              const SizedBox(height: 20),
              const Text(
                '¡Reporte enviado!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu reporte #$id quedó registrado. Te avisaremos cuando '
                'el personal técnico lo atienda.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: granate),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleReporteScreen(id: id),
                    ),
                  ),
                  child: const Text('Ver mi reporte'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
