import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Estilos/form_crearcuenta.dart';

class FormCrearCFDIScreen extends StatefulWidget {
  const FormCrearCFDIScreen({super.key});

  @override
  State<FormCrearCFDIScreen> createState() => _FormCrearCFDIScreenState();
}

class _FormCrearCFDIScreenState extends State<FormCrearCFDIScreen> {
  // Controladores para campos de texto
  final TextEditingController _folioFiscalController = TextEditingController();
  final TextEditingController _folioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _usoCfdController = TextEditingController();

  // CONTROLLERS PARA EMISOR
  final TextEditingController _rfcEmisorController = TextEditingController();
  final TextEditingController _nombreEmisorController = TextEditingController();

  // CONTROLLERS PARA RECEPTOR
  final TextEditingController _rfcReceptorController = TextEditingController();
  final TextEditingController _nombreReceptorController =
      TextEditingController();
  final TextEditingController _codigoPostalController = TextEditingController();

  // Controladores para Producto/Servicio
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _valorUnitarioController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();

  // Variables para combobox Producto/Servicio
  String? _unidadValue;
  String? _impuestoValue;
  String? _tipoValue;

  // Listas para los combobox
  final List<String> _unidades = [
    'Pieza',
    'Kilogramo',
    'Litro',
    'Metro',
    'Caja',
    'Paquete',
  ];

  final List<String> _impuestos = ['IVA', 'ISR', 'IEPS'];
  final List<String> _tipos = ['Traslado', 'Retención'];

  // Lista para almacenar los productos agregados
  List<Producto> _productos = [];

  // Variables para los campos de selección
  String? _monedaValue;
  String? _formaPagoValue;

  bool _guardando = false;

  // Método para agregar producto - CORREGIDO CON CÁLCULOS EXACTOS
  void _agregarProducto() {
    // Validar campos obligatorios
    if (_claveController.text.isEmpty ||
        _cantidadController.text.isEmpty ||
        _valorUnitarioController.text.isEmpty ||
        _descripcionController.text.isEmpty) {
      _mostrarError('Por favor complete todos los campos obligatorios');
      return;
    }

    // 🧮 PASO 1: Calcular subtotal (Cantidad × Valor unitario)
    double cantidad = double.tryParse(_cantidadController.text) ?? 0;
    double valorUnitario = double.tryParse(_valorUnitarioController.text) ?? 0;
    double subtotal = cantidad * valorUnitario;

    double tasa = double.tryParse(_tasaController.text) ?? 0;

    // 🧮 PASO 2: Calcular impuesto (Subtotal × Tasa/100) - SEGÚN EJEMPLOS
    double importeImpuesto = subtotal * (tasa / 100);

    Producto nuevoProducto = Producto(
      clave: _claveController.text,
      cantidad: cantidad.toStringAsFixed(0),
      unidad: _unidadValue ?? 'Pieza',
      valorUnitario: valorUnitario.toStringAsFixed(2),
      importe: subtotal.toStringAsFixed(2), // Esto es el subtotal
      descripcion: _descripcionController.text,
      impuesto: _impuestoValue ?? 'IVA',
      tipo: _tipoValue ?? 'Traslado',
      tasaCuota: tasa.toStringAsFixed(2),
      importeImpuesto: importeImpuesto.toStringAsFixed(2),
    );

    setState(() {
      _productos.add(nuevoProducto);
    });

    // Limpiar campos después de agregar
    _limpiarCamposProducto();

    _mostrarExito('Producto agregado correctamente');
  }

