import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventForm extends StatefulWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> eventos;
  final Map<String, dynamic>? eventoExistente; // 👈 nuevo
  final void Function(Map<String, dynamic> evento)? onEventoGuardado;

  EventForm({
    required this.selectedDate,
    this.eventos = const [],
    this.eventoExistente, // 👈 nuevo
    this.onEventoGuardado,
  });

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaCierre;
  int _recordatorioMin = 5;
  String _categoriaSeleccionada = "Obligaciones fiscales";

  final List<Map<String, dynamic>> categorias = [
    {
      "nombre": "Obligaciones fiscales",
      "etiqueta": "Obligaciones fiscales",
      "color": Colors.blue,
      "icono": Icons.description,
    },
    {
      "nombre": "Finanzas personales",
      "etiqueta": "Finanzas personales",
      "color": Colors.green,
      "icono": Icons.attach_money,
    },
    {
      "nombre": "Emprendimiento",
      "etiqueta": "Emprendimiento",
      "color": Colors.orange,
      "icono": Icons.business_center,
    },
    {
      "nombre": "Seguridad social",
      "etiqueta": "Seguridad social",
      "color": Colors.purple,
      "icono": Icons.health_and_safety,
    },
    {
      "nombre": "Multas y avisos",
      "etiqueta": "Multas y avisos",
      "color": Colors.red,
      "icono": Icons.warning,
    },
  ];
  @override
  void initState() {
    super.initState();

    final evento = widget.eventoExistente;
    if (evento != null) {
      _tituloController.text = evento['titulo'] ?? '';
      _descripcionController.text = evento['descripcion'] ?? '';
      _recordatorioMin = int.tryParse(evento['recordatorio'] ?? '5') ?? 5;
      _categoriaSeleccionada = evento['categoria'] ?? _categoriaSeleccionada;

      final horaInicioParts = (evento['hora_inicio'] as String).split(':');
      final horaCierreParts = (evento['hora_cierre'] as String).split(':');

      _horaInicio = TimeOfDay(
        hour: int.parse(horaInicioParts[0]),
        minute: int.parse(horaInicioParts[1]),
      );
      _horaCierre = TimeOfDay(
        hour: int.parse(horaCierreParts[0]),
        minute: int.parse(horaCierreParts[1]),
      );
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  Future<void> seleccionarHora(bool esInicio) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (esInicio) {
          _horaInicio = picked;
        } else {
          _horaCierre = picked;
        }
      });
    }
  }

  Future<void> guardarEvento() async {
    if (_horaInicio == null || _horaCierre == null) return;

    final evento = {
      "titulo": _tituloController.text,
      "fecha": widget.selectedDate.toIso8601String().split("T")[0],
      "hora_inicio": formatTimeOfDay(_horaInicio!),
      "hora_cierre": formatTimeOfDay(_horaCierre!),
      "recordatorio": _recordatorioMin.toString(),
      "descripcion": _descripcionController.text,
      "categoria": _categoriaSeleccionada,
    };

    final esEdicion = widget.eventoExistente != null;
    if (esEdicion) {
      evento["id"] = widget.eventoExistente!["id"];
    }

    final url = Uri.parse(
      esEdicion
          ? "http://192.168.100.8/api_coco/update_event.php"
          : "http://192.168.100.8/api_coco/insert_event.php",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(evento),
    );

    if (response.statusCode == 200) {
      if (widget.onEventoGuardado != null) {
        widget.onEventoGuardado!(evento);
      }
      Navigator.pop(context);
    } else {
      print("Error al guardar: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordatorioOpciones = List.generate(12, (i) => (i + 1) * 5);
    final eventosAgrupados = <String, List<Map<String, dynamic>>>{};
    for (var evento in widget.eventos) {
      final fecha = evento['fecha'];
      eventosAgrupados.putIfAbsent(fecha, () => []).add(evento);
    }

    return Container(
      color: Color(0xFFE6F4EC), // Fondo del formulario
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40),
                Text(
                  widget.eventoExistente != null
                      ? "Editar Evento"
                      : "Nuevo Evento",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () =>
                      Navigator.pop(context), // 👈 CIERRA EL FORMULARIO
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: "Título",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6BB187), width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6BB187), width: 3),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            Text(
              "Fecha seleccionada: ${widget.selectedDate.toLocal().toString().split(' ')[0]}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            Text(
              "Hora de Inicio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () => seleccionarHora(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA2D3B5),
              ),
              child: Text(
                _horaInicio == null
                    ? "Seleccionar hora de inicio"
                    : "Inicio: ${_horaInicio!.format(context)}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Hora de Cierre",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () => seleccionarHora(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA2D3B5),
              ),
              child: Text(
                _horaCierre == null
                    ? "Seleccionar hora de cierre"
                    : "Cierre: ${_horaCierre!.format(context)}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Recordatorio:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12), // 👈 separa ligeramente del combo
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFA2D3B5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: _recordatorioMin,
                    underline: SizedBox(),
                    dropdownColor: Color(0xFFA2D3B5),
                    items: recordatorioOpciones
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _recordatorioMin = val!),
                  ),
                ),
                SizedBox(width: 8), // separa ligeramente del texto “minutos”
                Text("minutos", style: TextStyle(color: Colors.black)),
              ],
            ),

            SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6BB187), width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6BB187), width: 3),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            Text(
              "Selecciona una categoría",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categorias.map((cat) {
                final bool seleccionada =
                    _categoriaSeleccionada == cat["nombre"];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _categoriaSeleccionada = cat["nombre"]),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: seleccionada ? cat["color"] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cat["color"]),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat["icono"],
                          size: 18,
                          color: seleccionada ? Colors.white : cat["color"],
                        ),
                        SizedBox(width: 6),
                        Text(
                          cat["etiqueta"],
                          style: TextStyle(
                            color: seleccionada ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: guardarEvento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6BB187),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.eventoExistente != null
                        ? "Guardar cambios"
                        : "Crear nuevo evento",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (widget.eventos.isNotEmpty)
              ...eventosAgrupados.entries.map((entry) {
                final fecha = entry.key;
                final eventos = entry.value;
                final dia = fecha.split('-')[2];

                // Ordenar eventos por hora
                final eventosOrdenados = [...eventos];
                eventosOrdenados.sort((a, b) {
                  final horaA = a['hora_inicio'].split(':');
                  final horaB = b['hora_inicio'].split(':');
                  final minutosA =
                      int.parse(horaA[0]) * 60 + int.parse(horaA[1]);
                  final minutosB =
                      int.parse(horaB[0]) * 60 + int.parse(horaB[1]);
                  return minutosA.compareTo(minutosB);
                });

                return Stack(
                  children: [
                    // Gusano verde detrás
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF6BB187).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF6BB187),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                dia,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              "Eventos del día",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...eventosOrdenados.map((e) {
                          final horaInicio = e['hora_inicio'];
                          final horaFormateada = TimeOfDay(
                            hour: int.parse(horaInicio.split(':')[0]),
                            minute: int.parse(horaInicio.split(':')[1]),
                          ).format(context);

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 60,
                              bottom: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  horaFormateada,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  e['titulo'],
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  e['categoria'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
