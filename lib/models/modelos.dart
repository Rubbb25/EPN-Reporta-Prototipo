import 'package:material_ui/material_ui.dart';

enum Rol {
  estudiante('Estudiante / Docente', Icons.school_outlined),
  tecnico('Personal técnico', Icons.build_outlined),
  admin('Administrador', Icons.admin_panel_settings_outlined);

  const Rol(this.nombre, this.icono);

  final String nombre;
  final IconData icono;
}

class Usuario {
  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.detalle,
    this.telefono = '',
    this.activo = true,
  });

  final int id;
  String nombre;
  final String correo;
  final Rol rol;

  /// Facultad (estudiantes), especialidad (técnicos) o cargo (administrador).
  String detalle;
  String telefono;
  bool activo;

  String get iniciales {
    final partes = nombre.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes[1][0]).toUpperCase();
  }
}

enum Categoria {
  proyector('Proyector', Icons.slideshow),
  foco('Iluminación', Icons.lightbulb_outline),
  computadora('Computadora', Icons.computer),
  bano('Baños', Icons.wc),
  mobiliario('Mobiliario', Icons.event_seat),
  red('Internet / Red', Icons.wifi),
  otro('Otro', Icons.more_horiz);

  const Categoria(this.nombre, this.icono);

  final String nombre;
  final IconData icono;
}

enum Prioridad {
  baja('Baja', Color(0xFF18794E)),
  media('Media', Color(0xFF9A6700)),
  alta('Alta', Color(0xFFB42318));

  const Prioridad(this.nombre, this.color);

  final String nombre;
  final Color color;
}

enum Estado {
  pendiente('Pendiente', Color(0xFFB42318)),
  enRevision('En revisión', Color(0xFF9A6700)),
  resuelto('Resuelto', Color(0xFF18794E));

  const Estado(this.nombre, this.color);

  final String nombre;
  final Color color;
}

class Edificio {
  const Edificio(this.nombre, this.sigla, this.x, this.y);

  final String nombre;
  final String sigla;

  /// Posición relativa (0 a 1) en el mapa esquemático del campus.
  final double x;
  final double y;
}

class Evento {
  const Evento(this.titulo, this.fecha, this.autor);

  final String titulo;
  final DateTime fecha;
  final String autor;
}

class Comentario {
  const Comentario(this.autor, this.rol, this.texto, this.fecha);

  final String autor;
  final Rol rol;
  final String texto;
  final DateTime fecha;
}

class Reporte {
  Reporte({
    required this.id,
    required this.categoria,
    required this.edificio,
    required this.lugar,
    required this.descripcion,
    required this.fecha,
    required this.autorId,
    required this.autorNombre,
    this.estado = Estado.pendiente,
    this.prioridad = Prioridad.media,
    this.tecnicoId,
    this.tieneFoto = false,
    List<Evento>? eventos,
    List<Comentario>? comentarios,
  })  : eventos = eventos ?? [],
        comentarios = comentarios ?? [];

  final int id;
  Categoria categoria;
  String edificio;
  String lugar;
  String descripcion;
  final DateTime fecha;
  final int autorId;
  final String autorNombre;
  Estado estado;
  Prioridad prioridad;
  int? tecnicoId;
  bool tieneFoto;
  final List<Evento> eventos;
  final List<Comentario> comentarios;

  String get ubicacion => '$edificio · $lugar';
}

class Notificacion {
  Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    required this.rol,
    this.usuarioId,
    this.reporteId,
    this.leida = false,
  });

  final int id;
  final String titulo;
  final String mensaje;
  final DateTime fecha;

  /// Perfil al que se le muestra.
  final Rol rol;

  /// Si es null, la ven todos los usuarios de ese perfil.
  final int? usuarioId;
  final int? reporteId;
  bool leida;
}

String dos(int n) => n.toString().padLeft(2, '0');

String formatoFecha(DateTime f) =>
    '${dos(f.day)}/${dos(f.month)}/${f.year} ${dos(f.hour)}:${dos(f.minute)}';

String hace(DateTime f) {
  final d = DateTime.now().difference(f);
  if (d.inMinutes < 1) return 'Ahora';
  if (d.inMinutes < 60) return 'Hace ${d.inMinutes} min';
  if (d.inHours < 24) return 'Hace ${d.inHours} h';
  if (d.inDays < 7) return 'Hace ${d.inDays} d';
  return formatoFecha(f);
}
