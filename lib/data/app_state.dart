import 'dart:collection';

import 'package:material_ui/material_ui.dart';

import '../models/modelos.dart';

/// Estado de toda la app. Los datos viven solo en memoria (prototipo):
/// al cerrar la aplicación se vuelven a cargar los datos de ejemplo.
class AppState extends ChangeNotifier {
  AppState() {
    _cargarDatosDeEjemplo();
  }

  // ---------------------------------------------------------------- sesión
  Usuario? usuario;

  final List<Usuario> usuarios = [
    Usuario(
      id: 1,
      nombre: 'María Fernanda Pazmiño',
      correo: 'maria.pazmino@epn.edu.ec',
      rol: Rol.estudiante,
      detalle: 'Facultad de Ingeniería de Sistemas',
      telefono: '0991234567',
    ),
    Usuario(
      id: 2,
      nombre: 'Diego Salazar',
      correo: 'diego.salazar@epn.edu.ec',
      rol: Rol.estudiante,
      detalle: 'Facultad de Ingeniería Eléctrica y Electrónica',
      telefono: '0987654321',
    ),
    Usuario(
      id: 3,
      nombre: 'Carlos Andrade',
      correo: 'carlos.andrade@epn.edu.ec',
      rol: Rol.tecnico,
      detalle: 'Electricidad y audiovisuales',
      telefono: '0998877665',
    ),
    Usuario(
      id: 4,
      nombre: 'Patricia Quishpe',
      correo: 'patricia.quishpe@epn.edu.ec',
      rol: Rol.tecnico,
      detalle: 'Infraestructura y redes',
      telefono: '0984433221',
    ),
    Usuario(
      id: 5,
      nombre: 'Lucía Herrera',
      correo: 'lucia.herrera@epn.edu.ec',
      rol: Rol.admin,
      detalle: 'Coordinación de mantenimiento',
      telefono: '0995566778',
    ),
  ];

  Usuario usuarioDemo(Rol rol) => usuarios.firstWhere((u) => u.rol == rol);

  /// Login simulado: acepta cualquier clave no vacía si el correo existe.
  String? ingresar(String correo, String clave) {
    final c = correo.trim().toLowerCase();
    final encontrado = usuarios.where((u) => u.correo == c).toList();
    if (encontrado.isEmpty) return 'No existe una cuenta con ese correo';
    if (clave.isEmpty) return 'Escribe tu contraseña';
    if (!encontrado.first.activo) return 'Tu cuenta está desactivada';
    usuario = encontrado.first;
    notifyListeners();
    return null;
  }

  void ingresarComo(Rol rol) {
    usuario = usuarioDemo(rol);
    notifyListeners();
  }

  void cerrarSesion() {
    usuario = null;
    notifyListeners();
  }

  String? registrar(String nombre, String correo, String facultad) {
    final c = correo.trim().toLowerCase();
    if (usuarios.any((u) => u.correo == c)) {
      return 'Ya existe una cuenta con ese correo';
    }
    usuarios.add(
      Usuario(
        id: _siguienteUsuario++,
        nombre: nombre.trim(),
        correo: c,
        rol: Rol.estudiante,
        detalle: facultad,
      ),
    );
    notifyListeners();
    return null;
  }

  void actualizarPerfil({
    required String nombre,
    required String detalle,
    required String telefono,
  }) {
    final u = usuario;
    if (u == null) return;
    u.nombre = nombre.trim();
    u.detalle = detalle.trim();
    u.telefono = telefono.trim();
    notifyListeners();
  }

  void cambiarActivo(Usuario u, bool activo) {
    u.activo = activo;
    notifyListeners();
  }

  int _siguienteUsuario = 6;

  // --------------------------------------------------------------- ajustes
  bool modoOscuro = false;
  bool notifPush = true;
  bool notifCorreo = false;
  bool notifResueltos = true;

  ThemeMode get themeMode => modoOscuro ? ThemeMode.dark : ThemeMode.light;

  void cambiarAjuste({
    bool? oscuro,
    bool? push,
    bool? correo,
    bool? resueltos,
  }) {
    if (oscuro != null) modoOscuro = oscuro;
    if (push != null) notifPush = push;
    if (correo != null) notifCorreo = correo;
    if (resueltos != null) notifResueltos = resueltos;
    notifyListeners();
  }