  // Método para DEBUG - Mostrar todos los datos que se enviarán
  void _mostrarDatosEnviados(Producto primerProducto) {
    print('=== DATOS A ENVIAR AL SERVIDOR ===');
    print('folio_fiscal: ${_folioFiscalController.text}');
    print('folio: ${_folioController.text}');
    print('fecha: ${_fechaController.text}');
    print('serie: ${_serieController.text}');
    print('hora: ${_horaController.text}');
    print('uso_cfdi: ${_usoCfdController.text}');
    print('moneda: ${_monedaValue ?? "NULL"}');
    print('forma_pago: ${_formaPagoValue ?? "NULL"}');
    print('rfc_emisor: ${_rfcEmisorController.text}');
    print('nombre_emisor: ${_nombreEmisorController.text}');
    print('rfc_receptor: ${_rfcReceptorController.text}');
    print('nombre_receptor: ${_nombreReceptorController.text}');
    print('codigo_postal: ${_codigoPostalController.text}');
    print('clave_producto: ${primerProducto.clave}');
    print('cantidad_producto: ${primerProducto.cantidad}');
    print('unidad_producto: ${primerProducto.unidad}');
    print('valor_unitario_producto: ${primerProducto.valorUnitario}');
    print('importe_producto: ${primerProducto.importe}');
    print('descripcion_producto: ${primerProducto.descripcion}');
    print('impuesto_producto: ${primerProducto.impuesto}');
    print('tipo_impuesto_producto: ${primerProducto.tipo}');
    print('tasa_cuota_producto: ${primerProducto.tasaCuota}');
    print('importe_impuesto_producto: ${primerProducto.importeImpuesto}');
    print('===================================');
  }

  // Método para guardar CFDI en la base de datos
  Future<void> _guardarCFDI() async {
    if (_productos.isEmpty) {
      _mostrarError('Agrega al menos un producto antes de guardar');
      return;
    }

    // Validar campos obligatorios
    if (_rfcEmisorController.text.isEmpty ||
        _nombreEmisorController.text.isEmpty ||
        _rfcReceptorController.text.isEmpty ||
        _nombreReceptorController.text.isEmpty) {
      _mostrarError('Complete los datos del emisor y receptor');
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      // Tomar el primer producto
      Producto primerProducto = _productos.first;

      // DEBUG: Mostrar datos en consola
      _mostrarDatosEnviados(primerProducto);

      //CAMBIAR EL LINK YA QUE ESTE ES DE MANERA
      final url = Uri.parse('http://192.168.100.8/api_coco/agregar_cfdi.php');

      Map<String, dynamic> datosCFDI = {
        'folio_fiscal': _folioFiscalController.text,
        'folio': _folioController.text,
        'fecha': _fechaController.text,
        'serie': _serieController.text,
        'hora': _horaController.text,
        'uso_cfdi': _usoCfdController.text,
        'moneda': _monedaValue ?? '',
        'forma_pago': _formaPagoValue ?? '',
        'rfc_emisor': _rfcEmisorController.text,
        'nombre_emisor': _nombreEmisorController.text,
        'rfc_receptor': _rfcReceptorController.text,
        'nombre_receptor': _nombreReceptorController.text,
        'codigo_postal': _codigoPostalController.text,
        'clave_producto': primerProducto.clave,
        'cantidad_producto': primerProducto.cantidad,
        'unidad_producto': primerProducto.unidad,
        'valor_unitario_producto': primerProducto.valorUnitario,
        'importe_producto': primerProducto.importe,
        'descripcion_producto': primerProducto.descripcion,
        'impuesto_producto': primerProducto.impuesto,
        'tipo_impuesto_producto': primerProducto.tipo,
        'tasa_cuota_producto': primerProducto.tasaCuota,
        'importe_impuesto_producto': primerProducto.importeImpuesto,
      };

      print('JSON enviado: ${jsonEncode(datosCFDI)}'); // DEBUG

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosCFDI),
      );

