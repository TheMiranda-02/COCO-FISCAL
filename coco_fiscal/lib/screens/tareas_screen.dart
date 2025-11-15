import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/tarea_card.dart';
import 'package:coco_fiscal/screens/formulario_tarea.dart'; // agrega esta línea al inicio
import '../services/api_service.dart';
import '../Estilos/diseños_tareas.dart'; // o disenos_tareas.dart si lo guardaste sin tilde

class TareasScreen extends StatefulWidget {
  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final Map<String, Color> coloresCategoria = {
    'Obligaciones fiscales': Colors.blue,
    'Finanzas personales': Colors.green,
    'Emprendimiento': Colors.orange,
    'Seguridad social': Colors.purple,
    'Multas y avisos': Colors.red,
    'Todas': Color(0xFFC1E3CA), // color neutro para "Todas"
  };
  int _selectedTab = 1; // índice para que Tareas esté activo
  List tareasPendientes = [];
  List tareasCompletadas = [];
  List categorias = [];
  String categoriaSeleccionada = '';
  bool cargando = true;
  bool mostrarPendientes = true;
  bool mostrarCompletadas = true;

  @override
  void initState() {
    super.initState();
    cargarTareas();
  }

  Future<void> cambiarEstadoTareaYSubtareas(
    int tareaId,
    bool nuevoEstado,
  ) async {
    // Cambiar estado de la tarea principal
    await cambiarEstado(tareaId, nuevoEstado);

    // Obtener subtareas
    final subtareas = await ApiService.getSubtareas(tareaId);

    // Cambiar estado de cada subtarea
    for (var sub in subtareas) {
      await ApiService.actualizarEstadoSubtarea(sub['id'], nuevoEstado);
    }

    await cargarTareas();
  }

  Future<void> cargarTareas() async {
    setState(() => cargando = true);
    final pendientes = await obtenerTareas(completado: false);
    final completadas = await obtenerTareas(completado: true);
    final cats = [
      'Todas',
      ...pendientes.map((t) => t['categoria']).toSet().toList(),
    ];

    setState(() {
      tareasPendientes = pendientes;
      tareasCompletadas = completadas;
      categorias = cats;
      cargando = false;
    });
  }

  Future<List> obtenerTareas({required bool completado}) async {
    final categoriaParam = categoriaSeleccionada == 'Todas'
        ? ''
        : categoriaSeleccionada;
    final url = Uri.parse(
      'http://192.168.100.8/api_coco/tareas.php?completado=${completado ? 1 : 0}&categoria=$categoriaParam',
    );
    final res = await http.get(url);
    return jsonDecode(res.body);
  }

  Future<void> cambiarEstado(int id, bool nuevoEstado) async {
    final url = Uri.parse('http://192.168.100.8/api_coco/tareas.php');
    await http.put(
      url,
      body: {'id': '$id', 'completado': nuevoEstado ? '1' : '0'},
    );
    await cargarTareas();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/calendar');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/obligaciones');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/resumen');
    }
  }

  Widget buildCategoriaFiltro() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categorias.map((cat) {
          final activo = cat == categoriaSeleccionada;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                cat,
                style: TextStyle(
                  color: activo ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: activo,
              onSelected: (_) {
                setState(() => categoriaSeleccionada = cat);
                cargarTareas();
              },
              selectedColor: coloresCategoria[cat] ?? Colors.grey,
              backgroundColor:
                  coloresCategoria[cat]?.withOpacity(0.3) ?? Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildTareaItem(dynamic tarea) {
    return Dismissible(
      key: Key('tarea_${tarea['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("¿Eliminar tarea?"),
            content: Text("Esto también eliminará sus subtareas."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Eliminar"),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) async {
        final url = Uri.parse(
          "http://192.168.100.8/api_coco/tareas.php?id=${tarea['id']}",
        );
        await http.delete(url);
        await cargarTareas();
      },
      child: TareaCard(
        tarea: tarea as Map<String, dynamic>,
        onRefresh: cargarTareas,
        onToggleCompletado: () =>
            cambiarEstadoTareaYSubtareas(tarea['id'], tarea['completado'] == 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFEFC),
      appBar: TareasDesigns.buildAppBar(context),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Color(0xFFFCFEFC),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  buildCategoriaFiltro(),
                  Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        // 🔽 Encabezado de Pendientes con flecha
                        GestureDetector(
                          onTap: () => setState(
                            () => mostrarPendientes = !mostrarPendientes,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pendientes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  mostrarPendientes
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 🔽 Lista de pendientes
                        if (mostrarPendientes) ...[
                          ...tareasPendientes.map(buildTareaItem),
                        ],

                        // 🔽 Encabezado de Completadas con flecha
                        if (tareasCompletadas.isNotEmpty) ...[
                          GestureDetector(
                            onTap: () => setState(
                              () => mostrarCompletadas = !mostrarCompletadas,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Completadas hoy',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    mostrarCompletadas
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 🔽 Lista de completadas
                          if (mostrarCompletadas) ...[
                            ...tareasCompletadas.map(buildTareaItem),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/formulario_tarea',
          ).then((_) => cargarTareas());
        },
        backgroundColor: Color(0xFF6BB187),
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: TareasDesigns.buildBottomNavigationBar(
        currentIndex: _selectedTab,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
