import 'package:flutter/material.dart';

// Clase Message definida aquí para que esté disponible en ambos archivos
class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, required this.timestamp});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF128C7E),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFFDCF8C6) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: message.isUser
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: message.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF128C7E),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class ChatbotDesigns {
  // Método para construir el área de entrada de mensajes
  static Widget buildMessageInputArea({
    required TextEditingController controller,
    required Function(String) onSendMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Botón de emoji
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          const SizedBox(width: 8),

          // Campo de texto
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: onSendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Botón de enviar con imagen
          GestureDetector(
            onTap: () => onSendMessage(controller.text),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF128C7E),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Image.asset(
                'assets/images/EnviarB.png', // ← Misma imagen
                width: 24,
                height: 24,
                color: const Color.fromARGB(255, 236, 223, 223),
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

  // Método para construir el estado vacío del chat
  static Widget buildEmptyChatState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF128C7E),
            child: Icon(Icons.smart_toy, color: Colors.white, size: 40),
          ),
          SizedBox(height: 16),
          Text(
            '¡Hola! Soy Coco, tu asistente virtual',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            '¿En qué puedo ayudarte hoy?',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Método para construir la lista de mensajes
  static Widget buildMessageListView({
    required List<Message> messages,
    required ScrollController scrollController,
  }) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(message: messages[index]);
      },
    );
  }
}

// Estilos para el tema del chatbot
class ChatbotStyles {
  static const Color primaryColor = Color(0xFF128C7E);
  static const Color secondaryColor = Color(0xFF25D366);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color userBubbleColor = Color(0xFFDCF8C6);
  static const Color botBubbleColor = Colors.white;

  static const TextStyle messageTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static TextStyle timestampTextStyle(Color? color) =>
      TextStyle(fontSize: 10, color: color ?? Colors.grey[600]);

  static BoxDecoration get chatBackground =>
      const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255));
}
