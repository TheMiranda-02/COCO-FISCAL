import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FormularioTarea extends StatefulWidget {
  final Map<String, dynamic>? tarea;
  const FormularioTarea({this.tarea});
  @override
  _FormularioTareaState createState() => _FormularioTareaState();
}

class _FormularioTareaState extends State<FormularioTarea> {
  final tituloCtrl = TextEditingController();
  final notaCtrl = TextEditingController();

  List<String> subtareas = [];
  List<bool> subtareasEstado = [];
  List<Map<String, dynamic>> subtareasCargadas = [];
  final List<String> categoriasDisponibles = [
    'Obligaciones fiscales',
    'Finanzas personales',
    'Emprendimiento',
    'Seguridad social',
    'Multas y avisos',
  ];

  String categoria = '';
  DateTime? fecha;
  TimeOfDay? hora;
  TimeOfDay? recordatorio;
  File? archivoAdjunto;

  void agregarSubtarea() {
    subtareas.add('');
    subtareasEstado.add(false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.tarea != null) {
      tituloCtrl.text = widget.tarea!['titulo'] ?? '';
      categoria = widget.tarea!['categoria'] ?? '';
      notaCtrl.text = widget.tarea!['nota'] ?? '';

      // Fecha
      if (widget.tarea!['fecha_vencimiento'] != null &&
          widget.tarea!['fecha_vencimiento'].toString().isNotEmpty) {
        fecha = DateTime.tryParse(widget.tarea!['fecha_vencimiento']);
      }

      // Hora
      if (widget.tarea!['hora'] != null &&
          widget.tarea!['hora'].toString().isNotEmpty) {
        final parts = widget.tarea!['hora'].split(":");
        hora = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      // Recordatorio
      if (widget.tarea!['recordatorio'] != null &&
          widget.tarea!['recordatorio'].toString().isNotEmpty) {
        final parts = widget.tarea!['recordatorio'].split(":");
        recordatorio = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      // Archivo adjunto (solo si quieres mostrar el nombre, no puedes cargar el archivo directamente)
      if (widget.tarea!['adjunto_path'] != null &&
          widget.tarea!['adjunto_path'].toString().isNotEmpty) {}

      // Subtareas cargadas
      ApiService.getSubtareas(widget.tarea!['id']).then((lista) {
        setState(() {
          subtareasCargadas = lista.cast<Map<String, dynamic>>();
        });
      });
    }
  }

  Future<void> seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      archivoAdjunto = File(result.files.single.path!);
      setState(() {});
    }
  }