      print('Respuesta del servidor: ${response.statusCode}'); // DEBUG
      print('Cuerpo de respuesta: ${response.body}'); // DEBUG

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _mostrarExito(data['message']);
          _limpiarFormulario();
        } else {
          _mostrarError(data['message']);
        }
      } else {
        _mostrarError('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error completo: $e'); // DEBUG
      _mostrarError('Error de conexión: $e');
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  void _limpiarFormulario() {
    _folioFiscalController.clear();
    _folioController.clear();
    _fechaController.clear();
    _serieController.clear();
    _horaController.clear();
    _usoCfdController.clear();
    _rfcEmisorController.clear();
    _nombreEmisorController.clear();
    _rfcReceptorController.clear();
    _nombreReceptorController.clear();
    _codigoPostalController.clear();
    _limpiarCamposProducto();
    setState(() {
      _productos.clear();
      _monedaValue = null;
      _formaPagoValue = null;
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _limpiarCamposProducto() {
    _claveController.clear();
    _cantidadController.clear();
    _valorUnitarioController.clear();
    _descripcionController.clear();
    _tasaController.clear();
    setState(() {
      _unidadValue = null;
      _impuestoValue = null;
      _tipoValue = null;
    });
  }

  void _eliminarProducto(int index) {
    setState(() {
      _productos.removeAt(index);
    });
    _mostrarExito('Producto eliminado');
  }

  // Método para construir el resumen final - CORREGIDO
  Widget _buildResumenFinal() {
    double subtotal = _productos.fold(
      0,
      (sum, producto) => sum + (double.tryParse(producto.importe) ?? 0),
    );
    double impuestos = _productos.fold(
      0,
      (sum, producto) => sum + (double.tryParse(producto.importeImpuesto) ?? 0),
    );
    double total = subtotal + impuestos;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Subtotal: \$${subtotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Impuestos trasladados: \$${impuestos.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CAMPO FOLIO FISCAL
            CfdTextField(
              controller: _folioFiscalController,
              hintText: 'Folio Fiscal',
            ),
            const SizedBox(height: 16),

            // FOLIO Y FECHA EN MISMA FILA - FOLIO CON TAMAÑO IGUAL A FECHA
            Row(
              children: [
                // Campo Folio - MISMO TAMAÑO QUE FECHA
                Expanded(
                  child: TextField(
                    controller: _folioController,
                    keyboardType: TextInputType.number,
                    style: InputStyles.textStyle,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Folio',
                      hintStyle: InputStyles.hintStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.focusedBorderColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.inputFillColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13, // ← MISMO VERTICAL QUE FECHA
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Campo Fecha
                Expanded(
                  child: _FechaFieldSimplificado(controller: _fechaController),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // SERIE Y HORA EN MISMA FILA - SERIE CON TAMAÑO IGUAL A HORA
            Row(
              children: [
                // Campo Serie - MISMO TAMAÑO QUE HORA
                Expanded(
                  child: TextField(
                    controller: _serieController,
                    keyboardType: TextInputType.number,
                    style: InputStyles.textStyle,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Serie',
                      hintStyle: InputStyles.hintStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.focusedBorderColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.inputFillColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13, // ← MISMO VERTICAL QUE HORA
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Campo Hora - MEJORADO
                Expanded(
                  child: _HoraFieldMejorado(controller: _horaController),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // MONEDA Y FORMA DE PAGO EN MISMA FILA
            MonedaFormaPagoLayout(
              monedaValue: _monedaValue,
              formaPagoValue: _formaPagoValue,
              onMonedaChanged: (newValue) {
                setState(() {
                  _monedaValue = newValue;
                });
              },
              onFormaPagoChanged: (newValue) {
                setState(() {
                  _formaPagoValue = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // USO DE CFDI
            CfdTextField(
              controller: _usoCfdController,
              hintText: 'Uso de CFDI',
            ),
            const SizedBox(height: 20),

            // SECCIÓN DATOS DEL EMISOR (DEBAJO DE USO DE CFDI)
            SeccionConTitulo(
              titulo: 'DATOS DEL EMISOR',
              children: [
                Text('RFC del emisor', style: AppTextStyles.label),
                CfdTextFieldBlanco(controller: _rfcEmisorController),
                const SizedBox(height: 12),
                Text('Nombre del emisor', style: AppTextStyles.label),
                CfdTextFieldBlanco(controller: _nombreEmisorController),
              ],
            ),
            const SizedBox(height: 20),

            // SECCIÓN DATOS DEL RECEPTOR (DEBAJO DE DATOS DEL EMISOR)
            SeccionConTitulo(
              titulo: 'DATOS DEL RECEPTOR',
              children: [
                // RFC DEL RECEPTOR Y CÓDIGO POSTAL EN MISMA FILA
                Row(
                  children: [
                    // RFC del receptor
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RFC del receptor', style: AppTextStyles.label),
                          CfdTextFieldBlanco(
                            controller: _rfcReceptorController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Código Postal - SOLO NÚMEROS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Código Postal', style: AppTextStyles.label),
                          TextField(
                            controller: _codigoPostalController,
                            keyboardType:
                                TextInputType.number, // ← SOLO NÚMEROS
                            style: InputStyles.textStyle,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintStyle: InputStyles.hintStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  InputStyles.borderRadius,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.inputBorderColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  InputStyles.borderRadius,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.inputBorderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  InputStyles.borderRadius,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.focusedBorderColor,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: InputStyles.contentPadding,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Nombre del receptor
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre del receptor', style: AppTextStyles.label),
                    CfdTextFieldBlanco(controller: _nombreReceptorController),
                  ],
                ),
              ],
            ),

            // DATOS DEL PRODUCTO/SERVICIO
            const SizedBox(height: 20),
            ProductoServicioLayout(
              claveController: _claveController,
              cantidadController: _cantidadController,
              valorUnitarioController: _valorUnitarioController,
              descripcionController: _descripcionController,
              tasaController: _tasaController,
              unidadValue: _unidadValue,
              impuestoValue: _impuestoValue,
              tipoValue: _tipoValue,
              unidades: _unidades,
              impuestos: _impuestos,
              tipos: _tipos,
              onUnidadChanged: (newValue) {
                setState(() {
                  _unidadValue = newValue;
                });
              },
              onImpuestoChanged: (newValue) {
                setState(() {
                  _impuestoValue = newValue;
                });
              },
              onTipoChanged: (newValue) {
                setState(() {
                  _tipoValue = newValue;
                });
              },
              onAgregar: _agregarProducto,
              onEliminar: _limpiarCamposProducto,
            ),

            // TABLA DE PRODUCTOS - CORREGIDA CON BOTÓN ELIMINAR FUNCIONAL
            const SizedBox(height: 20),
            TablaProductosConEliminar(
              productos: _productos,
              onEliminar: _eliminarProducto,
            ),

            // RESUMEN FINAL
            if (_productos.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildResumenFinal(),
            ],

            const SizedBox(height: 20),

            // BOTÓN GUARDAR
            _guardando
                ? Center(child: CircularProgressIndicator())
                : GuardarCfdButton(
                    onPressed: _guardarCFDI,
                    disabled: _productos.isEmpty,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _folioFiscalController.dispose();
    _folioController.dispose();
    _fechaController.dispose();
    _serieController.dispose();
    _horaController.dispose();
    _usoCfdController.dispose();
    _rfcEmisorController.dispose();
    _nombreEmisorController.dispose();
    _rfcReceptorController.dispose();
    _nombreReceptorController.dispose();

    // CONTROLLERS PARA PRODUCTO/SERVICIO
    _claveController.dispose();
    _cantidadController.dispose();
    _valorUnitarioController.dispose();
    _descripcionController.dispose();
    _tasaController.dispose();

    super.dispose();
  }
}

// Widget simplificado para Fecha - MISMO TAMAÑO EXACTO
class _FechaFieldSimplificado extends StatefulWidget {
  final TextEditingController controller;

  const _FechaFieldSimplificado({required this.controller});

  @override
  State<_FechaFieldSimplificado> createState() =>
      _FechaFieldSimplificadoState();
}

class _FechaFieldSimplificadoState extends State<_FechaFieldSimplificado> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      style: InputStyles.textStyle,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Fecha',
        hintStyle: InputStyles.hintStyle,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(
              Icons.calendar_today,
              color: AppColors.hintColor,
              size: 18,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 12),
            onPressed: () => _selectDate(context),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          borderSide: const BorderSide(
            color: AppColors.focusedBorderColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6, // ← ESTE ES EL TAMAÑO QUE DEBEN TENER LOS OTROS CAMPOS
        ),
        isDense: true,
      ),
      onTap: () => _selectDate(context),
    );
  }
}

// Widget MEJORADO para Hora - MÁS CLARO Y FUNCIONAL
class _HoraFieldMejorado extends StatefulWidget {
  final TextEditingController controller;

  const _HoraFieldMejorado({required this.controller});

  @override
  State<_HoraFieldMejorado> createState() => _HoraFieldMejoradoState();
}

class _HoraFieldMejoradoState extends State<_HoraFieldMejorado> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        widget.controller.text =
            "${picked.hour.toString().padLeft(2, '0')}:"
            "${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      style: InputStyles.textStyle,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'HH:MM',
        hintStyle: InputStyles.hintStyle,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(
              Icons.schedule,
              color: AppColors.hintColor,
              size: 18,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            onPressed: () => _selectTime(context),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          borderSide: const BorderSide(
            color: AppColors.focusedBorderColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7, // ← MISMO TAMAÑO QUE SERIE
        ),
        isDense: true,
      ),
      onTap: () => _selectTime(context),
    );
  }
}

// TABLA DE PRODUCTOS CON BOTÓN ELIMINAR FUNCIONAL
class TablaProductosConEliminar extends StatelessWidget {
  final List<Producto> productos;
  final Function(int) onEliminar;

  const TablaProductosConEliminar({
    super.key,
    required this.productos,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // PRIMERA TABLA - PRODUCTO/SERVICIO
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: [
                  // Encabezado primera tabla - CORREGIDO
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _HeaderCell('Clave del Producto/Servicio', width: 180),
                        _HeaderCell('Cantidad', width: 80),
                        _HeaderCell('Unidad', width: 80),
                        _HeaderCell('Valor Unitario', width: 100),
                        _HeaderCell('Importe', width: 100),
                      ],
                    ),
                  ),

                  // Filas primera tabla
                  if (productos.isEmpty)
                    _EmptyRow(height: 60)
                  else
                    ...productos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final producto = entry.value;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: index.isEven
                              ? Colors.white
                              : Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            _DataCell(producto.clave, width: 180),
                            _DataCell(producto.cantidad, width: 80),
                            _DataCell(producto.unidad, width: 80),
                            _DataCell(
                              '\$${producto.valorUnitario}',
                              width: 100,
                            ),
                            _DataCell('\$${producto.importe}', width: 100),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),

          // SEGUNDA TABLA - DESCRIPCIÓN E IMPUESTOS CON BOTÓN ELIMINAR
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: [
                  // Encabezado segunda tabla CON BOTÓN ELIMINAR
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _HeaderCell('Descripción', width: 180),
                        _HeaderCell('Impuesto', width: 80),
                        _HeaderCell('Tipo', width: 80),
                        _HeaderCell('Tasa o Cuota', width: 100),
                        _HeaderCell('Importe', width: 100),
                        _HeaderCell('Eliminar', width: 80), // COLUMNA ELIMINAR
                      ],
                    ),
                  ),

                  // Filas segunda tabla CON BOTÓN ELIMINAR FUNCIONAL
                  if (productos.isEmpty)
                    _EmptyRow(height: 60)
                  else
                    ...productos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final producto = entry.value;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: index.isEven
                              ? Colors.white
                              : Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            _DataCell(producto.descripcion, width: 180),
                            _DataCell(producto.impuesto, width: 80),
                            _DataCell(producto.tipo, width: 80),
                            _DataCell('${producto.tasaCuota}%', width: 100),
                            _DataCell(
                              '\$${producto.importeImpuesto}',
                              width: 100,
                            ),
                            // BOTÓN ELIMINAR FUNCIONAL
                            Container(
                              width: 80,
                              padding: const EdgeInsets.all(4),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                onPressed: () => onEliminar(index),
                                padding: EdgeInsets.zero,
                                tooltip: 'Eliminar producto',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para fila vacía
class _EmptyRow extends StatelessWidget {
  final double height;
  const _EmptyRow({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: const Center(
        child: Text(
          'No hay productos agregados',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}

// Widget para celdas de encabezado
class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const _HeaderCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Widget para celdas de datos
class _DataCell extends StatelessWidget {
  final String text;
  final double width;

  const _DataCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
