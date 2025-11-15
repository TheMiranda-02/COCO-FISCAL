import 'dart:io'; // Para la clase File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//DISEÑOS DE CREAR CUENTA
// Colores
class AppColors {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color accentColor = Color(0xFF00C853);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color textColor = Color(0xFF212121);
  static const Color hintColor = Color(0xFF000000);
  static const Color borderColor = Color.fromARGB(255, 255, 255, 255);
  static const Color backgroundColor = Color.fromARGB(255, 95, 94, 94);
  static const Color inputBorderColor = Color.fromARGB(255, 216, 215, 215);
  static const Color focusedBorderColor = Color.fromARGB(255, 186, 189, 192);
  static const Color inputFillColor = Color.fromARGB(230, 230, 227, 227);

  // Agregar estos colores para los botones
  static const Color successColor = Color(0xFF4CAF50); // Verde para el botón +
  static const Color warningColor = Color(0xFFFF9800); // Naranja opcional
}

// Textos
class AppTextStyles {
  static const TextStyle tituloPrincipal = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 14,
    color: AppColors.hintColor,
  );

  static const TextStyle botonTexto = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle textField = TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );

  //Campo Domicilios
  static const TextStyle labelCalle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 189, 191, 192),
  );
}

// Labels y constantes
class AppLabels {
  // ✅ MÉTODOS PARA LABELS CON INDICADOR VISUAL
  static Widget buildLabelWithIndicator(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: AppTextStyles.label),
        SizedBox(width: 4),
        Image.asset(
          'assets/images/Obligatorio.png', // CAMBIA POR TU RUTA DE IMAGEN
          width: 14,
          height: 14,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              'ⓘ',
              style: TextStyle(fontSize: 12, color: AppColors.textColor),
            );
          },
        ),
      ],
    );
  }

  // ✅ MÉTODO ESPECIAL PARA LABELSCALLE (gris)
  static Widget buildLabelCalleWithIndicator(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: AppTextStyles.labelCalle),
        SizedBox(width: 4),
        Image.asset(
          'assets/images/Obligatorio.png', // CAMBIA POR TU RUTA DE IMAGEN
          width: 16,
          height: 16,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              'ⓘ',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 189, 191, 192),
              ),
            );
          },
        ),
      ],
    );
  }

  static const String crearCuenta = 'Crear Cuenta';
  static const String nombre = 'Nombre';
  static const String rfc = 'RFC';
  static const String regimenFiscal = 'Régimen Fiscal';
  static const String correoElectronico = 'Correo Electrónico';
  static const String contrasena = 'Contraseña';
  static const String numeroCelular = 'Número de Celular';
  static const String domicilio = 'Domicilio';
  static const String calle = 'Calle';
  static const String colonia = 'Colonia';
  static const String numero = 'Número';
  static const String codigoPostal = 'Código Postal';
  static const String ciudad = 'Ciudad';
  static const String estado = 'Estado';
  static const String pais = 'País';
  static const String fechaNacimiento = 'Fecha de Nacimiento';
}

// Estilos para Dropdown (Combobox) - SIN BORDES
class AppDropdownStyles {
  static InputDecoration dropdownDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    filled: true,
    fillColor: AppColors.inputFillColor,
  );
}

// Campo de texto personalizado
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.textField,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.focusedBorderColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

