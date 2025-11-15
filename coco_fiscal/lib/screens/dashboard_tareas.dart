import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart' as pc;
import '../services/api_service.dart';
import '../models/resumen_tareas.dart';
import '../Estilos/diseños_dashboard.dart';

class DashboardTareas extends StatefulWidget {
  @override
  State<DashboardTareas> createState() => _DashboardTareasState();
}

class _DashboardTareasState extends State<DashboardTareas> {
  late DateTime inicio;
  late DateTime fin;
  ResumenTareas? resumen;
  bool _isLoading = true;
  int _selectedTab = 2; // índice para que Dashboard esté activo
  String? _error; // Para capturar errores específicos

  @override
  void initState() {
    super.initState();
    final hoy = DateTime.now();
    inicio = hoy.subtract(Duration(days: hoy.weekday % 7));
    fin = inicio.add(const Duration(days: 6));
    cargarResumen();
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
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> cargarResumen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final r = await ApiService.fetchResumen(inicio, fin);
      if (!mounted) return;
      setState(() {
        resumen = r;
        _isLoading = false;
      });
    } catch (e) {
      print("⚠️ Error cargando resumen: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar el resumen')),
      );
    }
  }

  void cambiarRango(int dias) {
    setState(() {
      inicio = inicio.add(Duration(days: dias));
      fin = fin.add(Duration(days: dias));
    });
    cargarResumen();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              ElevatedButton(
                onPressed: cargarResumen,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (resumen == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No se pudo cargar el resumen'),
              ElevatedButton(
                onPressed: cargarResumen,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: DashboardDesigns.buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔼 Fichas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFicha("Completadas", resumen!.completadas),
                _buildFicha("Pendientes", resumen!.pendientes),
              ],
            ),
            const SizedBox(height: 20),

            // 📊 Gráfica de barras
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: _buildBarChart())],
            ),
            const SizedBox(height: 20),

            // 🥧 Gráfica de pastel
            const Text("Categorías completadas este mes"),
            const SizedBox(height: 12),

            _buildPieChart(),
          ],
        ),
      ),
      bottomNavigationBar: DashboardDesigns.buildBottomNavigationBar(
        currentIndex: _selectedTab,
        onTabTapped: _onTabTapped,
      ),
    );
  }

  Widget _buildFicha(String tipo, int valor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFC7E3D2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              "$valor",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              "Obligaciones",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              tipo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    try {
      final dias = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

      final porDia = resumen?.porDia ?? List.filled(7, 0);
      final tieneDatos = porDia.any((v) => v > 0);

      final rawMax = tieneDatos
          ? porDia.reduce((a, b) => a > b ? a : b).toDouble()
          : 1.0;

      final double maxY = rawMax <= 0 ? 1.0 : rawMax;

      // 🔹 Intervalo dinámico (múltiplos)
      int intervalInt;
      if (maxY <= 2) {
        intervalInt = 1;
      } else if (maxY <= 6) {
        intervalInt = 2;
      } else if (maxY <= 12) {
        intervalInt = 3;
      } else if (maxY <= 20) {
        intervalInt = 4;
      } else {
        intervalInt = (maxY / 5).ceil();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF8F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                "Finalización de obligaciones diarias",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            // 📊 Gráfica o mensaje si no hay datos
            Expanded(
              child: tieneDatos
                  ? BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.black45, width: 1),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < dias.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      dias[index],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              interval: intervalInt.toDouble(),
                              getTitlesWidget: (value, meta) {
                                final int val = value.toInt();
                                if (val % intervalInt == 0) {
                                  return Text(
                                    val.toString(),
                                    style: const TextStyle(fontSize: 11),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        maxY: maxY + intervalInt.toDouble(),
                        barGroups: List.generate(7, (i) {
                          final cantidad = porDia[i].toDouble();
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: cantidad,
                                color: const Color(0xFF6BB187),
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No hay datos de obligaciones en este rango",
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ),
            ),

            // 🔽 Controles dentro del rectángulo (abajo)
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => cambiarRango(-7),
                  ),
                  Text(
                    "${DateFormat('dd/MM').format(inicio)} – ${DateFormat('dd/MM').format(fin)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => cambiarRango(7),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('🚨 Error en _buildBarChart: $e');
      print('Stack trace: $stackTrace');
      return Container(
        height: 200,
        child: Center(child: Text('Error al mostrar gráfica: ${e.toString()}')),
      );
    }
  }

  Widget _buildPieChart() {
    try {
      if (resumen == null ||
          resumen!.categorias == null ||
          resumen!.categorias.isEmpty) {
        return const Text("No hay tareas completadas en este rango.");
      }

      final dataMap = <String, double>{};
      final colorList = <Color>[];

      for (var cat in resumen!.categorias) {
        final categoria = cat['categoria']?.toString() ?? 'Sin categoría';
        final total = double.tryParse(cat['total']?.toString() ?? '0') ?? 0.0;
        dataMap[categoria] = total;

        // 🔹 Asignar color según categoría
        switch (categoria) {
          case "Obligaciones fiscales":
            colorList.add(Colors.blue);
            break;
          case "Finanzas personales":
            colorList.add(Colors.green);
            break;
          case "Emprendimiento":
            colorList.add(Colors.orange);
            break;
          case "Seguridad social":
            colorList.add(Colors.purple);
            break;
          case "Multas y avisos":
            colorList.add(Colors.red);
            break;
          default:
            colorList.add(Colors.grey); // fallback
        }
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(
            0xFFEEF8F2,
          ), // mismo fondo que la gráfica de barras
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: pc.PieChart(
          dataMap: dataMap,
          colorList: colorList,
          chartType: pc.ChartType.disc,
          chartRadius: MediaQuery.of(context).size.width / 3,
          legendOptions: const pc.LegendOptions(
            showLegends: true,
            legendPosition: pc.LegendPosition.right,
          ),
          chartValuesOptions: const pc.ChartValuesOptions(
            showChartValuesInPercentage: true,
            showChartValues: true,
            chartValueStyle: TextStyle(
              fontSize: 9, // 🔹 aquí ajustas el tamaño
              color: Colors.black87, // opcional, para contraste
            ),
          ),
        ),
      );
    } catch (e) {
      print('🚨 Error en _buildPieChart: $e');
      return Text('Error en gráfica de pastel: ${e.toString()}');
    }
  }
}
