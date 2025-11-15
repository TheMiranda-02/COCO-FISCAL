import 'dart:io';
import 'package:flutter/material.dart';
import '../Estilos/form_crearcuenta.dart';
//IR A PAGINAS CON BOTON
import 'categoria_crear_cuenta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crear Cuenta',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const CrearCuentaScreen(),
    );
  }
}

class CrearCuentaScreen extends StatefulWidget {
  const CrearCuentaScreen({super.key});

  @override
  State<CrearCuentaScreen> createState() => _CrearCuentaScreenState();
}

class _CrearCuentaScreenState extends State<CrearCuentaScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  String _regimenFiscalSeleccionado = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  String _selectedLada = '+52';
  final TextEditingController _calleController = TextEditingController();
  final TextEditingController _coloniaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();

  bool _aceptoTerminos = false;

  final List<Map<String, String>> _regimenesFiscales = [
    {
      'codigo': '605',
      'descripcion': 'Sueldos y Salarios e Ingresos Asimilados a Salarios',
    },
    {'codigo': '606', 'descripcion': 'Arrendamiento'},
    {
      'codigo': '612',
      'descripcion':
          'Personas Físicas con Actividades Empresariales y Profesionales',
    },
    {'codigo': '616', 'descripcion': 'Sin Obligaciones Fiscales'},
    {'codigo': '626', 'descripcion': 'Régimen Simplificado de Confianza'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de perfil con botón +
            ProfileImagePicker(
              onImageSelected: (File? image) {
                debugPrint('Imagen seleccionada: $image');
              },
            ),
            const SizedBox(height: 30),

            // Campo Nombre
            AppLabels.buildLabelWithIndicator('Nombre'),
            const SizedBox(height: 8),
            CustomTextField(controller: _nombreController),
            const SizedBox(height: 20),

            // Campo RFC
            AppLabels.buildLabelWithIndicator('RFC'),
            const SizedBox(height: 8),
            CustomTextField(controller: _rfcController),
            const SizedBox(height: 20),

            // Campo Régimen Fiscal
            AppLabels.buildLabelWithIndicator('Régimen Fiscal'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _regimenFiscalSeleccionado.isEmpty
                  ? null
                  : _regimenFiscalSeleccionado,
              items: _regimenesFiscales.map((regimen) {
                return DropdownMenuItem<String>(
                  value: regimen['codigo'],
                  child: Text(
                    '[${regimen['codigo']}] ${regimen['descripcion']}',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _regimenFiscalSeleccionado = newValue ?? '';
                });
              },
              decoration: AppDropdownStyles.dropdownDecoration.copyWith(
                hintText: 'Selecciona tu régimen fiscal',
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              style: AppTextStyles.textField,
            ),
            const SizedBox(height: 20),

            // Campo Correo Electrónico
            AppLabels.buildLabelWithIndicator('Correo Electrónico'),
            const SizedBox(height: 8),
            CustomTextField(controller: _emailController),
            const SizedBox(height: 20),

            // Campo Contraseña
            AppLabels.buildLabelWithIndicator('Contraseña'),
            const SizedBox(height: 8),
            CustomTextField(controller: _passwordController, obscureText: true),
            const SizedBox(height: 20),

            // Campo Número de Celular
            Text('Número de Celular', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 100,
                  child: DropdownButtonFormField<String>(
                    value: _selectedLada,
                    items: const [
                      DropdownMenuItem(value: '+52', child: Text('+52')),
                      DropdownMenuItem(value: '+55', child: Text('+55')),
                      DropdownMenuItem(value: '+90', child: Text('+90')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLada = value!;
                      });
                    },
                    decoration: AppDropdownStyles.dropdownDecoration.copyWith(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.focusedBorderColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _celularController,
                    keyboardType: TextInputType.phone,
                    style: AppTextStyles.textField,
                    decoration: InputDecoration(
                      hintStyle: AppTextStyles.hint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.focusedBorderColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.inputFillColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            //Campo Domicilio
            AppLabels.buildLabelWithIndicator('Domicilio'),

            //Calle
            AppLabels.buildLabelCalleWithIndicator('Calle'),
            const SizedBox(height: 8),
            CustomTextField(controller: _calleController),
            const SizedBox(height: 20),

            // Colonia y Número en misma fila
            AppLayoutStyles.coloniaNumeroLayout(
              coloniaController: _coloniaController,
              numeroController: _numeroController,
              flexColonia: 3,
              flexNumero: 2,
            ),
            const SizedBox(height: 20),

            // Código Postal y Ciudad en misma fila
            AppLayoutStyles.cpCiudadLayout(
              cpController: _cpController,
              ciudadController: _ciudadController,
              flexCP: 2,
              flexCiudad: 3,
            ),
            const SizedBox(height: 20),

            // Estado y País en misma fila (50%/50%)
            AppLayoutStyles.estadoPaisLayout(
              estadoController: _estadoController,
              paisController: _paisController,
              flexEstado: 1,
              flexPais: 1,
            ),
            const SizedBox(height: 20),

            // Fecha de Nacimiento con calendario
            DatePickerField(
              controller: _fechaNacimientoController,
              label: 'Fecha de Nacimiento',
            ),
            const SizedBox(height: 20),

            // Términos y condiciones
            TerminosCondiciones(
              value: _aceptoTerminos,
              onChanged: (bool? value) {
                setState(() {
                  _aceptoTerminos = value ?? false;
                });
              },
            ),
            const SizedBox(height: 30),

            // Botón CON TAMAÑO PERSONALIZABLE
            Container(
              width: double.infinity, // ← ANCHO COMPLETO
              height: 70, // ← ALTURA PERSONALIZADA
              child: GestureDetector(
                onTap: _aceptoTerminos ? _crearCuenta : null,
                child: Image.asset(
                  'assets/images/btnSiguiente.png',
                  width: double.infinity,
                  height: 70,
                  fit: BoxFit.fill, // ← OCUPA TODO EL ESPACIO
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _aceptoTerminos
                            ? Color(0xFF468C62)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Siguiente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _crearCuenta() {
    print('🔍 === VERIFICANDO DATOS ANTES DE NAVEGAR ===');
    print('Régimen Fiscal seleccionado: $_regimenFiscalSeleccionado');

    final datosUsuario = {
      'nombre': _nombreController.text,
      'rfc': _rfcController.text,
      'regimenFiscal': _regimenFiscalSeleccionado,
      'email': _emailController.text,
      'pass': _passwordController.text,
      'lada': _selectedLada,
      'celular': _celularController.text,
      'fechaNacimiento': _fechaNacimientoController.text,
      'calle': _calleController.text,
      'colonia': _coloniaController.text,
      'numero': _numeroController.text,
      'cp': _cpController.text,
      'ciudad': _ciudadController.text,
      'estado': _estadoController.text,
      'pais': _paisController.text,
    };

    print('📤 DATOS A ENVIAR:');
    datosUsuario.forEach((key, value) {
      print('   $key: $value');
    });

    if (_regimenFiscalSeleccionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor selecciona un régimen fiscal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CategoriaCrearCuentaScreen(datosUsuario: datosUsuario),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rfcController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _celularController.dispose();
    _calleController.dispose();
    _cpController.dispose();
    _ciudadController.dispose();
    _estadoController.dispose();
    _paisController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }
}