// Clases de diseño/layout
class AppLayoutStyles {
  // Layout para Colonia y Número (75% / 25%)
  static Widget coloniaNumeroLayout({
    required TextEditingController coloniaController,
    required TextEditingController numeroController,
    int flexColonia = 3,
    int flexNumero = 1,
  }) {
    return Row(
      children: [
        // Colonia (75% del espacio)
        Expanded(
          flex: flexColonia,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabels.buildLabelCalleWithIndicator('Colonia'),
              const SizedBox(height: 8),
              CustomTextField(controller: coloniaController),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Número (25% del espacio) - SOLO NÚMEROS
        Expanded(
          flex: flexNumero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabels.buildLabelCalleWithIndicator('Número'),
              const SizedBox(height: 8),
              TextField(
                controller: numeroController,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.textField,
                decoration: InputDecoration(
                  hintStyle: AppTextStyles.hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.inputBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.inputBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.focusedBorderColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.inputFillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Layout para Código Postal y Ciudad (25% / 75%)
  static Widget cpCiudadLayout({
    required TextEditingController cpController,
    required TextEditingController ciudadController,
    int flexCP = 1,
    int flexCiudad = 3,
  }) {
    return Row(
      children: [
        // Código Postal (25% del espacio) - SOLO NÚMEROS
        Expanded(
          flex: flexCP,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabels.buildLabelCalleWithIndicator('Código Postal'),
              const SizedBox(height: 8),
              TextField(
                controller: cpController,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.textField,
                decoration: InputDecoration(
                  hintStyle: AppTextStyles.hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.inputBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.inputBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.focusedBorderColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.inputFillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Ciudad (75% del espacio)
        Expanded(
          flex: flexCiudad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabels.buildLabelCalleWithIndicator('Ciudad'),
              const SizedBox(height: 8),
              CustomTextField(controller: ciudadController),
            ],
          ),
        ),
      ],
    );
  }

  // Layout para campos iguales (50% / 50%)
  static Widget equalLayout({
    required String label1,
    required TextEditingController controller1,
    required String label2,
    required TextEditingController controller2,
    TextStyle? labelStyle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: labelStyle ?? AppTextStyles.label),
              const SizedBox(height: 8),
              CustomTextField(controller: controller1),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2, style: labelStyle ?? AppTextStyles.label),
              const SizedBox(height: 8),
              CustomTextField(controller: controller2),
            ],
          ),
        ),
      ],
    );
  }

  // Layout para Estado y País (50% / 50%)
  static Widget estadoPaisLayout({
    required TextEditingController estadoController,
    required TextEditingController paisController,
    int flexEstado = 1,
    int flexPais = 1,
  }) {
    return Row(
      children: [
        // Estado
        Expanded(
          flex: flexEstado,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabels.buildLabelCalleWithIndicator('Estado'),
              const SizedBox(height: 8),
              CustomTextField(controller: estadoController),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // País
        Expanded(
          flex: flexPais,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabels.buildLabelCalleWithIndicator('País'),
              const SizedBox(height: 8),
              CustomTextField(controller: paisController),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget para seleccionar fecha
class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabels.buildLabelCalleWithIndicator('Fecha de Nacimiento'),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          readOnly: true,
          style: AppTextStyles.textField,
          decoration: InputDecoration(
            hintText: 'DD/MM/AAAA',
            hintStyle: AppTextStyles.hint,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: AppColors.hintColor,
              ),
              onPressed: () => _selectDate(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.focusedBorderColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.inputFillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onTap: () => _selectDate(context),
        ),
      ],
    );
  }
}

// Widget para Términos y Condiciones
class TerminosCondiciones extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TerminosCondiciones({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TerminosCondiciones> createState() => _TerminosCondicionesState();
}

class _TerminosCondicionesState extends State<TerminosCondiciones> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: widget.value, onChanged: widget.onChanged),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Acepto ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'términos y condiciones',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// En AppButtonStyles, agrega:
class AppButtonStyles {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 20, 143, 75),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 1,
  );
}

//APARTADO PARA LA SECCIÓN DE IMAGEN
class ProfileImagePicker extends StatefulWidget {
  final ValueChanged<File?> onImageSelected;

  const ProfileImagePicker({super.key, required this.onImageSelected});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        widget.onImageSelected(_selectedImage);
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage('assets/images/Icono_User.png'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 181, 184, 185),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------
//-------------------DISEÑOS DE CATEGORÍAS CREAR CUENTA----------------------------

class CategoriaCard extends StatelessWidget {
  final String nombre;
  final String imagen;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color; // ← AGREGAR este parámetro

  const CategoriaCard({
    super.key,
    required this.nombre,
    required this.imagen,
    required this.isSelected,
    required this.onTap,
    required this.color, // ← AGREGAR este parámetro
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // USAR EL COLOR ESPECÍFICO DE CADA CATEGORÍA
          color: isSelected
              ? AppColors.primaryColor.withOpacity(
                  0.1,
                ) // Cuando está seleccionada
              : color, // Color único cuando NO está seleccionada
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : color, // Borde con color único cuando NO está seleccionada
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 245, 245, 245).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Contenido de la tarjeta - TODO CENTRADO
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Círculo con IMAGEN
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // COLOR DEL CÍRCULO CON COLOR ÚNICO
                      color: isSelected
                          ? AppColors
                                .primaryColor // Cuando está seleccionada
                          : color, // Color único cuando NO está seleccionada
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        imagen,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: isSelected ? AppColors.primaryColor : color,
                            child: Icon(
                              Icons.image,
                              color: isSelected ? Colors.white : Colors.white,
                              size: 22,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nombre de la categoría
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors
                                  .primaryColor // Cuando está seleccionada
                            : const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ), // Blanco para contraste cuando NO está seleccionada
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Check de selección (esquina superior derecha)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ), // Borde blanco cuando NO está seleccionada
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------
//---------------------------DISEÑOS DE CREAR CFDI---------------------------------
//---------------------------------------------------------------------------------

// CLASE PARA CONTROLAR TODOS LOS ESTILOS DE INPUTS
class InputStyles {
  // TAMAÑOS
  static const double textSize = 14;
  static const double hintSize = 13;
  static const double dropdownHeight = 38; // ← REDUCIDO para igualar altura

  // PADDING - MISMO QUE FECHA Y HORA
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 5, // ← MISMO QUE FECHA Y HORA
  );

  // BORDES
  static const double borderRadius = 10;

  // ESTILOS DE TEXTO
  static TextStyle get textStyle =>
      AppTextStyles.textField.copyWith(fontSize: textSize);

  static TextStyle get hintStyle =>
      AppTextStyles.hint.copyWith(fontSize: hintSize);
}

// TextField especial para CFDI - MISMO TAMAÑO QUE FECHA Y HORA
class CfdTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;

  const CfdTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: InputStyles.textStyle,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: InputStyles.hintStyle,
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
        contentPadding: InputStyles.contentPadding, // ← MISMO PADDING
        isDense: true,
      ),
    );
  }
}

