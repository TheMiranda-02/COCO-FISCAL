import 'package:flutter/material.dart';
import 'info_detalle.dart';

class TerminoDetalleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          children: [
            Text(
              'Todo sobre RESICO',
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TARJETAS ESTILO GLOSARIO (10 TARJETAS)
            _buildTarjetasTermino(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetasTermino(BuildContext context) {
    final List<Map<String, String>> terminosDetalle = [
      {
        'titulo': 'RESICO',
        'descripcion':
            'Régimen Simplificado de Confianza, opción fiscal con tasas bajas de impuestos para personas físicas.',
        'imagen': 'assets/images/Miranda.png',
      },
      {
        'titulo': 'Ingresos acumulables',
        'descripcion':
            'Todo el dinero que recibes por tus actividades y que debe declararse al SAT.',
        'imagen': 'assets/images/Prueba1.png',
      },
      {
        'titulo': 'Pagos mensuales',
        'descripcion':
            'Declaraciones donde informas tus ingresos del mes y pagas tus impuestos correspondientes.',
        'imagen': 'assets/images/Prueba2.png',
      },
      {
        'titulo': 'IVA',
        'descripcion':
            'Impuesto al Valor Agregado, que se aplica al vender bienes o prestar servicios.',
        'imagen': 'assets/images/Miranda.png',
      },
      {
        'titulo': 'ISR',
        'descripcion':
            'Impuesto Sobre la Renta, que se paga según los ingresos obtenidos.',
        'imagen': 'assets/images/Prueba1.png',
      },
      {
        'titulo': 'Comprobantes fiscales',
        'descripcion':
            'Facturas que demuestran tus operaciones y permiten deducir gastos.',
        'imagen': 'assets/images/Prueba2.png',
      },
      {
        'titulo': 'Declaración anual',
        'descripcion': 'Resumen de todos los ingresos y pagos del año fiscal',
        'imagen': 'assets/images/Miranda.png',
      },
      {
        'titulo': 'Retenciones',
        'descripcion':
            'Cantidades que tus clientes o el SAT descuentan de tus pagos por concepto de impuestos.',
        'imagen': 'assets/images/Prueba1.png',
      },
      {
        'titulo': 'Beneficio fiscal',
        'descripcion':
            'Ventaja que reduce el pago de impuestos, como tasas preferenciales o deducciones.',
        'imagen': 'assets/images/Prueba2.png',
      },
      {
        'titulo': 'Buzón tributario',
        'descripcion':
            'Plataforma en línea del SAT para recibir notificaciones y mensajes oficiales.',
        'imagen': 'assets/images/Miranda.png',
      },
    ];

    return Column(
      children: terminosDetalle.asMap().entries.map((entry) {
        final index = entry.key;
        final termino = entry.value;

        // Alternar diseño: 0=derecha, 1=izquierda, 2=derecha, etc.
        final imagenALaDerecha = index % 2 == 0;

        return Column(
          children: [
            _buildTarjetaTerminoDetalle(
              context: context,
              titulo: termino['titulo']!,
              descripcion: termino['descripcion']!,
              imagen: termino['imagen']!,
              imagenALaDerecha: imagenALaDerecha,
              index: index,
            ),
            if (index < terminosDetalle.length - 1) SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  // TARJETA PARA DETALLE DE TÉRMINO
  Widget _buildTarjetaTerminoDetalle({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required String imagen,
    required bool imagenALaDerecha,
    required int index,
  }) {
    return Container(
      width: double.infinity,
      height: 180,
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
          // CONTENIDO DE TEXTO
          Positioned(
            top: 0,
            bottom: 0,
            left: imagenALaDerecha ? 0 : null,
            right: !imagenALaDerecha ? 0 : null,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.all(16),
              child: _buildContenidoTermino(
                context: context, // ← AGREGAR context AQUÍ
                titulo: titulo,
                descripcion: descripcion,
                imagenALaDerecha: imagenALaDerecha,
                index: index,
              ),
            ),
          ),

          // IMAGEN REDONDA
          Positioned(
            top: 20,
            bottom: 15,
            right: imagenALaDerecha ? -35 : null,
            left: !imagenALaDerecha ? -35 : null,
            child: Container(
              width: 150,
              height: 150,
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

  // CONTENIDO DEL TÉRMINO
  Widget _buildContenidoTermino({
    required BuildContext context, // ← AGREGAR PARÁMETRO context
    required String titulo,
    required String descripcion,
    required bool imagenALaDerecha,
    required int index,
  }) {
    // DETERMINAR MARGEN SEGÚN POSICIÓN DE LA IMAGEN
    final EdgeInsets marginBoton = imagenALaDerecha
        ? EdgeInsets.only(
            right: 25,
          ) // TARJETAS DERECHAS: BOTÓN MÁS A LA IZQUIERDA
        : EdgeInsets.only(
            left: 12,
          ); // TARJETAS IZQUIERDAS: BOTÓN MÁS A LA DERECHA

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Título
        Text(
          titulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        SizedBox(height: 8),

        // Descripción
        Text(
          descripcion,
          style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),

        // BOTÓN - TODOS FUNCIONAN
        Container(
          width: 120,
          height: 32,
          margin: marginBoton, // MARGEN AJUSTABLE
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextButton(
            onPressed: () {
              _manejarAccionBoton(
                context,
                titulo,
                index,
              ); // ← AHORA context ESTÁ DISPONIBLE
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
    );
  }

  // MÉTODO PARA MANEJAR LAS ACCIONES DE LOS BOTONES
  void _manejarAccionBoton(BuildContext context, String titulo, int index) {
    // COMPORTAMIENTO ESPECÍFICO SEGÚN EL BOTÓN
    switch (titulo) {
      case 'Ingresos acumulables':
        // SOLO ESTE BOTÓN REDIRECCIONA SIN SNACKBAR
        print('🔗 REDIRIGIENDO: $titulo');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoDetalleScreen()),
        );
        break;

      default:
        break;
    }
  }
}
