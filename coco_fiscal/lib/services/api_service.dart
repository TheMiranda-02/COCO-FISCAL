import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/resumen_tareas.dart';
import 'package:intl/intl.dart';

class ApiService {
  static const String baseUrl = "http://192.168.100.8/api_coco";

  static Future<List> getTareas({
    required bool completado,
    String categoria = '',
  }) async {
    final url = Uri.parse(
      "$baseUrl/tareas.php?completado=${completado ? 1 : 0}&categoria=$categoria",
    );
    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data is! List) return [];

    return data
        .map(
          (item) => {
            'id': int.tryParse(item['id'].toString()) ?? 0,
            'titulo': item['titulo'] ?? '',
            'categoria': item['categoria'] ?? '',
            'completado': int.tryParse(item['completado'].toString()) ?? 0,
          },
        )
        .toList();
  }

  static Future<int?> crearTarea(Map<String, dynamic> tarea) async {
    final url = Uri.parse("$baseUrl/tareas.php");
    final res = await http.post(
      url,
      body: jsonEncode(tarea),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(res.body);
    return data['id'];
  }

  static Future<bool> actualizarEstadoTarea(int id, bool completado) async {
    final url = Uri.parse("$baseUrl/tareas.php");
    final res = await http.put(
      url,
      body: {'id': '$id', 'completado': completado ? '1' : '0'},
    );
    return res.statusCode == 200;
  }

  static Future<bool> eliminarTarea(int id) async {
    final url = Uri.parse("$baseUrl/tareas.php?id=$id");
    final res = await http.delete(url);
    return res.statusCode == 200;
  }

  // SUBTAREAS
  static Future<List> getSubtareas(int tareaId) async {
    final url = Uri.parse("$baseUrl/subtareas.php?tarea_id=$tareaId");
    final res = await http.get(url);
    final data = jsonDecode(res.body);

    // Verificamos que data sea lista
    if (data is! List) return [];

    // Convertimos tipos correctamente
    return data
        .map(
          (item) => {
            'id': int.tryParse(item['id'].toString()) ?? 0,
            'tarea_id': int.tryParse(item['tarea_id'].toString()) ?? 0,
            'titulo': item['titulo'] ?? '',
            'completado': int.tryParse(item['completado'].toString()) ?? 0,
          },
        )
        .toList();
  }

  static Future<bool> crearSubtarea(int tareaId, String titulo) async {
    final url = Uri.parse("$baseUrl/subtareas.php");
    final res = await http.post(
      url,
      body: jsonEncode({"tarea_id": tareaId, "titulo": titulo}),
      headers: {'Content-Type': 'application/json'},
    );
    return res.statusCode == 200;
  }

  static Future<bool> actualizarEstadoSubtarea(int id, bool completado) async {
    final url = Uri.parse("$baseUrl/subtareas.php");
    final res = await http.put(
      url,
      body: {'id': '$id', 'completado': completado ? '1' : '0'},
    );
    return res.statusCode == 200;
  }

  static Future<bool> eliminarSubtarea(int id) async {
    final url = Uri.parse("$baseUrl/subtareas.php?id=$id");
    final res = await http.delete(url);
    return res.statusCode == 200;
  }

  // ARCHIVOS
  static Future<String?> subirArchivo(File archivo) async {
    final url = Uri.parse("$baseUrl/upload.php");
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final json = jsonDecode(respStr);
    return json['path'];
  }

  static Future<ResumenTareas?> fetchResumen(
    DateTime inicio,
    DateTime fin,
  ) async {
    final uri = Uri.parse("http://192.168.100.8/api_coco/resumen_tareas.php")
        .replace(
          queryParameters: {
            'fecha_inicio': DateFormat('yyyy-MM-dd').format(inicio),
            'fecha_fin': DateFormat('yyyy-MM-dd').format(fin),
          },
        );

    try {
      print("📡 Solicitando resumen desde: $uri");
      final res = await http.get(uri);

      print("🔁 STATUS CODE: ${res.statusCode}");
      print("📦 RAW BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        // Verifica que el JSON tenga las claves esperadas
        print("✅ JSON decodificado correctamente: $data");

        // Intenta crear el modelo
        final resumen = ResumenTareas.fromJson(data);
        print(
          "📊 Resumen creado con éxito: ${resumen.completadas} completadas, ${resumen.pendientes} pendientes",
        );

        return resumen;
      } else {
        print("⚠️ Error HTTP: ${res.statusCode}");
        return null;
      }
    } catch (e, st) {
      print("🚨 Error en fetchResumen: $e");
      print(st);
      return null;
    }
  }
}
