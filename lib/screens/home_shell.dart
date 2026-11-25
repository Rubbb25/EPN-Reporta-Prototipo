import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import 'bandeja_tecnico_page.dart';
import 'inicio_estudiante_page.dart';
import 'lista_reportes_page.dart';
import 'mapa_page.dart';
import 'notificaciones_screen.dart';
import 'nuevo_reporte_screen.dart';
import 'panel_admin_page.dart';
import 'perfil_page.dart';
import 'usuarios_page.dart';

class _Destino {
  const _Destino(this.titulo, this.icono, this.iconoActivo, this.pagina);

  final String titulo;
  final IconData icono;
  final IconData iconoActivo;
  final Widget pagina;
}

/// Contenedor principal: cambia el menú inferior según el perfil.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  List<_Destino> _destinos(Rol rol) {
    switch (rol) {
      case Rol.estudiante:
        return const [
          _Destino('Inicio', Icons.home_outlined, Icons.home,
              InicioEstudiantePage()),
          _Destino('Mis reportes', Icons.list_alt_outlined, Icons.list_alt,
              ListaReportesPage(soloMios: true)),
          _Destino('Mapa', Icons.map_outlined, Icons.map, MapaPage()),
          _Destino('Perfil', Icons.person_outline, Icons.person, PerfilPage()),
        ];
      case Rol.tecnico:
        return const [
          _Destino('Bandeja', Icons.inbox_outlined, Icons.inbox,
              BandejaTecnicoPage()),
          _Destino('Mapa', Icons.map_outlined, Icons.map, MapaPage()),
          _Destino('Perfil', Icons.person_outline, Icons.person, PerfilPage()),
        ];
      case Rol.admin:
        return const [
          _Destino('Panel', Icons.dashboard_outlined, Icons.dashboard,
              PanelAdminPage()),
          _Destino('Reportes', Icons.list_alt_outlined, Icons.list_alt,
              ListaReportesPage(soloMios: false)),
          _Destino('Usuarios', Icons.group_outlined, Icons.group,
              UsuariosPage()),
          _Destino('Perfil', Icons.person_outline, Icons.person, PerfilPage()),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final usuario = estado.usuario;
    if (usuario == null) return const SizedBox.shrink();

    final destinos = _destinos(usuario.rol);
    final indice = _indice >= destinos.length ? 0 : _indice;
    final actual = destinos[indice];
    final noLeidas = estado.noLeidas;
    final puedeCrear =
        usuario.rol == Rol.estudiante && indice <= 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(actual.titulo),
        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            icon: Badge(
              isLabelVisible: noLeidas > 0,
              label: Text('$noLeidas'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificacionesScreen()),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: indice,
        children: [for (final d in destinos) d.pagina],
      ),
      floatingActionButton: puedeCrear
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NuevoReporteScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Reportar daño'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: [
          for (final d in destinos)
            NavigationDestination(
              icon: Icon(d.icono),
              selectedIcon: Icon(d.iconoActivo),
              label: d.titulo,
            ),
        ],
      ),
    );
  }
}