  // -------------------------------------------------------------- catálogo
  static const List<Edificio> edificios = [
    Edificio('Edificio de Sistemas', 'FIS', 0.22, 0.25),
    Edificio('Eléctrica y Electrónica', 'FIEE', 0.58, 0.18),
    Edificio('Civil y Ambiental', 'FICA', 0.82, 0.32),
    Edificio('Mecánica', 'FIM', 0.18, 0.62),
    Edificio('Química y Agroindustria', 'FIQA', 0.45, 0.50),
    Edificio('Geología y Petróleos', 'FIGP', 0.74, 0.66),
    Edificio('Biblioteca Central', 'BIB', 0.40, 0.82),
    Edificio('Aula Magna', 'AM', 0.88, 0.88),
  ];

  // --------------------------------------------------------------- reportes
  final List<Reporte> _reportes = [];
  int _siguienteReporte = 1;

  UnmodifiableListView<Reporte> get reportes =>
      UnmodifiableListView(_reportes);

  Reporte? buscar(int id) {
    for (final r in _reportes) {
      if (r.id == id) return r;
    }
    return null;
  }

  Usuario? buscarUsuario(int? id) {
    if (id == null) return null;
    for (final u in usuarios) {
      if (u.id == id) return u;
    }
    return null;
  }

  List<Usuario> get tecnicos =>
      usuarios.where((u) => u.rol == Rol.tecnico).toList();

  List<Reporte> get misReportes {
    final u = usuario;
    if (u == null) return [];
    return _reportes.where((r) => r.autorId == u.id).toList();
  }

  List<Reporte> reportesDeEdificio(String edificio) =>
      _reportes.where((r) => r.edificio == edificio).toList();

  int contar(Estado estado, {List<Reporte>? lista}) =>
      (lista ?? _reportes).where((r) => r.estado == estado).length;

  Map<Categoria, int> get porCategoria {
    final mapa = <Categoria, int>{};
    for (final c in Categoria.values) {
      mapa[c] = _reportes.where((r) => r.categoria == c).length;
    }
    return mapa;
  }

  Map<String, int> get porEdificio {
    final mapa = <String, int>{};
    for (final e in edificios) {
      mapa[e.nombre] = _reportes.where((r) => r.edificio == e.nombre).length;
    }
    return mapa;
  }

  Reporte crearReporte({
    required Categoria categoria,
    required String edificio,
    required String lugar,
    required String descripcion,
    required Prioridad prioridad,
    required bool tieneFoto,
  }) {
    final u = usuario!;
    final r = Reporte(
      id: _siguienteReporte++,
      categoria: categoria,
      edificio: edificio,
      lugar: lugar,
      descripcion: descripcion,
      fecha: DateTime.now(),
      autorId: u.id,
      autorNombre: u.nombre,
      prioridad: prioridad,
      tieneFoto: tieneFoto,
    );
    r.eventos.add(Evento('Reporte creado', r.fecha, u.nombre));
    _reportes.insert(0, r);
    _notificar(
      Rol.admin,
      'Nuevo reporte #${r.id}',
      '${r.categoria.nombre} en ${r.ubicacion}',
      reporteId: r.id,
    );
    _notificar(
      Rol.tecnico,
      'Nuevo reporte #${r.id}',
      '${r.categoria.nombre} en ${r.ubicacion}',
      reporteId: r.id,
    );
    notifyListeners();
    return r;
  }

  void editarReporte(
    Reporte r, {
    required Categoria categoria,
    required String edificio,
    required String lugar,
    required String descripcion,
  }) {
    r.categoria = categoria;
    r.edificio = edificio;
    r.lugar = lugar;
    r.descripcion = descripcion;
    r.eventos.add(Evento('Reporte editado', DateTime.now(), usuario!.nombre));
    notifyListeners();
  }

  void cambiarEstado(Reporte r, Estado nuevo) {
    if (r.estado == nuevo) return;
    r.estado = nuevo;
    final autor = usuario?.nombre ?? 'Sistema';
    r.eventos.add(Evento('Estado: ${nuevo.nombre}', DateTime.now(), autor));
    if (nuevo != Estado.resuelto || notifResueltos) {
      _notificar(
        Rol.estudiante,
        'Tu reporte #${r.id} cambió de estado',
        '${r.categoria.nombre} · ahora está ${nuevo.nombre.toLowerCase()}',
        usuarioId: r.autorId,
        reporteId: r.id,
      );
    }
    notifyListeners();
  }

