import 'package:flutter/material.dart';
import 'Chatbot_Coco.dart';

class SplashCocoFiscal extends StatefulWidget {
  const SplashCocoFiscal({Key? key}) : super(key: key);

  @override
  State<SplashCocoFiscal> createState() => _SplashCocoFiscalState();
}

class _SplashCocoFiscalState extends State<SplashCocoFiscal> {
  void _irAChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatbotCoco()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FONDO QUE ABARCA TODA LA PANTALLA
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ChatBotCoco.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // BOTÓN POSICIONABLE
          Positioned(
            left: 70, // Ajusta el margen izquierdo
            top: 670, // Ajusta el margen superior
            child: GestureDetector(
              onTap: _irAChatbot,
              child: Image.asset(
                'assets/images/btnCocó.png',
                width: 250,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Pregúntale a Cocó',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