// Layout para Folio y Fecha en misma fila - CORREGIDO
class FolioFechaLayout extends StatelessWidget {
  final TextEditingController folioController;
  final TextEditingController fechaController;

  const FolioFechaLayout({
    super.key,
    required this.folioController,
    required this.fechaController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Campo Folio - USA CfdTextField
        Expanded(
          child: CfdTextField(
            controller: folioController,
            hintText: 'Folio',
            keyboardType: TextInputType.number, // ← SOLO NÚMEROS
          ),
        ),
        const SizedBox(width: 12),

        // Campo Fecha
        Expanded(child: _FechaFieldSimplificado(controller: fechaController)),
      ],
    );
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
          padding: const EdgeInsets.only(
            right: 8,
          ), // Padding específico para el icono
          child: IconButton(
            icon: const Icon(
              Icons.calendar_today,
              color: AppColors.hintColor,
              size: 18,
            ),
            padding: EdgeInsets.zero, // Padding cero en el botón
            constraints: const BoxConstraints(
              minWidth: 30, // Ancho mínimo reducido
              minHeight: 12, // Alto mínimo reducido
            ),
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
          vertical: 6, // ← VERTICAL REDUCIDO para compensar el icono
        ),
        isDense: true,
      ),
      onTap: () => _selectDate(context),
    );
  }
}

// Layout para Serie y Hora en misma fila - CORREGIDO
class SerieHoraLayout extends StatelessWidget {
  final TextEditingController serieController;
  final TextEditingController horaController;

  const SerieHoraLayout({
    super.key,
    required this.serieController,
    required this.horaController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Campo Serie - SOLO NÚMEROS
        Expanded(
          child: TextField(
            controller: serieController,
            keyboardType: TextInputType.number, // ← SOLO NÚMEROS
            style: InputStyles.textStyle,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Serie',
              hintStyle: InputStyles.hintStyle,
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
              contentPadding: InputStyles.contentPadding,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Campo Hora
        Expanded(child: _HoraFieldSimplificado(controller: horaController)),
      ],
    );
  }
}

// Widget simplificado para Hora - MISMO TAMAÑO EXACTO
class _HoraFieldSimplificado extends StatefulWidget {
  final TextEditingController controller;

  const _HoraFieldSimplificado({required this.controller});

  @override
  State<_HoraFieldSimplificado> createState() => _HoraFieldSimplificadoState();
}

class _HoraFieldSimplificadoState extends State<_HoraFieldSimplificado> {
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
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
        hintText: 'Hora',
        hintStyle: InputStyles.hintStyle,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ), // Padding específico para el icono
          child: IconButton(
            icon: const Icon(
              Icons.access_time,
              color: AppColors.hintColor,
              size: 18,
            ),
            padding: EdgeInsets.zero, // Padding cero en el botón
            constraints: const BoxConstraints(
              minWidth: 30, // Ancho mínimo reducido
              minHeight: 30, // Alto mínimo reducido
            ),
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
          vertical: 7, // ← VERTICAL REDUCIDO para compensar el icono
        ),
        isDense: true,
      ),
      onTap: () => _selectTime(context),
    );
  }
}

