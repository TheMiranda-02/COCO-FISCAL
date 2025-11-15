import 'package:flutter/material.dart';
import 'Estilos/diseños_Chatbot.dart';
import 'Apartado_C_CF.dart'; // Importa ApartadoCCF

class ChatbotCoco extends StatefulWidget {
  const ChatbotCoco({Key? key}) : super(key: key);

  @override
  _ChatbotCocoState createState() => _ChatbotCocoState();
}

class _ChatbotCocoState extends State<ChatbotCoco> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Respuestas predefinidas del chatbot - ACTUALIZADO CON CONVERSACIÓN FISCAL
  final Map<String, String> _botResponses = {
    'hola':
        '¡Hola! Soy Cocó, tu asistente fiscal. ¿En qué puedo ayudarte con tus temas fiscales hoy?',
    'como estas':
        '¡Estoy muy bien, gracias por preguntar! Listo para ayudarte con tus dudas fiscales.',
    'que puedes hacer':
        'Puedo orientarte sobre temas fiscales como RFC, facturación, declaraciones, impuestos y más.',
    'adios':
        '¡Hasta luego! Que tengas excelentes declaraciones. ¡Vuelve pronto!',
    'gracias':
        '¡De nada! Recuerda que para casos específicos siempre es mejor consultar con un contador profesional.',

    // Conversación fiscal
    'rfc':
        'El RFC (Registro Federal de Contribuyentes) es tu identificación fiscal en México. Es obligatorio para personas físicas y morales que realicen actividades económicas.',
    'factura':
        'Una factura es un documento digital que comprueba una operación comercial. Debe incluir tu RFC, datos del cliente, descripción de lo vendido y los impuestos correspondientes.',
    'declarar':
        'Las personas físicas declaran en abril (anual) y mensualmente si tienen actividades empresariales. Las empresas declaran mensualmente.',
    'iva':
        'El IVA (Impuesto al Valor Agregado) es del 16% y se aplica sobre la venta de bienes y servicios. Debes enterarlo mensualmente al SAT.',
    'freelance':
        'Sí, como freelance estás obligado a facturar tus honorarios y declarar tus ingresos ante el SAT cada mes.',
    'deducir':
        'Puedes deducir: honorarios médicos, gastos funerarios, intereses hipotecarios, donativos, transporte escolar y colegiaturas, entre otros.',
    'multa':
        'El SAT puede imponer multas, recargos y actualizaciones por no declarar. En casos graves, puede haber consecuencias legales.',
    'facturar':
        'Necesitas tu e.firma, acceder al portal del SAT y generar tus CFDI (Comprobantes Fiscales Digitales por Internet).',
    'isr':
        'El ISR (Impuesto Sobre la Renta) grava tus ingresos. Las tasas varían según tu nivel de ingresos y se paga anualmente o mensualmente.',
    'régimen':
        'Es la categoría bajo la cual tributas. Los comunes son: Sueldos, Arrendamiento, Actividades Empresariales y Servicios Profesionales.',
    'regimen':
        'Depende de tu actividad principal. Te recomiendo consultar con un contador para elegir el régimen fiscal más conveniente.',
    'documentos':
        'Necesitas: facturas de ingresos y gastos, recibos de nómina, estados de cuenta, y formatos informativos del SAT.',
    'efirma':
        'La e.firma (antes FIEL) es tu firma electrónica avanzada que te identifica ante el SAT para trámites en línea.',
    'sat':
        'El SAT (Servicio de Administración Tributaria) es la autoridad fiscal en México que se encarga de la recaudación de impuestos.',
    'impuesto':
        'Los impuestos principales son ISR, IVA e IEPS. Cada uno tiene diferentes tasas y aplicaciones según tu actividad.',
    'contador':
        'Te recomiendo consultar con un contador profesional para casos específicos de tu situación fiscal.',
    'obligaciones':
        'Tus obligaciones fiscales incluyen: darte de alta en el RFC, expedir comprobantes fiscales, declarar impuestos y llevar contabilidad.',
    'contabilidad':
        'La contabilidad es el registro organizado de tus operaciones comerciales. Es obligatoria para personas morales y físicas con actividades empresariales.',
  };

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Agregar mensaje del usuario
    setState(() {
      _messages.add(
        Message(text: text.trim(), isUser: true, timestamp: DateTime.now()),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // Simular respuesta del bot después de un breve delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _getBotResponse(text.trim().toLowerCase());
    });
  }

  void _getBotResponse(String userMessage) {
    String response =
        'Lo siento, no entendí eso. ¿Podrías intentar con otra pregunta?';

    // Buscar respuesta en el mapa
    for (var key in _botResponses.keys) {
      if (userMessage.contains(key)) {
        response = _botResponses[key]!;
        break;
      }
    }

    setState(() {
      _messages.add(
        Message(text: response, isUser: false, timestamp: DateTime.now()),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: Container(
        color: const Color(0xFFE8F5E9), // Color verde del AppBar de fondo
        child: Column(
          children: [
            // Área de mensajes con bordes redondeados
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                ), // Espacio desde el AppBar
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: _messages.isEmpty
                    ? _buildEmptyChat()
                    : _buildMessageList(),
              ),
            ),

            // Área de entrada de texto
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // AppBar personalizado con flecha de retroceso
  AppBar _buildCustomAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ApartadoCCF(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);
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
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
      ),
      title: Row(
        children: [
          SizedBox(width: 85),
          Text(
            'Cocó-Bot',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFE8F5E9), // F
      elevation: 0,
      scrolledUnderElevation: 0, // ← AGREGA ESTA LÍNEA
      surfaceTintColor: Colors.transparent, // ← AGREGA ESTA LÍNEA
      actions: [],
    );
  }

  Widget _buildEmptyChat() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight, // Alinea a la derecha
              child: Padding(
                padding: const EdgeInsets.only(right: 95), // Ajusta este valor
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/IconoBot.png',
                    width: 170,
                    height: 170,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return MessageBubble(message: _messages[index]);
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Campo de texto
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Botón de enviar con imagen
          GestureDetector(
            onTap: () => _sendMessage(_messageController.text),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Image.asset(
                'assets/images/EnviarB.png', // ← Tu imagen aquí
                width: 24,
                height: 24,
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ), // Opcional: para cambiar color
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.send, color: Colors.white, size: 20);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
