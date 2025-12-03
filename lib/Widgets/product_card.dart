// lib/Widgets/product_card.dart

import 'package:flutter/material.dart';

// --- WIDGET PRINCIPAL: ProductCard ---
class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String price;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos InkWell para tornar o card inteiro clicável e dar feedback visual
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Colors.black54),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price, // Exibe o texto do botão/preço (Acessar, Explorar, etc.)
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  // Botão de Ação: Só exibe se houver um onTap definido
                  if (onTap != null)
                    ElevatedButton(
                      onPressed: onTap,
                      // Aqui, o texto do botão é genérico 'Acessar'
                      child: Text(price == 'Comunidade' ? 'Ver Grupo' : 'Acessar'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET AUXILIAR: ProductMiniCard (Para o Carrossel) ---
class ProductMiniCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback? onTap; // Adicionado para ser clicável

  const ProductMiniCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Usamos InkWell para tornar o mini card clicável
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Colors.black54),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}