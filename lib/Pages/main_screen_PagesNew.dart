import 'package:atalaia_ar_condicionados_flutter_application/Pages/chatbot_widget.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/exit_page.dart';
import 'package:flutter/material.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/calculadora_page.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/home_page.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/localizacao_page.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/agenda_page.dart';
// import 'package:atalaia_ar_condicionados_flutter_application/Pages/place_form_screen.dart';

class MainScreen2 extends StatefulWidget {
  const MainScreen2({super.key});

  @override
  State<MainScreen2> createState() => _MainScreenState2();
}

class _MainScreenState2 extends State<MainScreen2> {
  int _selectedIndex = 0;

  // --- WIDGETS ORGANIZADOS POR ORDEM ---
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(), // 0. Início
    const ChatbotPage(), // 1. Assistente Virtual (Chatbot)
    const PlaceFormScreen(), // 2. Mapeamento de Locais
    const CalendarioLunarPage(), // 3. Calendário Lunar
    const LocalizacaoPage(), // 4. Contato
  ];

  // --- CORES DO PROJETO (MANTIDAS LOCALMENTE PARA ESTA TELA) ---
  final Color _verdePrincipal = const Color(0xFF27C5B2);
  final Color _pinkAccent = const Color(0xFFFFFC7A); // Amarelo/Rosa Destaque
  // A cor de fundo e darkText não são usadas neste widget, mas mantidas por contexto
  // final Color _lightPastelGreen = const Color(0xFFE6F7E1);
  // final Color _primaryTextColor = const Color(0xFF3C4E4B);

  // --- MAPEAMENTO DE ÍCONES AJUSTADO PARA O REDEVERDE ---
  static const List<Map<String, IconData>> _iconMap = [
    // 0: Início
    {'outlined': Icons.home_outlined, 'filled': Icons.home},
    // 1: Chatbot (Assistente Virtual)
    {'outlined': Icons.psychology_outlined, 'filled': Icons.psychology},
    // 2: Mapeamento de Áreas
    {
      'outlined': Icons.add_location_alt_outlined,
      'filled': Icons.add_location_alt,
    },
    // 3: Calendário Lunar
    {'outlined': Icons.nights_stay_outlined, 'filled': Icons.nights_stay},
    // 4: Contato
    {
      'outlined': Icons.contact_support_outlined,
      'filled': Icons.contact_support,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return _iconMap.asMap().entries.map((entry) {
      final index = entry.key;
      final iconSet = entry.value;

      const double defaultSize = 24.0;
      const double selectedSize = 30.0;

      return BottomNavigationBarItem(
        icon: Icon(
          index == _selectedIndex ? iconSet['filled'] : iconSet['outlined'],
          size: index == _selectedIndex ? selectedSize : defaultSize,
        ),
        label: _getLabel(index),
      );
    }).toList();
  }

  // --- RÓTULOS AJUSTADOS PARA AS FUNCIONALIDADES ---
  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Início';
      case 1:
        return 'Assistente';
      case 2:
        return 'Mapear';
      case 3:
        return 'Calendário';
      case 4:
        return 'Contato';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cor selecionada: Rosa Destaque (ou Amarelo)
    final Color selectedColor = _pinkAccent;
    // Cor não selecionada: Branco
    final Color unselectedColor = Colors.white;

    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      // --- BottomNavigationBar ---
      bottomNavigationBar: Container(
        child: ClipRRect(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // FUNDO: Verde Principal
            backgroundColor: _verdePrincipal,
            items: _buildNavItems(),

            currentIndex: _selectedIndex,
            // Selecionado: Rosa/Amarelo Destaque
            selectedItemColor: selectedColor,
            // Não Selecionado: Branco
            unselectedItemColor: unselectedColor,

            // Mantido em false para a estética compacta
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
