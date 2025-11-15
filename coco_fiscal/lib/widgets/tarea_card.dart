import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/formulario_tarea.dart';

class TareaCard extends StatefulWidget {
  final Map<String, dynamic> tarea;
  final VoidCallback onRefresh;
  final VoidCallback? onToggleCompletado;

  const TareaCard({
    required this.tarea,
    required this.onRefresh,
    super.key,
    this.onToggleCompletado,
  });

  @override
  State<TareaCard> createState() => _TareaCardState();
}

class _TareaCardState extends State<TareaCard> {
  List subtareas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarSubtareas();
  }

  Future<void> cargarSubtareas() async {
    final lista = await ApiService.getSubtareas(widget.tarea['id']);
    setState(() {
      subtareas = lista;
      cargando = false;
    });
  }

  Future<void> cambiarEstadoTareaYSubtareas(bool nuevoEstado) async {
    await ApiService.actualizarEstadoTarea(widget.tarea['id'], nuevoEstado);

    for (var sub in subtareas) {
      await ApiService.actualizarEstadoSubtarea(sub['id'], nuevoEstado);
    }

    widget.onRefresh();
  }

  Future<void> cambiarEstadoSubtarea(int id, bool nuevoEstado) async {
    await ApiService.actualizarEstadoSubtarea(id, nuevoEstado);
    await cargarSubtareas();
  }

  @override
  Widget build(BuildContext context) {
    final tarea = widget.tarea;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FormularioTarea(tarea: widget.tarea),
          ),
        ).then((_) => widget.onRefresh());
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: tarea['completado'] == 1,
                    onChanged: (val) => cambiarEstadoTareaYSubtareas(val!),
                    shape: CircleBorder(),
                    activeColor: Color(0xFF6BB187),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tarea['titulo'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: tarea['completado'] == 1
                                ? TextDecoration.lineThrough
                                : null,
                            color: tarea['completado'] == 1
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        if (tarea['categoria'] != null &&
                            tarea['categoria'].toString().isNotEmpty)
                          Text(
                            tarea['categoria'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*if (!cargando && subtareas.isNotEmpty) ...[
              Divider(),
              Column(
                children: subtareas.map((sub) {
                  return Row(
                    children: [
                      Checkbox(
                        value: sub['completado'] == 1,
                        onChanged: (val) =>
                            cambiarEstadoSubtarea(sub['id'], val!),
                      ),
                      Expanded(child: Text(sub['titulo'])),
                    ],
                  );
                }).toList(),
              ),
            ],*/
