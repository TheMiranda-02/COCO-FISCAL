import 'package:flutter/material.dart';

class AnimatedSplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const AnimatedSplashScreen({super.key, required this.onAnimationComplete});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 7500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Iniciar animación
    _controller.forward();

    // Escuchar cuando la animación termina
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Esperar un momento y luego llamar al callback
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onAnimationComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/FondoA.png', // 👈 tu imagen de fondo
            fit: BoxFit.cover,
          ),
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/Logo.png', // 👈 tu logo animado
                width: 300,
                height: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