//--------------------------------
// Layout para Moneda y Forma de Pago en misma fila - MÁS PEQUEÑO
class MonedaFormaPagoLayout extends StatelessWidget {
  final String? monedaValue;
  final String? formaPagoValue;
  final ValueChanged<String?> onMonedaChanged;
  final ValueChanged<String?> onFormaPagoChanged;

  const MonedaFormaPagoLayout({
    super.key,
    required this.monedaValue,
    required this.formaPagoValue,
    required this.onMonedaChanged,
    required this.onFormaPagoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ComboBox Moneda
        Expanded(
          child: _MonedaDropdown(
            value: monedaValue,
            onChanged: onMonedaChanged,
          ),
        ),
        const SizedBox(width: 12),

        // ComboBox Forma de Pago
        Expanded(
          child: _FormaPagoDropdown(
            value: formaPagoValue,
            onChanged: onFormaPagoChanged,
          ),
        ),
      ],
    );
  }
}

// Dropdown para Moneda - MÁS PEQUEÑO
class _MonedaDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _MonedaDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: InputStyles.dropdownHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(InputStyles.borderRadius),
        border: Border.all(color: AppColors.inputBorderColor),
        color: AppColors.inputFillColor,
      ),
      padding: InputStyles.contentPadding,
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          style: InputStyles.textStyle,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.hintColor),
          dropdownColor: AppColors.inputFillColor,
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          items: const [
            DropdownMenuItem(
              value: null,
              child: Text(
                'Moneda',
                style: AppTextStyles.hint,
                textAlign: TextAlign.center,
              ),
            ),
            DropdownMenuItem(
              value: 'MXN',
              child: Text('Mexicanos', textAlign: TextAlign.center),
            ),
            DropdownMenuItem(
              value: 'COP',
              child: Text('Colombianos', textAlign: TextAlign.center),
            ),
            DropdownMenuItem(
              value: 'USD',
              child: Text('Americanos', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

// Dropdown para Forma de Pago - MÁS PEQUEÑO
class _FormaPagoDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _FormaPagoDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: InputStyles.dropdownHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(InputStyles.borderRadius),
        border: Border.all(color: AppColors.inputBorderColor),
        color: AppColors.inputFillColor,
      ),
      padding: InputStyles.contentPadding,
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          style: InputStyles.textStyle,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.hintColor),
          dropdownColor: AppColors.inputFillColor,
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
          items: const [
            DropdownMenuItem(
              value: null,
              child: Text(
                'Forma de pago',
                style: AppTextStyles.hint,
                textAlign: TextAlign.center,
              ),
            ),
            DropdownMenuItem(
              value: 'EFECTIVO',
              child: Text('Efectivo', textAlign: TextAlign.center),
            ),
            DropdownMenuItem(
              value: 'TARJETA_CREDITO',
              child: Text('Tarjeta de Crédito', textAlign: TextAlign.center),
            ),
            DropdownMenuItem(
              value: 'TARJETA_DEBITO',
              child: Text('Tarjeta de Débito', textAlign: TextAlign.center),
            ),
            DropdownMenuItem(
              value: 'TRANSFERENCIA',
              child: Text('Transferencia', textAlign: TextAlign.center),
            ),
            DropdownMenuItem(
              value: 'CHEQUE',
              child: Text('Cheque', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

//--------------------EMISOR Y RECEPTOR--------------------
// Widget para secciones con título - FONDO AZUL CLARO
class SeccionConTitulo extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const SeccionConTitulo({
    super.key,
    required this.titulo,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE4F4EA), // ← FONDO AZUL CLARO
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE4F4EA), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 16),

          // Contenido de la sección
          ...children,
        ],
      ),
    );
  }
}

//--------------------INPUTS BLANCOS PARA EMISOR/RECEPTOR--------------------
// TextField especial para EMISOR y RECEPTOR - SOLO FONDO BLANCO
class CfdTextFieldBlanco extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;

  const CfdTextFieldBlanco({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: InputStyles.textStyle,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: InputStyles.hintStyle,
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
        fillColor: Colors.white, // ← SOLO ESTOS TIENEN FONDO BLANCO
        contentPadding: InputStyles.contentPadding,
        isDense: true,
      ),
    );
  }
}

