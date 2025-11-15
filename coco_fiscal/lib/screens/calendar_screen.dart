import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/event_form.dart';
import '../Estilos/diseños_calendario.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Map<String, dynamic>> proximosEventos = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedTab = 0; // índice para que Calendar esté activo

  Map<DateTime, List<Map<String, dynamic>>> eventosPorFecha = {};

  final List<Map<String, dynamic>> categorias = [
    {"nombre": "Obligaciones fiscales", "color": Colors.blue},
    {"nombre": "Finanzas personales", "color": Colors.green},
    {"nombre": "Emprendimiento", "color": Colors.orange},
    {"nombre": "Seguridad social", "color": Colors.purple},
    {"nombre": "Multas y avisos", "color": Colors.red},
  ];
  @override
  void initState() {
    super.initState();

    // 1) cargar todos los eventos para llenar eventosPorFecha
    obtenerTodosLosEventos().then((_) async {
      // 2) luego obtener la lista de próximos eventos y guardarla
      final eventos = await obtenerProximosEventos();
      setState(() {
        proximosEventos = eventos;
      });
    });
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

  Future<void> obtenerEventosDelDia(DateTime fecha) async {
    final fechaStr = fecha.toIso8601String().split("T")[0];
    final url = Uri.parse(
      "http://192.168.100.8/api_coco/get_events.php?fecha=$fechaStr",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final eventos = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
      setState(() {
        eventosPorFecha[fecha] = eventos;
      });
    } else {
      print("Error al obtener eventos: ${response.body}");
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    await obtenerEventosDelDia(selectedDay);

    final eventos = eventosPorFecha[selectedDay] ?? [];

    showModalBottomSheet(
      context: context,
      builder: (_) => EventForm(
        selectedDate: selectedDay,
        eventos: eventos,
        onEventoGuardado: (eventoNuevo) async {
          setState(() {
            final fecha = selectedDay;
            final lista = eventosPorFecha[fecha] ?? [];
            lista.add(eventoNuevo);
            eventosPorFecha[fecha] = lista;
          });

          // 🔄 Actualiza la lista de próximos eventos
          final nuevosEventos = await obtenerProximosEventos();
          setState(() {
            proximosEventos = nuevosEventos;
          });
        },
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarioDesigns.buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Encabezado/Calendario personalizado ---
            Column(
              children: [
                // Encabezado con mes en mayúsculas y flechas
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flecha izquierda funcional: resta un mes
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month - 1,
                              1,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFCCE5CC),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Color(0xFF2E8B57),
                            size: 26,
                          ),
                        ),
                      ),

                      // Nombre del mes en mayúsculas y color verde
                      Text(
                        _mesEnMayusculas(_focusedDay),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E8B57),
                          letterSpacing: 1.2,
                        ),
                      ),

                      // Flecha derecha funcional: suma un mes
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month + 1,
                              1,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFCCE5CC),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF2E8B57),
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Calendario centrado y con sombra
                Center(
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.86, // hacer el calendario un poco más pequeño
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: _onDaySelected,
                        onPageChanged: (newFocused) {
                          // sincroniza cuando el usuario desliza el mes
                          setState(() {
                            _focusedDay = newFocused;
                          });
                        },
                        eventLoader: (day) {
                          final fecha = DateTime.utc(
                            day.year,
                            day.month,
                            day.day,
                          );
                          return eventosPorFecha[fecha] ?? [];
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, _) {
                            final eventos =
                                eventosPorFecha[DateTime.utc(
                                  date.year,
                                  date.month,
                                  date.day,
                                )] ??
                                [];
                            if (eventos.isEmpty) return null;

                            final ultimaCategoria =
                                (eventos.last
                                        as Map<String, dynamic>?)?['categoria']
                                    as String?;
                            final color =
                                categorias.firstWhere(
                                      (c) => c['nombre'] == ultimaCategoria,
                                      orElse: () => {"color": Colors.grey},
                                    )['color']
                                    as Color;

                            return Container(
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${date.day}',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Color(0xFFB7E4C7),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFF2E8B57),
                            shape: BoxShape.circle,
                          ),
                          outsideDaysVisible: false,
                        ),
                        headerVisible:
                            false, // ocultamos header interno (usamos el personalizado)
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            buildProximosEventos(),
          ],
        ),
      ),
      bottomNavigationBar: CalendarioDesigns.buildBottomNavigationBar(
        currentIndex: _selectedTab,
        onTabTapped: _onTabTapped,
      ),
    );
  }

  Widget slideAction(
    Color color,
    IconData icon,
    String label,
    Alignment align,
  ) {
    return Container(
      color: color,
      alignment: align,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildProximosEventos() {
    if (proximosEventos.isEmpty) {
      return Text("No hay eventos próximos.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Eventos Próximos",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8),
        ...proximosEventos.map((evento) {
          final fecha = evento['fecha'];
          // hora_inicio puede venir "HH:MM:SS" o "HH:MM", normalizamos:
          String horaRaw = evento['hora_inicio'] ?? '';
          final horaParts = horaRaw.split(':');
          String horaMin = (horaParts.length >= 2)
              ? '${horaParts[0]}:${horaParts[1]}'
              : horaRaw;

          // convertir a DateTime para calcular AM/PM y tiempo restante
          final fechaHora = DateTime.parse("${evento['fecha']} ${horaMin}:00");
          final ahora = DateTime.now();
          final duracion = fechaHora.difference(ahora);
          final horas = duracion.inHours;
          final minutos = duracion.inMinutes.remainder(60);

          final titulo = evento['titulo'] ?? '';
          final categoria = evento['categoria'];
          final color =
              categorias.firstWhere(
                    (c) => c['nombre'] == categoria,
                    orElse: () => {"color": Colors.grey},
                  )['color']
                  as Color;

          // AM/PM
          final ampm = fechaHora.hour >= 12 ? 'PM' : 'AM';
          final horaDisplay =
              "${(fechaHora.hour % 12 == 0) ? 12 : (fechaHora.hour % 12)}:${fechaHora.minute.toString().padLeft(2, '0')} $ampm";

          return Dismissible(
            key: Key(evento['id'].toString()),
            background: slideAction(
              color,
              Icons.edit,
              "Editar",
              Alignment.centerLeft,
            ),
            secondaryBackground: slideAction(
              Colors.red,
              Icons.delete,
              "Eliminar",
              Alignment.centerRight,
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                editarEvento(evento);
                return false;
              } else {
                final confirmado = await confirmarEliminacion(context);
                if (confirmado) {
                  await eliminarEvento(evento['id'].toString());
                  return true;
                }
                return false;
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E8B57),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$fecha • $horaDisplay",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${horas > 0 ? '$horas h ' : ''}${minutos} min",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> obtenerProximosEventos() async {
    final url = Uri.parse(
      "http://192.168.100.8/api_coco/get_upcoming_events.php",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      print("Error al obtener próximos eventos: ${response.body}");
      return [];
    }
  }

  Future<void> obtenerTodosLosEventos() async {
    final url = Uri.parse("http://192.168.100.8/api_coco/get_all_events.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final eventos = List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );

      final agrupados = <DateTime, List<Map<String, dynamic>>>{};
      for (var evento in eventos) {
        final fechaStr = evento['fecha'];
        final partes = fechaStr.split('-');
        final fecha = DateTime.utc(
          int.parse(partes[0]),
          int.parse(partes[1]),
          int.parse(partes[2]),
        );

        if (!agrupados.containsKey(fecha)) {
          agrupados[fecha] = [];
        }
        agrupados[fecha]!.add(evento);
      }

      setState(() {
        eventosPorFecha = agrupados;
      });
    } else {
      print("Error al obtener todos los eventos: ${response.body}");
    }
  }

  String _mesEnMayusculas(DateTime fecha) {
    const meses = [
      'ENERO',
      'FEBRERO',
      'MARZO',
      'ABRIL',
      'MAYO',
      'JUNIO',
      'JULIO',
      'AGOSTO',
      'SEPTIEMBRE',
      'OCTUBRE',
      'NOVIEMBRE',
      'DICIEMBRE',
    ];
    return meses[fecha.month - 1] + ' ' + fecha.year.toString();
  }

  Future<bool> confirmarEliminacion(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("¿Eliminar evento?"),
            content: Text("Esta acción no se puede deshacer."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text("Eliminar"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> eliminarEvento(String id) async {
    final url = Uri.parse(
      "http://192.168.100.8/api_coco/delete_event.php?id=$id",
    );
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final nuevosEventos = await obtenerProximosEventos();
      setState(() {
        proximosEventos = nuevosEventos;
      });
    } else {
      print("Error al eliminar: ${response.body}");
    }
  }

  void editarEvento(Map<String, dynamic> evento) {
    showModalBottomSheet(
      context: context,
      builder: (_) => EventForm(
        selectedDate: DateTime.parse(evento['fecha']),
        eventoExistente: evento,
        onEventoGuardado: (eventoEditado) async {
          final nuevosEventos = await obtenerProximosEventos();
          setState(() {
            proximosEventos = nuevosEventos;
          });
        },
      ),
      isScrollControlled: true,
    );
  }
}
