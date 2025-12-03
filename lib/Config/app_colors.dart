import 'package:flutter/material.dart';

class AppColors {
  // Cor Primária Principal (para botões, ícones e destaques)
  static const Color primaryColor = Color(
    0xFF0D47A1,
  ); // Um azul escuro e profissional

  // Cor de Fundo das Páginas
  static const Color backgroundColorPages = Color(
    0xFFF5F5F5,
  ); // Um cinza bem claro (melhor que DADADA para leitura)

  // Cor de Fundo da AppBar (geralmente branco ou a cor primária)
  static const Color backgroundColorAppBar = Colors.white;

  // --- Cores para a Barra de Navegação (BottomNavigationBar) ---

  // Cor do ícone/texto selecionado
  static const Color selectedItemColor = Color(
    0xFF343B6C,
  ); // Um azul mais sóbrio que já estava em uso

  // Cor do ícone/texto não selecionado
  static const Color unselectedItemColor = Colors.grey;
}
