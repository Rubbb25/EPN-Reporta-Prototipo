import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/modelos.dart';
import '../widgets/componentes.dart';

/// Lista de reportes con búsqueda y filtros.
/// Estudiante: solo los suyos. Administrador: todos.
class ListaReportesPage extends StatefulWidget {
  const ListaReportesPage({super.key, required this.soloMios});

  final bool soloMios;

  @override
  State<ListaReportesPage> createState() => _ListaReportesPageState();
}

class _ListaReportesPageState extends State<ListaReportesPage> {
  final _busqueda = TextEditingController();
  Estado? _estado;
  Categoria? _categoria;

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  Widget _chip<T>(String texto, T? valor, T? actual, void Function(T?) cambiar) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: actual == valor,
        onSelected: (_) => setState(() => cambiar(valor)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<AppState>();
    final base = widget.soloMios ? estado.misReportes : estado.reportes.toList();
    final texto = _busqueda.text.trim().toLowerCase();

    final lista = base.where((r) {
      if (_estado != null && r.estado != _estado) return false;
      if (_categoria != null && r.categoria != _categoria) return false;
      if (texto.isEmpty) return true;
      return r.descripcion.toLowerCase().contains(texto) ||
          r.ubicacion.toLowerCase().contains(texto) ||
          r.categoria.nombre.toLowerCase().contains(texto) ||
          '#${r.id}' == texto;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            controller: _busqueda,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Buscar por aula, edificio o descripción',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: texto.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(_busqueda.clear),
                    ),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: [
              _chip<Estado>('Todos', null, _estado, (v) => _estado = v),
              for (final e in Estado.values)
                _chip<Estado>(e.nombre, e, _estado, (v) => _estado = v),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            children: [
              _chip<Categoria>('Toda categoría', null, _categoria,
                  (v) => _categoria = v),
              for (final c in Categoria.values)
                _chip<Categoria>(c.nombre, c, _categoria, (v) => _categoria = v),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${lista.length} reporte${lista.length == 1 ? '' : 's'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? const EstadoVacio('No hay reportes con esos filtros',
                  icono: Icons.search_off)
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: lista.length,
                  itemBuilder: (context, i) =>
                      TarjetaReporte(lista[i], mostrarAutor: !widget.soloMios),
                ),
        ),
      ],
    );
  }
}
