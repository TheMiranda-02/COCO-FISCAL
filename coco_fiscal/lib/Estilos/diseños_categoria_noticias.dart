import 'package:flutter/material.dart';

class CategoriaNoticiasDesigns {
  static AppBar buildAppBar({required String titulo}) {
    return AppBar(
      toolbarHeight: 60,
      title: Row(
        children: [
          Text(
            "Categoria 1", // ← Título dinámico según la categoría
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
      actions: [],
    );
  }

  // TARJETA DE NOTICIA SIMPLE (solo imagen y título)
  static Widget buildTarjetaNoticia({
    required String titulo,
    required String imagen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Sin bordes, sin sombras, sin efectos
        ),
        child: Column(
          children: [
            // IMAGEN
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.article, size: 40, color: Colors.blue),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8),

            // TÍTULO
            Text(
              titulo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO ALTERNATIVO SI PREFIERES USAR GridView
  static Widget buildGridNoticias({
    required List<Map<String, dynamic>> noticias,
    required Function(int) onNoticiaTap,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: noticias.length,
      itemBuilder: (context, index) {
        return buildTarjetaNoticia(
          titulo: noticias[index]['titulo'],
          imagen: noticias[index]['imagen'],
          onTap: () => onNoticiaTap(index),
        );
      },
    );
  }
}
