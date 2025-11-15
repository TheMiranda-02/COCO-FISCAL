class ResumenTareas {
  final int completadas;
  final int pendientes;
  final List<int> porDia;
  final List<Map<String, dynamic>> categorias;

  ResumenTareas({
    required this.completadas,
    required this.pendientes,
    required this.porDia,
    required this.categorias,
  });

  factory ResumenTareas.fromJson(Map<String, dynamic> json) {
    final porDiaData = json['por_dia'];

    final porDiaConvertido = (porDiaData as List)
        .map((e) => int.tryParse(e.toString()) ?? 0)
        .toList();

    return ResumenTareas(
      completadas: int.parse(json['completadas'].toString()),
      pendientes: int.parse(json['pendientes'].toString()),
      porDia: porDiaConvertido,
      categorias: (json['categorias'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }
}