  Future<String?> subirArchivo(File archivo) async {
    var uri = Uri.parse("http://192.168.100.8/api_coco/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    var json = jsonDecode(respStr);
    return json['path'];
  }

  Future<void> guardarTarea() async {
    String? adjuntoPath;
    if (archivoAdjunto != null) {
      adjuntoPath = await subirArchivo(archivoAdjunto!);
    }
    if (widget.tarea != null) {
      final tareaActualizada = {
        'id': widget.tarea!['id'].toString(),
        'titulo': tituloCtrl.text,
        "categoria": categoria,
        'fecha_vencimiento': fecha != null
            ? DateFormat('yyyy-MM-dd').format(fecha!)
            : '',
        'hora': hora != null ? "${hora!.hour}:${hora!.minute}" : '',
        'recordatorio': recordatorio != null
            ? "${recordatorio!.hour}:${recordatorio!.minute}"
            : '',
        'nota': notaCtrl.text,
        'adjunto_path':
            archivoAdjunto?.path ?? widget.tarea!['adjunto_path'] ?? '',
        'completado': widget.tarea!['completado'].toString(),
      };

      await http.put(
        Uri.parse("http://192.168.100.8/api_coco/tareas.php"),
        body: tareaActualizada,
      );
      await http.post(
        Uri.parse("http://192.168.100.8/api_coco/actualizar_campos_tarea.php"),
        body: jsonEncode({
          'id': widget.tarea!['id'].toString(),
          'titulo': tituloCtrl.text,
          'categoria': categoria,
          'fecha_vencimiento': fecha != null
              ? DateFormat('yyyy-MM-dd').format(fecha!)
              : '',
          'hora': hora != null ? "${hora!.hour}:${hora!.minute}" : '',
          'recordatorio': recordatorio != null
              ? "${recordatorio!.hour}:${recordatorio!.minute}"
              : '',
          'nota': notaCtrl.text,
          'adjunto_path':
              archivoAdjunto?.path ?? widget.tarea!['adjunto_path'] ?? '',
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Agregar nuevas subtareas si se está editando
      for (int i = 0; i < subtareas.length; i++) {
        if (subtareas[i].trim().isNotEmpty) {
          await http.post(
            Uri.parse("http://192.168.100.8/api_coco/subtareas.php"),
            body: jsonEncode({
              "tarea_id": widget.tarea!['id'],
              "titulo": subtareas[i],
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }

      Navigator.pop(context);
    } else {
      // POST como ya lo tienes

      final tarea = {
        "titulo": tituloCtrl.text,
        "categoria": categoria,
        "fecha_vencimiento": fecha != null
            ? DateFormat('yyyy-MM-dd').format(fecha!)
            : '',
        "hora": hora != null ? "${hora!.hour}:${hora!.minute}" : '',
        "recordatorio": recordatorio != null
            ? "${recordatorio!.hour}:${recordatorio!.minute}"
            : '',
        "nota": notaCtrl.text,
        "adjunto_path": adjuntoPath ?? '',
      };

      final res = await http.post(
        Uri.parse("http://192.168.100.8/api_coco/tareas.php"),
        body: jsonEncode(tarea),
        headers: {'Content-Type': 'application/json'},
      );

      String? id; // 🔹 Declaración fuera del try

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        try {
          final data = jsonDecode(res.body);
          if (data is Map && data.containsKey('id')) {
            id = data['id'].toString(); // 🔹 Asignación segura
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Respuesta inesperada del servidor")),
            );
            return; // detener flujo
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al procesar respuesta del servidor")),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al guardar tarea")));
        return;
      }

      // 🔹 Ahora id existe y puedes usarlo
      if (id != null) {
        for (int i = 0; i < subtareas.length; i++) {
          await http.post(
            Uri.parse("http://192.168.100.8/api_coco/subtareas.php"),
            body: jsonEncode({"tarea_id": id, "titulo": subtareas[i]}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }

      Navigator.pop(context);
    }
  }

  void mostrarSelectorFecha() {
    DateTime? fechaTemp = fecha ?? DateTime.now();
    Key calendarKey = UniqueKey();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 12),
                  Text(
                    "Selecciona una fecha",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Color(0xFFC1E3CA), // color de selección
                        onPrimary: Colors.black, // texto sobre selección
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: CalendarDatePicker(
                      key: calendarKey,
                      initialDate: fechaTemp ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2030),
                      onDateChanged: (f) => setModalState(() => fechaTemp = f),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text("Sin cita"),
                        selected: fechaTemp == null,
                        onSelected: (_) => setModalState(() {
                          fechaTemp = null;
                          calendarKey = UniqueKey();
                        }),
                      ),
                      ChoiceChip(
                        label: Text("Hoy"),
                        selected:
                            fechaTemp != null &&
                            DateUtils.isSameDay(fechaTemp, DateTime.now()),
                        selectedColor: Color(0xFF6BB187),
                        onSelected: (_) => setModalState(() {
                          fechaTemp = DateTime.now();
                          calendarKey = UniqueKey();
                        }),
                      ),
                      ChoiceChip(
                        label: Text("Mañana"),
                        selected:
                            fechaTemp != null &&
                            DateUtils.isSameDay(
                              fechaTemp,
                              DateTime.now().add(Duration(days: 1)),
                            ),
                        selectedColor: Color(0xFF6BB187),
                        onSelected: (_) => setModalState(() {
                          fechaTemp = DateTime.now().add(Duration(days: 1));
                          calendarKey = UniqueKey();
                        }),
                      ),
                      ChoiceChip(
                        label: Text("3 días después"),
                        selected:
                            fechaTemp != null &&
                            DateUtils.isSameDay(
                              fechaTemp,
                              DateTime.now().add(Duration(days: 3)),
                            ),
                        selectedColor: Color(0xFF6BB187),
                        onSelected: (_) => setModalState(() {
                          fechaTemp = DateTime.now().add(Duration(days: 3));
                          calendarKey = UniqueKey();
                        }),
                      ),
                      ChoiceChip(
                        label: Text("Este domingo"),
                        selected:
                            fechaTemp != null &&
                            DateUtils.isSameDay(
                              fechaTemp,
                              DateTime.now().add(
                                Duration(
                                  days: (7 - DateTime.now().weekday) % 7,
                                ),
                              ),
                            ),
                        selectedColor: Color(0xFF6BB187),
                        onSelected: (_) {
                          final hoy = DateTime.now();
                          final domingo = hoy.add(
                            Duration(days: (7 - hoy.weekday) % 7),
                          );
                          setModalState(() {
                            fechaTemp = domingo;
                            calendarKey = UniqueKey();
                          });
                        },
                      ),
                    ],
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Aceptar"),
                    onPressed: () {
                      setState(() => fecha = fechaTemp);
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void mostrarSelectorHora({required bool esRecordatorio}) {
    TimeOfDay? horaTemp = esRecordatorio ? recordatorio : hora;
    Key relojKey = UniqueKey();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 12),
                  Text(
                    esRecordatorio
                        ? "Selecciona hora de recordatorio"
                        : "Selecciona hora de tarea",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text("Sin hora"),
                        selected: horaTemp == null,
                        selectedColor: Color(0xFF6BB187),
                        onSelected: (_) => setModalState(() {
                          horaTemp = null;
                          relojKey = UniqueKey();
                        }),
                      ),
                      ...["7:00", "9:00", "10:00", "12:00", "14:00"].map((h) {
                        final parts = h.split(":");
                        final hour = int.parse(parts[0]);
                        final t = TimeOfDay(hour: hour, minute: 0);
                        return ChoiceChip(
                          label: Text("$h ${hour < 12 ? 'a.m' : 'p.m'}"),
                          selected:
                              horaTemp?.hour == t.hour &&
                              horaTemp?.minute == t.minute,
                          selectedColor: Color(0xFF6BB187),
                          onSelected: (_) => setModalState(() {
                            horaTemp = t;
                            relojKey = UniqueKey(); // fuerza reconstrucción
                          }),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        key: relojKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6BB187),
                          foregroundColor: Colors.black,
                        ),
                        child: Text("Ajustar manualmente"),
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: horaTemp ?? TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFFC1E3CA),
                                    onPrimary: Colors.black,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (t != null) setModalState(() => horaTemp = t);
                        },
                      );
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Aceptar"),
                    onPressed: () {
                      setState(() {
                        if (esRecordatorio)
                          recordatorio = horaTemp;
                        else
                          hora = horaTemp;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildFechaSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Fecha de vencimiento"),
        Text(
          fecha != null
              ? DateFormat('yyyy-MM-dd').format(fecha!)
              : "Sin cita seleccionada",
        ),
        TextButton(
          child: Text("Elegir en calendario"),
          onPressed: mostrarSelectorFecha,
        ),
      ],
    );
  }

  Widget buildHoraSelector(String label, bool esRecordatorio) {
    final valor = esRecordatorio ? recordatorio : hora;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(
          valor != null
              ? "${valor.hour}:${valor.minute.toString().padLeft(2, '0')}"
              : "Sin hora seleccionada",
        ),
        TextButton(
          child: Text("Elegir en reloj"),
          onPressed: () => mostrarSelectorHora(esRecordatorio: esRecordatorio),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFEFC),
      appBar: AppBar(title: Text("Nueva tarea")),
      body: Container(
        color: Color(0xFFFCFEFC),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              TextField(
                controller: tituloCtrl,
                decoration: InputDecoration(
                  labelText: "Título",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 🔽 Categoría
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  value: categoria.isNotEmpty ? categoria : null,
                  items: categoriasDisponibles.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (valor) => setState(() => categoria = valor!),
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 🔽 Subtareas + botón
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtareas",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFDCF1DE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.add, color: Colors.black),
                    label: Text(
                      "Agregar",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: agregarSubtarea,
                  ),
                ],
              ),
              ...List.generate(subtareas.length, (i) {
                return Row(
                  children: [
                    Checkbox(
                      value: subtareasEstado[i],
                      onChanged: (val) =>
                          setState(() => subtareasEstado[i] = val!),
                      shape: CircleBorder(),
                      activeColor: Color(0xFF6BB187),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => subtareas[i] = val,
                        decoration: InputDecoration(
                          hintText: "Subtarea ${i + 1}",
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 12),
              Divider(color: Colors.grey.shade300, thickness: 0.8),

              // 🔽 Fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fecha de vencimiento",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: Text(
                      "Elegir",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: mostrarSelectorFecha,
                  ),
                ],
              ),
              Text(
                fecha != null
                    ? DateFormat('yyyy-MM-dd').format(fecha!)
                    : "Sin cita seleccionada",
              ),
              SizedBox(height: 12),
              Divider(color: Colors.grey.shade300, thickness: 0.8),

              // 🔽 Hora
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hora de tarea",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: Text(
                      "Elegir",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => mostrarSelectorHora(esRecordatorio: false),
                  ),
                ],
              ),
              Text(
                hora != null
                    ? "${hora!.hour}:${hora!.minute.toString().padLeft(2, '0')}"
                    : "Sin hora seleccionada",
              ),
              SizedBox(height: 12),
              Divider(color: Colors.grey.shade300, thickness: 0.8),

              // 🔽 Recordatorio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recordatorio",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: Text(
                      "Elegir",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => mostrarSelectorHora(esRecordatorio: true),
                  ),
                ],
              ),
              Text(
                recordatorio != null
                    ? "${recordatorio!.hour}:${recordatorio!.minute.toString().padLeft(2, '0')}"
                    : "Sin recordatorio seleccionado",
              ),
              Divider(color: Colors.grey.shade300, thickness: 0.8),
              SizedBox(height: 12),

              // 🔽 Nota
              TextField(
                controller: notaCtrl,
                decoration: InputDecoration(labelText: "Nota"),
              ),
              SizedBox(height: 20),

              // 🔽 Archivo adjunto
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Archivo adjunto",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.attach_file, color: Colors.black),
                    label: Text(
                      "Seleccionar",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: seleccionarArchivo,
                  ),
                ],
              ),
              if (archivoAdjunto != null) ...[
                Text("Archivo nuevo: ${archivoAdjunto!.path.split('/').last}"),
              ] else if (widget.tarea?['adjunto_path'] != null &&
                  widget.tarea!['adjunto_path'].toString().isNotEmpty) ...[
                Text(
                  "Archivo existente: ${widget.tarea!['adjunto_path'].split('/').last}",
                ),
              ] else ...[
                Text("Ningún archivo adjunto"),
              ],
              SizedBox(height: 30),

              // 🔽 Subtareas cargadas (modo edición)
              if (widget.tarea != null && subtareasCargadas.isNotEmpty) ...[
                Divider(),
                Text("Subtareas existentes"),
                ...subtareasCargadas.map((sub) {
                  return Row(
                    children: [
                      Checkbox(
                        value: sub['completado'] == 1,
                        onChanged: (val) async {
                          await ApiService.actualizarEstadoSubtarea(
                            sub['id'],
                            val!,
                          );
                          final lista = await ApiService.getSubtareas(
                            widget.tarea!['id'],
                          );
                          setState(
                            () => subtareasCargadas = lista
                                .cast<Map<String, dynamic>>(),
                          );
                        },
                        shape: CircleBorder(),
                        activeColor: Color(0xFF6BB187),
                      ),
                      Expanded(
                        child: Text(
                          sub['titulo'],
                          style: TextStyle(
                            decoration: sub['completado'] == 1
                                ? TextDecoration.lineThrough
                                : null,
                            color: sub['completado'] == 1
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],

              // 🔽 Botón guardar
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6BB187),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Guardar pendiente",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: guardarTarea,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
