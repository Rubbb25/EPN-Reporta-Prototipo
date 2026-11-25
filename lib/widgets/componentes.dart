import 'package:material_ui/material_ui.dart';

import '../models/modelos.dart';
import '../screens/detalle_reporte_screen.dart';
import '../tema.dart';

class EstadoEtiqueta extends StatelessWidget {
  const EstadoEtiqueta(this.estado, {super.key});

  final Estado estado;

  @override
  Widget build(BuildContext context) =>
      _Etiqueta(estado.nombre, estado.color);
}

class PrioridadEtiqueta extends StatelessWidget {
  const PrioridadEtiqueta(this.prioridad, {super.key});

  final Prioridad prioridad;

  @override
  Widget build(BuildContext context) =>
      _Etiqueta('Prioridad ${prioridad.nombre.toLowerCase()}', prioridad.color);
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto, this.color);

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(34),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Tarjeta de un reporte para las listas.
class TarjetaReporte extends StatelessWidget {
  const TarjetaReporte(this.reporte, {super.key, this.mostrarAutor = false});

  final Reporte reporte;
  final bool mostrarAutor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleReporteScreen(id: reporte.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: cs.primaryContainer,
                foregroundColor: cs.onPrimaryContainer,
                child: Icon(reporte.categoria.icono),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${reporte.id} · ${reporte.categoria.nombre}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reporte.ubicacion,
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reporte.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        EstadoEtiqueta(reporte.estado),
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: reporte.prioridad.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            mostrarAutor
                                ? '${reporte.autorNombre} · ${hace(reporte.fecha)}'
                                : hace(reporte.fecha),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.texto, {super.key, this.accion, this.onAccion});

  final String texto;
  final String? accion;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          if (accion != null)
            TextButton(onPressed: onAccion, child: Text(accion!)),
        ],
      ),
    );
  }
}

class EstadoVacio extends StatelessWidget {
  const EstadoVacio(this.mensaje, {super.key, this.icono = Icons.inbox_outlined});

  final String mensaje;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: color),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center,
                style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}

class TarjetaDato extends StatelessWidget {
  const TarjetaDato({
    super.key,
    required this.valor,
    required this.titulo,
    required this.icono,
    this.color = granate,
    this.onTap,
  });

  final String valor;
  final String titulo;
  final IconData icono;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                valor,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barra horizontal simple para las estadísticas.
class BarraDato extends StatelessWidget {
  const BarraDato({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.maximo,
    this.color = granate,
  });

  final String etiqueta;
  final int valor;
  final int maximo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraccion = maximo == 0 ? 0.0 : valor / maximo;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(etiqueta, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: fraccion,
                minHeight: 10,
                color: color,
                backgroundColor: color.withAlpha(30),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text('$valor', textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// Marcador de foto: en el prototipo no se usa la cámara real.
class FotoSimulada extends StatelessWidget {
  const FotoSimulada({super.key, this.alto = 160, this.categoria});

  final double alto;
  final Categoria? categoria;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF8E9AAF), Color(0xFFCBC0D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(categoria?.icono ?? Icons.image_outlined,
              size: 48, color: Colors.white),
          const SizedBox(height: 6),
          const Text('Foto adjunta (simulada)',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String accion = 'Confirmar',
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(accion),
        ),
      ],
    ),
  );
  return r ?? false;
}

void aviso(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(texto)));
}
