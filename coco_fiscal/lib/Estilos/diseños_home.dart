import 'package:flutter/material.dart';
import '../form_crear_cfdi.dart'; // ← AGREGAR ESTE IMPORT
import '../Perfil_Usuario.dart';
import '../Splash_Coco_Fiscal.dart';
import '../Noticias/glosario_general.dart';
import '../Capacitacion_fiscal/listas_asesores.dart';
import '../screens/dashboard_tareas.dart';

class HomeDesigns {
  static AppBar buildAppBar(BuildContext context) {
    // ← AGREGAR context como parámetro
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      title: Row(
        children: [
          Image.asset(
            'assets/images/Coco_Icono.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.account_balance, size: 30);
            },
          ),
          SizedBox(width: 15),
          Text(
            'COCO FISCAL',
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            // ← CAMBIAR IconButton por GestureDetector
            onTap: () {
              // Navegar a Perfil_Usuario.dart
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PerfilUsuario(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                  transitionDuration: Duration(milliseconds: 300),
                ),
              );
            },
            child: Container(
              // ← CONTENEDOR CON IMAGEN CIRCULAR
              width: 20,
              height: 20,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Perfil.png', // ← Tu imagen de perfil
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // MÓDULO DE ANALISIS DE PROGRSO
  static Widget buildImageModule({
    required String imagePath,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height, // Altura que tú defines
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Imagen no disponible'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //MODULO PARA OBLIGACIONES
  static Widget buildImageModule1({
    required String imagePath,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height, // Altura que tú defines
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Imagen no disponible'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //MODULO PARA Gráfica de ingresos y egresos
  static Widget buildImageModule2({
    required String imagePath,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height, // Altura que tú defines
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Imagen no disponible'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //MODULO PARA Gráfica de ingresos y egresos
  static Widget buildImageModule3({
    required String imagePath,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height, // Altura que tú defines
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(0, 255, 255, 255),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  SizedBox(height: 10),
                  Text('Imagen no disponible'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //MODULO PARA NOTIFICACIONES RECIENTES
  static Widget buildImageModule4({
    required String imagePath,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height, // Altura que tú defines
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Imagen no disponible'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // MÓDULO PARA ACCESOS RÁPIDOS
  static Widget buildAccesosRapidos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(
          'Accesos Rápidos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Registrar CFDI
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormCrearCFDIScreen(),
                  ),
                );
              },
              child: _buildAccesoRapido(
                'Registrar CFDI',
                'assets/images/Miranda.png',
                width: 80,
                height: 80,
              ),
            ),

            // Nuevo Recordatorio
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormCrearCFDIScreen(),
                  ),
                );
              },
              child: _buildAccesoRapido(
                'Nuevo Recordatorio',
                'assets/images/Miranda.png',
                width: 80,
                height: 80,
              ),
            ),

            // Consultar Asesor
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListasAsesoresPage()),
                );
              },
              child: _buildAccesoRapido(
                'Consultar Asesor',
                'assets/images/Miranda.png',
                width: 80,
                height: 80,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Segunda fila - 2 imágenes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Generar Reporte
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardTareas()),
                );
              },
              child: _buildAccesoRapido(
                'Generar Reporte',
                'assets/images/Miranda.png',
                width: 80,
                height: 80,
              ),
            ),
            SizedBox(width: 20),

            // Asistente Virtual
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashCocoFiscal()),
                );
              },
              child: _buildAccesoRapido(
                'Asistente Virtual',
                'assets/images/Miranda.png',
                width: 80,
                height: 80,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget individual para cada acceso rápido
  static Widget _buildAccesoRapido(
    String texto,
    String imagenPath, {
    double width = 90,
    double height = 90,
  }) {
    return Column(
      children: [
        Container(
          width: width, // ← TAMAÑO PERSONALIZABLE
          height: height, // ← TAMAÑO PERSONALIZABLE
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagenPath, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 8),
        Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  static Widget buildGlosarioTerminos(BuildContext context) {
    final List<Map<String, String>> terminos = [
      {
        'titulo': 'Planeación financiera',
        'descripcion':
            'Estrategia para alcanzar metas economicas a corto y largo plazo.',
        'imagen': 'assets/images/Miranda.png',
      },
      {
        'titulo': 'Autoseguro',
        'descripcion':
            'Esquema en el que los trabajadores independientes se incriben...',
        'imagen': 'assets/images/Prueba1.png',
      },
      {
        'titulo': 'Alta en el SAT',
        'descripcion':
            'Trámite inicial para registrarte oficialmente como contribuyente y poder...',
        'imagen': 'assets/images/Prueba2.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ENCABEZADO MODIFICADO - TÍTULO EN DOS LÍNEAS CON BOTÓN IMAGEN
        Container(
          width: double.infinity, // ← FORZAR ANCHO COMPLETO
          child: Stack(
            alignment: Alignment.topCenter, // ← ALINEACIÓN CENTRAL
            children: [
              // TÍTULO EN DOS LÍNEAS (ALINEADO A LA IZQUIERDA)
              Align(
                alignment: Alignment.topLeft, // ← ALINEAR TEXTO A LA IZQUIERDA
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Glosario de',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Términos Fiscales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // BOTÓN IMAGEN EN FONDO DERECHO
              Positioned(
                top: 0,
                right: 10, // ← PEGADO AL EXTREMO DERECHO
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            GlosarioGeneralScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/boton_glosario.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.green,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Tarjetas del glosario
        Column(
          children: terminos.asMap().entries.map((entry) {
            final index = entry.key;
            final termino = entry.value;
            final imagenALaDerecha = index % 2 == 0;

            return Column(
              children: [
                _buildTarjetaGlosarioMejorada(
                  context: context,
                  titulo: termino['titulo']!,
                  descripcion: termino['descripcion']!,
                  imagen: termino['imagen']!,
                  imagenALaDerecha: imagenALaDerecha,
                ),
                if (index < terminos.length - 1) SizedBox(height: 15),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // TARJETA MEJORADA CON IMAGEN REDONDA QUE SE CORTA
  static Widget _buildTarjetaGlosarioMejorada({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required String imagen,
    required bool imagenALaDerecha,
  }) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // CONTENIDO DE TEXTO - POSICIÓN AJUSTADA SEGÚN LADO
          Positioned(
            top: 0,
            bottom: 0,
            left: imagenALaDerecha ? 0 : null,
            right: !imagenALaDerecha ? 0 : null,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.55,
              padding: EdgeInsets.all(16),
              child: _buildContenidoTexto(
                titulo: titulo,
                descripcion: descripcion,
                moverBotonDerecha:
                    !imagenALaDerecha, // ← BOTÓN DERECHA CUANDO IMAGEN IZQUIERDA
              ),
            ),
          ),

          // IMAGEN REDONDA QUE SE CORTA HACIA AFUERA
          Positioned(
            top: 10,
            bottom: -40,
            right: imagenALaDerecha ? -22 : null,
            left: !imagenALaDerecha ? -24 : null,
            child: Container(
              width: 170,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: ClipOval(
                child: Image.asset(
                  imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.description,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CONTENIDO DE TEXTO SEPARADO - BOTÓN MÁS PEQUEÑO CON ALINEACIÓN
  static Widget _buildContenidoTexto({
    required String titulo,
    required String descripcion,
    bool moverBotonDerecha = false, // ← NUEVO PARÁMETRO
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ← SIEMPRE IZQUIERDA
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Título (siempre a la izquierda)
        Text(
          titulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 6),

        // Descripción (siempre a la izquierda)
        Text(
          descripcion,
          style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.3),
        ),
        SizedBox(height: 10),

        // Botón "Conocer más" - CON MARGEN DERECHO
        Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: moverBotonDerecha
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 32,
                margin: moverBotonDerecha
                    ? EdgeInsets.only(right: 22) // ← AJUSTA ESTE VALOR (0-40)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextButton(
                  onPressed: () {
                    // TODO: Navegar a detalle del término
                  },
                  child: Text(
                    'Conocer más',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildPreguntasFrecuentes(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          const Text(
            'Preguntas Frecuentes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF468C62),
            ),
          ),
          const SizedBox(height: 20),

          // Aquí va el contenido del acordeón
          PreguntasAcordeon(),
        ],
      ),
    );
  }
}

// Widget del acordeón de preguntas - FUERA de la clase HomeDesigns
class PreguntasAcordeon extends StatefulWidget {
  @override
  PreguntasAcordeonState createState() => PreguntasAcordeonState();
}

class PreguntasAcordeonState extends State<PreguntasAcordeon> {
  int? _preguntaSeleccionada;

  final List<Map<String, dynamic>> _preguntas = [
    {
      'titulo': '¿Cómo puedo obtener mi RFC si soy nuevo contribuyente?',
      'contenido':
          'Puedes tramitar tu RFC (Registro Federal de Contribuyentes) directamente en el portal del SAT, para ello es necesario solicitar una cita en citas.sat.gob.mx. El trámite es gratuito y los requisitos son:\n\n• Acta de nacimiento (copia certificada)\n• CURP\n• Identificación oficial vigente (INE, pasaporte, cédula profesional, entre otras)\n• Comprobante de domicilio (recibo de servicios de luz, gas, TV de paga, entre otros)',
    },
    {
      'titulo': '¿Qué pasa si no presento mi declaración mensual?',
      'contenido':
          'Si no presentas tu declaración, el SAT puede considerarte como incumplido y aplicarte multas o recargos por cada mes de atraso. Además, podrías perder ciertos beneficios fiscales. Lo mejor es cumplir cada mes en tiempo, aunque no hayas tenido ingresos, para mantener tu situación fiscal al día.',
    },
    {
      'titulo': '¿Por qué es importante presentar mi declaración provisional?',
      'contenido':
          'Con las declaraciones provisionales el SAT puede saber cuánto ganaste y cuánto debes pagar de impuestos cada mes. Presentarlas a tiempo te ayuda a mantener tus obligaciones al día, evitar multas y tener control sobre tus finanzas. Además, cuando llega el momento de hacer tu declaración anual, todo será más sencillo porque ya tendrás tu información organizada.',
    },
    {
      'titulo': '¿Si no tuve ingresos este mes, igual debo declarar?',
      'contenido':
          'Sí. Aunque no hayas obtenido ingresos ni emitido facturas, es importante presentar tu declaración en ceros. Esto le informa al SAT que sigues activo, pero sin actividad económica, y te evita multas o bloqueos en tu cuenta fiscal.',
    },
    {
      'titulo':
          '¿Qué diferencias hay entre el Régimen de Actividad Empresarial y RESICO?',
      'contenido':
          'El Régimen Simplificado de Confianza (RESICO) está diseñado para personas físicas que perciben ingresos anuales menores a 3.5 millones de pesos y ofrece tasas de impuestos más bajas, así como trámites más simples. Por otro lado, el Régimen de Actividad Empresarial se orienta a las personas que realizan actividades profesionales, comerciales, industriales, de autotransporte, agrícolas, ganaderas, pesqueras o silvícolas, sin importar el total de los ingresos que perciben.',
    },
    {
      'titulo': '¿Qué hago si cometí un error en mi declaración?',
      'contenido':
          'No te preocupes. Puedes corregirlo presentando una declaración complementaria en el mismo portal del SAT. Solo asegúrate de marcar la opción correcta (por ejemplo, "Modificación de obligaciones") y actualizar la información que cambió. Lo importante es hacerlo cuanto antes para evitar recargos.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_preguntas.length, (index) {
        final bool isSelected = _preguntaSeleccionada == index;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            // La línea inferior SOLO aparece cuando NO está seleccionado
            border: isSelected
                ? null
                : Border(
                    bottom: BorderSide(color: Color(0xFF326045), width: 2),
                  ),
          ),
          child: Column(
            children: [
              // Título de la pregunta (siempre visible)
              Material(
                color: isSelected ? Color(0xFF58AC7A) : Colors.transparent,
                borderRadius: isSelected
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      )
                    : BorderRadius.circular(4),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_preguntaSeleccionada == index) {
                        _preguntaSeleccionada = null;
                      } else {
                        _preguntaSeleccionada = index;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _preguntas[index]['titulo'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Color(0xFF326045),
                            ),
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.expand_less : Icons.expand_more,
                          color: isSelected ? Colors.white : Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Contenido expandido con fondo blanco
              if (isSelected)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    _preguntas[index]['contenido'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