//--------------------DATOS DEL PRODUCTO/SERVICIO--------------------

// Widget para la sección de Producto/Servicio
class ProductoServicioLayout extends StatelessWidget {
  final TextEditingController claveController;
  final TextEditingController cantidadController;
  final TextEditingController valorUnitarioController;
  final TextEditingController descripcionController;
  final TextEditingController tasaController;
  final String? unidadValue;
  final String? impuestoValue;
  final String? tipoValue;
  final List<String> unidades;
  final List<String> impuestos;
  final List<String> tipos;
  final Function(String?) onUnidadChanged;
  final Function(String?) onImpuestoChanged;
  final Function(String?) onTipoChanged;
  final VoidCallback onAgregar;
  final VoidCallback onEliminar;

  const ProductoServicioLayout({
    super.key,
    required this.claveController,
    required this.cantidadController,
    required this.valorUnitarioController,
    required this.descripcionController,
    required this.tasaController,
    required this.unidadValue,
    required this.impuestoValue,
    required this.tipoValue,
    required this.unidades,
    required this.impuestos,
    required this.tipos,
    required this.onUnidadChanged,
    required this.onImpuestoChanged,
    required this.onTipoChanged,
    required this.onAgregar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return SeccionConTitulo(
      titulo: 'DATOS DEL PRODUCTO / SERVICIO',
      children: [
        // Clave y Unidad en misma fila
        Row(
          children: [
            // Clave - SOLO NÚMEROS
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Clave', style: AppTextStyles.label),
                  TextField(
                    controller: claveController,
                    keyboardType: TextInputType.number, // ← SOLO NÚMEROS
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
            const SizedBox(width: 15),
            // Unidad (ComboBox) - MÁS PEQUEÑO VERTICALMENTE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Unidad', style: AppTextStyles.label),
                  Container(
                    // ↓↓↓ AQUÍ PUEDES CAMBIAR LA ALTURA DEL COMBOBOX ↓↓↓
                    height:
                        33, // ← CAMBIA ESTE VALOR PARA HACER MÁS PEQUEÑO (28, 26, etc.)
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        InputStyles.borderRadius,
                      ),
                      border: Border.all(color: AppColors.inputBorderColor),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ), // ← MENOS PADDING VERTICAL
                    alignment: Alignment.center,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: unidadValue,
                        onChanged: onUnidadChanged,
                        isExpanded: true,
                        style: InputStyles.textStyle.copyWith(fontSize: 12),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.hintColor,
                          size: 16,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        items: [
                          ...unidades.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: InputStyles.textStyle.copyWith(
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Cantidad y Valor Unitario en misma fila - ALINEADOS A LA IZQUIERDA
        Row(
          children: [
            // CANTIDAD - ancho fijo
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cantidad', style: AppTextStyles.label),
                  SizedBox(
                    height: 36,
                    child: TextField(
                      controller: cantidadController,
                      keyboardType: TextInputType.number,
                      style: InputStyles.textStyle.copyWith(fontSize: 12),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintStyle: InputStyles.hintStyle.copyWith(fontSize: 11),
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
                        contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // VALOR UNITARIO - ancho fijo
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Valor Unitario', style: AppTextStyles.label),
                  SizedBox(
                    height: 36,
                    child: TextField(
                      controller: valorUnitarioController,
                      keyboardType: TextInputType.number,
                      style: InputStyles.textStyle.copyWith(fontSize: 12),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintStyle: InputStyles.hintStyle.copyWith(fontSize: 11),
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
                        contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ESPACIO LIBRE - se expande
            Expanded(child: Container()),
          ],
        ),
        const SizedBox(height: 12),

        // Descripción en una sola línea
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción', style: AppTextStyles.label),
            CfdTextFieldBlanco(controller: descripcionController),
          ],
        ),
        const SizedBox(height: 12),

        // Impuesto, Tipo y Tasa en misma fila - TASA SIN DOBLE LÍNEA
        Row(
          children: [
            // Impuesto (ComboBox)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Impuesto', style: AppTextStyles.label),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        InputStyles.borderRadius,
                      ),
                      border: Border.all(color: AppColors.inputBorderColor),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    alignment: Alignment.center,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: impuestoValue,
                        onChanged: onImpuestoChanged,
                        isExpanded: true,
                        style: InputStyles.textStyle.copyWith(fontSize: 12),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.hintColor,
                          size: 16,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        items: [
                          ...impuestos.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: InputStyles.textStyle.copyWith(
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Tipo (ComboBox)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo', style: AppTextStyles.label),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        InputStyles.borderRadius,
                      ),
                      border: Border.all(color: AppColors.inputBorderColor),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    alignment: Alignment.center,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tipoValue,
                        onChanged: onTipoChanged,
                        isExpanded: true,
                        style: InputStyles.textStyle.copyWith(fontSize: 12),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.hintColor,
                          size: 16,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(
                          InputStyles.borderRadius,
                        ),
                        items: [
                          ...tipos.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: InputStyles.textStyle.copyWith(
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Tasa o Cuota - SIN DOBLE LÍNEA Y ALINEADO A LA IZQUIERDA
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tasa o Cuota', style: AppTextStyles.label),
                  SizedBox(
                    height: 30,
                    child: TextField(
                      controller: tasaController,
                      keyboardType: TextInputType.number,
                      style: InputStyles.textStyle.copyWith(fontSize: 12),
                      // ↓↓↓ ALINEADO A LA IZQUIERDA ↓↓↓
                      textAlign: TextAlign.left,
                      // ↓↓↓ ESTO EVITA LA DOBLE LÍNEA ↓↓↓
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: InputStyles.hintStyle.copyWith(fontSize: 11),
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
                        // ↓↓↓ PADDING CON MÁS ESPACIO A LA IZQUIERDA ↓↓↓
                        contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Botones + y x
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Botón +
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.successColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: onAgregar,
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 12),
            // Botón x
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.errorColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: onEliminar,
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//--------------------TABLA DE PRODUCTOS--------------------
class Producto {
  final String clave;
  final String cantidad;
  final String unidad;
  final String valorUnitario;
  final String importe;
  final String descripcion;
  final String impuesto;
  final String tipo;
  final String tasaCuota;
  final String importeImpuesto;

  Producto({
    required this.clave,
    required this.cantidad,
    required this.unidad,
    required this.valorUnitario,
    required this.importe,
    required this.descripcion,
    required this.impuesto,
    required this.tipo,
    required this.tasaCuota,
    required this.importeImpuesto,
  });
}

//--------------------TABLA DE PRODUCTOS--------------------
class TablaProductos extends StatelessWidget {
  final List<Producto> productos;
  final Function(int) onEliminar;

  const TablaProductos({
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
                  // Encabezado primera tabla
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _HeaderCell('Clave del Producto/Servicio', width: 150),
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
                            _DataCell(producto.clave, width: 150),
                            _DataCell(producto.cantidad, width: 80),
                            _DataCell(producto.unidad, width: 80),
                            _DataCell(
                              '\$${producto.valorUnitario}',
                              width: 100,
                            ),
                            _DataCell('\$${producto.importe}', width: 100),
                            _DataCell('', width: 80), // Espacio para alineación
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),

          // SEGUNDA TABLA - DESCRIPCIÓN E IMPUESTOS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: [
                  // Encabezado segunda tabla
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _HeaderCell('Descripción', width: 150),
                        _HeaderCell('Impuesto', width: 80),
                        _HeaderCell('Tipo', width: 80),
                        _HeaderCell('Tasa o Cuota', width: 100),
                        _HeaderCell('Importe', width: 100),
                        _HeaderCell('Acción', width: 80),
                      ],
                    ),
                  ),

                  // Filas segunda tabla
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
                            _DataCell(producto.descripcion, width: 150),
                            _DataCell(producto.impuesto, width: 80),
                            _DataCell(producto.tipo, width: 80),
                            _DataCell('${producto.tasaCuota}%', width: 100),
                            _DataCell(
                              '\$${producto.importeImpuesto}',
                              width: 100,
                            ),
                            Container(
                              width: 80,
                              padding: const EdgeInsets.all(4),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                onPressed: () => onEliminar(index),
                                padding: EdgeInsets.zero,
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

//--------------------BOTÓN GUARDAR CFDI--------------------
class GuardarCfdButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool disabled;

  const GuardarCfdButton({
    super.key,
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: disabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 20, 143, 75),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 15,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
