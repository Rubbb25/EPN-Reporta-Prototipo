import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../tema.dart';
import '../widgets/componentes.dart';
import 'nuevo_reporte_screen.dart';

class DetalleReporteScreen extends StatefulWidget {
  const DetalleReporteScreen({super.key, required this.id});

  final int id;

  @override
  State<DetalleReporteScreen> createState() => _DetalleReporteScreenState();
}

class _DetalleReporteScreenState extends State<DetalleReporteScreen> {
  final _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  Future<void> _eliminar(AppState estado, Reporte r) async {
    final mensajes = ScaffoldMessenger.of(context);
    final navegador = Navigator.of(context);
    final ok = await confirmar(
      context,
      titulo: 'Eliminar reporte',
      mensaje: 'El reporte #${r.id} se eliminará. Esta acción no se puede deshacer.',
      accion: 'Eliminar',
    );
    if (!ok) return;
    estado.eliminarReporte(r);
    navegador.pop();
    mensajes.showSnackBar(const SnackBar(content: Text('Reporte eliminado')));
  }

  Widget _fila(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20, color: granate),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                Text(valor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _estados(AppState estado, Reporte r) {
    return Wrap(
      spacing: 8,
      children: [
        for (final e in Estado.values)
          ChoiceChip(
            label: Text(e.nombre),
            selected: r.estado == e,
            onSelected: (_) {
              estado.cambiarEstado(r, e);
              aviso(context, 'Estado actualizado a ${e.nombre}');
            },
          ),
      ],
    );
  }

  Widget _acciones(AppState estado, Reporte r) {
    final u = estado.usuario!;
    final esMio = r.tecnicoId == u.id;

    switch (u.rol) {
      case Rol.estudiante:
        return const SizedBox.shrink();

      case Rol.tecnico:
        return Card(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Atención técnica',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                if (!esMio)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: granate),
                      onPressed: () {
                        estado.tomarReporte(r);
                        aviso(context, 'Tomaste el reporte #${r.id}');
                      },
                      icon: const Icon(Icons.assignment_ind_outlined),
                      label: const Text('Tomar este reporte'),
                    ),
                  )
                else ...[
                  const Text('Cambiar estado'),
                  const SizedBox(height: 6),
                  _estados(estado, r),
                ],
              ],
            ),
          ),
        );

      case Rol.admin:
        return Card(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gestión',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const Text('Asignar a'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Sin asignar'),
                      selected: r.tecnicoId == null,
                      onSelected: (_) => estado.asignarTecnico(r, null),
                    ),
                    for (final t in estado.tecnicos)
                      ChoiceChip(
                        label: Text(t.nombre),
                        selected: r.tecnicoId == t.id,
                        onSelected: (_) {
                          estado.asignarTecnico(r, t.id);
                          aviso(context, 'Asignado a ${t.nombre}');
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Prioridad'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final p in Prioridad.values)
                      ChoiceChip(
                        label: Text(p.nombre),
                        selected: r.prioridad == p,
                        onSelected: (_) => estado.cambiarPrioridad(r, p),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Estado'),
                const SizedBox(height: 6),
                _estados(estado, r),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final r = estado.buscar(widget.id);
    if (r == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reporte')),
        body: const EstadoVacio('Este reporte ya no existe'),
      );
    }

    final u = estado.usuario!;
    final esAutor = r.autorId == u.id;
    final puedeEditar = esAutor && r.estado == Estado.pendiente;
    final puedeEliminar =
        u.rol == Rol.admin || (esAutor && r.estado == Estado.pendiente);
    final tecnico = estado.buscarUsuario(r.tecnicoId);
    final eventos = r.eventos.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte #${r.id}'),
        actions: [
          if (puedeEditar)
            IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NuevoReporteScreen(editar: r),
                ),
              ),
            ),
          if (puedeEliminar)
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _eliminar(estado, r),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: granate.withAlpha(30),
                      foregroundColor: granate,
                      child: Icon(r.categoria.icono),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        r.categoria.nombre,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    EstadoEtiqueta(r.estado),
                  ],
                ),
                const SizedBox(height: 10),
                PrioridadEtiqueta(r.prioridad),
                const SizedBox(height: 8),
                _fila(Icons.place_outlined, 'Lugar', r.ubicacion),
                _fila(Icons.notes, 'Descripción', r.descripcion),
                _fila(Icons.schedule, 'Fecha del reporte', formatoFecha(r.fecha)),
                _fila(Icons.person_outline, 'Reportado por', r.autorNombre),
                _fila(
                  Icons.engineering_outlined,
                  'Técnico asignado',
                  tecnico?.nombre ?? 'Aún sin asignar',
                ),
                if (r.tieneFoto) ...[
                  const SizedBox(height: 8),
                  FotoSimulada(categoria: r.categoria),
                ],
              ],
            ),
          ),
          _acciones(estado, r),
          const TituloSeccion('Seguimiento'),
          for (var i = 0; i < eventos.length; i++)
            ListTile(
              dense: true,
              leading: Icon(
                i == 0 ? Icons.radio_button_checked : Icons.circle_outlined,
                size: 18,
                color: granate,
              ),
              title: Text(eventos[i].titulo),
              subtitle: Text('${eventos[i].autor} · ${formatoFecha(eventos[i].fecha)}'),
            ),
          const TituloSeccion('Comentarios'),
          if (r.comentarios.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Aún no hay comentarios.'),
            ),
          for (final c in r.comentarios)
            ListTile(
              leading: CircleAvatar(
                radius: 16,
                child: Icon(c.rol.icono, size: 16),
              ),
              title: Text(c.autor, style: const TextStyle(fontSize: 13)),
              subtitle: Text(c.texto),
              trailing: Text(hace(c.fecha), style: const TextStyle(fontSize: 11)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentario,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un comentario',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: granate),
                  onPressed: () {
                    estado.comentar(r, _comentario.text);
                    _comentario.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