  void asignarTecnico(Reporte r, int? tecnicoId) {
    r.tecnicoId = tecnicoId;
    final tecnico = buscarUsuario(tecnicoId);
    final autor = usuario?.nombre ?? 'Sistema';
    if (tecnico == null) {
      r.eventos.add(Evento('Asignación retirada', DateTime.now(), autor));
    } else {
      r.eventos.add(
        Evento('Asignado a ${tecnico.nombre}', DateTime.now(), autor),
      );
      if (r.estado == Estado.pendiente) r.estado = Estado.enRevision;
      _notificar(
        Rol.tecnico,
        'Te asignaron el reporte #${r.id}',
        '${r.categoria.nombre} en ${r.ubicacion}',
        usuarioId: tecnico.id,
        reporteId: r.id,
      );
    }
    notifyListeners();
  }

  void tomarReporte(Reporte r) {
    final u = usuario;
    if (u == null) return;
    r.tecnicoId = u.id;
    r.eventos.add(Evento('Tomado por ${u.nombre}', DateTime.now(), u.nombre));
    if (r.estado == Estado.pendiente) {
      r.estado = Estado.enRevision;
      _notificar(
        Rol.estudiante,
        'Tu reporte #${r.id} está en revisión',
        '${u.nombre} ya está atendiendo tu reporte',
        usuarioId: r.autorId,
        reporteId: r.id,
      );
    }
    notifyListeners();
  }

  void cambiarPrioridad(Reporte r, Prioridad p) {
    r.prioridad = p;
    r.eventos.add(
      Evento('Prioridad: ${p.nombre}', DateTime.now(), usuario!.nombre),
    );
    notifyListeners();
  }

  void comentar(Reporte r, String texto) {
    final u = usuario;
    if (u == null || texto.trim().isEmpty) return;
    r.comentarios.add(Comentario(u.nombre, u.rol, texto.trim(), DateTime.now()));
    notifyListeners();
  }

  void eliminarReporte(Reporte r) {
    _reportes.remove(r);
    notifyListeners();
  }

  // ---------------------------------------------------------- notificaciones
  final List<Notificacion> _notificaciones = [];
  int _siguienteNotificacion = 1;

