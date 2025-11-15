import 'package:flutter/material.dart';

class SeguridadPrivacidad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        toolbarHeight: 60,
        title: Row(
          children: [
            Text(
              'Seguridad y Privacidad',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/OnboardingF.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