  List<Notificacion> get notificaciones {
    final u = usuario;
    if (u == null) return [];
    return _notificaciones
        .where((n) => n.rol == u.rol && (n.usuarioId == null || n.usuarioId == u.id))
        .toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  int get noLeidas => notificaciones.where((n) => !n.leida).length;

  void marcarLeida(Notificacion n) {
    n.leida = true;
    notifyListeners();
  }

  void marcarTodasLeidas() {
    for (final n in notificaciones) {
      n.leida = true;
    }
    notifyListeners();
  }

  void _notificar(
    Rol rol,
    String titulo,
    String mensaje, {
    int? usuarioId,
    int? reporteId,
  }) {
    if (!notifPush) return;
    _notificaciones.add(
      Notificacion(
        id: _siguienteNotificacion++,
        titulo: titulo,
        mensaje: mensaje,
        fecha: DateTime.now(),
        rol: rol,
        usuarioId: usuarioId,
        reporteId: reporteId,
      ),
    );
  }

  // ------------------------------------------------------- datos de ejemplo
  void _cargarDatosDeEjemplo() {
    DateTime atras(int dias, [int horas = 0]) =>
        DateTime.now().subtract(Duration(days: dias, hours: horas));

    Reporte nuevo(
      Categoria c,
      String edificio,
      String lugar,
      String descripcion,
      DateTime fecha,
      Usuario autor,
      Estado estado,
      Prioridad prioridad, {
      int? tecnicoId,
      bool foto = false,
    }) {
      final r = Reporte(
        id: _siguienteReporte++,
        categoria: c,
        edificio: edificio,
        lugar: lugar,
        descripcion: descripcion,
        fecha: fecha,
        autorId: autor.id,
        autorNombre: autor.nombre,
        estado: estado,
        prioridad: prioridad,
        tecnicoId: tecnicoId,
        tieneFoto: foto,
      );
      r.eventos.add(Evento('Reporte creado', fecha, autor.nombre));
      if (tecnicoId != null) {
        r.eventos.add(
          Evento(
            'Asignado a ${buscarUsuario(tecnicoId)!.nombre}',
            fecha.add(const Duration(hours: 2)),
            'Lucía Herrera',
          ),
        );
      }
      if (estado == Estado.resuelto) {
        r.eventos.add(
          Evento(
            'Estado: Resuelto',
            fecha.add(const Duration(days: 1)),
            buscarUsuario(tecnicoId)?.nombre ?? 'Sistema',
          ),
        );
      }
      _reportes.add(r);
      return r;
    }

    final maria = usuarios[0];
    final diego = usuarios[1];

    nuevo(Categoria.proyector, 'Edificio de Sistemas', 'Aula 204',
        'El proyector no enciende. La luz indicadora parpadea en rojo.',
        atras(1, 3), maria, Estado.enRevision, Prioridad.alta,
        tecnicoId: 3, foto: true);
    nuevo(Categoria.foco, 'Eléctrica y Electrónica', 'Laboratorio 3',
        'Dos focos del fondo del laboratorio están quemados.',
        atras(2, 5), diego, Estado.pendiente, Prioridad.media);
    nuevo(Categoria.bano, 'Biblioteca Central', 'Baño piso 2',
        'Fuga de agua en el lavabo del medio.',
        atras(6), maria, Estado.resuelto, Prioridad.media, tecnicoId: 4);
    nuevo(Categoria.red, 'Edificio de Sistemas', 'Laboratorio de redes',
        'El wifi se cae cada pocos minutos durante las clases.',
        atras(0, 6), maria, Estado.pendiente, Prioridad.alta);
    nuevo(Categoria.computadora, 'Civil y Ambiental', 'Sala de cómputo 1',
        'Tres computadoras no inician sesión y una no tiene teclado.',
        atras(3, 2), diego, Estado.enRevision, Prioridad.media,
        tecnicoId: 4);
    nuevo(Categoria.mobiliario, 'Mecánica', 'Aula 105',
        'Cuatro pupitres con la paleta suelta, riesgo de caída.',
        atras(4), diego, Estado.pendiente, Prioridad.baja);
    nuevo(Categoria.proyector, 'Química y Agroindustria', 'Aula 301',
        'La imagen del proyector se ve amarilla y borrosa.',
        atras(8), maria, Estado.resuelto, Prioridad.baja, tecnicoId: 3);
    nuevo(Categoria.foco, 'Aula Magna', 'Escenario',
        'Se apagaron las luces del lado derecho del escenario.',
        atras(1, 20), diego, Estado.enRevision, Prioridad.alta, tecnicoId: 3);
    nuevo(Categoria.bano, 'Geología y Petróleos', 'Baño piso 1',
        'No hay agua en los lavabos desde la mañana.',
        atras(0, 2), maria, Estado.pendiente, Prioridad.alta);
    nuevo(Categoria.otro, 'Biblioteca Central', 'Sala de lectura',
        'El aire acondicionado hace un ruido fuerte al encender.',
        atras(5), diego, Estado.resuelto, Prioridad.baja, tecnicoId: 4);

    _reportes[0].comentarios.addAll([
      Comentario('Carlos Andrade', Rol.tecnico,
          'Revisé el cable de poder, parece ser la lámpara. Pido repuesto.',
          atras(0, 20)),
      Comentario('María Fernanda Pazmiño', Rol.estudiante,
          'Gracias, mañana tenemos clase a las 8:00 en esa aula.',
          atras(0, 18)),
    ]);

    void nota(Rol rol, String t, String m, DateTime f,
        {int? uid, int? rid, bool leida = false}) {
      _notificaciones.add(
        Notificacion(
          id: _siguienteNotificacion++,
          titulo: t,
          mensaje: m,
          fecha: f,
          rol: rol,
          usuarioId: uid,
          reporteId: rid,
          leida: leida,
        ),
      );
    }

    nota(Rol.estudiante, 'Tu reporte #1 está en revisión',
        'Carlos Andrade ya está atendiendo tu reporte', atras(1),
        uid: 1, rid: 1);
    nota(Rol.estudiante, 'Tu reporte #3 fue resuelto',
        'Baños · Biblioteca Central · Baño piso 2', atras(5),
        uid: 1, rid: 3, leida: true);
    nota(Rol.estudiante, 'Bienvenida a EPN Reporta',
        'Reporta daños en aulas y laboratorios en pocos pasos.', atras(10),
        uid: 1, leida: true);
    nota(Rol.tecnico, 'Te asignaron el reporte #8',
        'Iluminación en Aula Magna · Escenario', atras(1, 18),
        uid: 3, rid: 8);
    nota(Rol.tecnico, 'Nuevo reporte #9',
        'Baños en Geología y Petróleos · Baño piso 1', atras(0, 2), rid: 9);
    nota(Rol.admin, 'Nuevo reporte #4',
        'Internet / Red en Edificio de Sistemas', atras(0, 6), rid: 4);
    nota(Rol.admin, 'Reporte #8 con prioridad alta sin resolver',
        'Lleva más de 24 horas en revisión', atras(0, 3), rid: 8);
  }
}
