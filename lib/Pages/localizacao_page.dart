import 'package:atalaia_ar_condicionados_flutter_application/Pages/login_page.dart';
import 'package:flutter/material.dart';
// IMPORTANTE: Descomente esta linha para as funções de link funcionarem
import 'package:url_launcher/url_launcher.dart';

// Definindo as cores do projeto RedeVerde/Pastel
class AppColors {
  static const Color primaryColor = Color(0xFF27C5B2); // Verde Principal
  static const Color accentColor = Color(0xFFFC7ACF); // Rosa Destaque
  static const Color lightPastelGreen = Color(0xFFE6F7E1); // Fundo Pastel
  static const Color darkText = Color(
    0xFF3C4E4B,
  ); // Cor escura para texto principal
}

class LocalizacaoPage extends StatelessWidget {
  const LocalizacaoPage({super.key});

  // --- DADOS DA EMPRESA REDEVERDE ---
  final String _redeVerdeAddress =
      'Rua das Folhas, 55 - Jardim da Colheita, São Paulo - SP';
  final String _redeVerdePhone = '+5511959473402';
  final String _redeVerdeEmail = 'contato@redeverde.com.br';
  final String _redeVerdeInstagram =
      'https://www.instagram.com/RedeVerdeOficial'; // Exemplo de Link do Instagram

  // --- FUNÇÕES DE AÇÃO ---

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o link: ${url.path}')),
      );
    }
  }

  void _launchMaps(BuildContext context) {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_redeVerdeAddress)}',
    );
    _launchUrl(context, url);
  }

  void _launchPhone(BuildContext context) {
    final Uri url = Uri.parse('tel:$_redeVerdePhone');
    _launchUrl(context, url);
  }

  void _launchEmail(BuildContext context) {
    final Uri url = Uri.parse('mailto:$_redeVerdeEmail');
    _launchUrl(context, url);
  }

  // NOVA FUNÇÃO: Abrir Instagram
  void _launchInstagram(BuildContext context) {
    final Uri url = Uri.parse(_redeVerdeInstagram);
    _launchUrl(context, url);
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: AppColors.darkText)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.darkText.withOpacity(0.7)),
      ),
      onTap: onTap,
      // Ícone de seta em cor escura
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.darkText.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo em Verde Pastel Claro
      backgroundColor: AppColors.lightPastelGreen,
      appBar: AppBar(
        title: const Text('Localização e Contato'),
        // AppBar em Verde Principal
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seção 1: Texto Introdutório
              Text(
                'Bem-vindo à nossa Comunidade Verde! Visite-nos ou entre em contato com nosso Garden Central.',
                textAlign: TextAlign.center,
                // Texto em cor escura
                style: TextStyle(fontSize: 16, color: AppColors.darkText),
              ),
              const SizedBox(height: 24),

              // Seção 2: Informações de Contato (Interativo)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.location_on,
                      title: 'Endereço',
                      subtitle: _redeVerdeAddress,
                      onTap: () => _launchMaps(context),
                      color: AppColors.primaryColor, // Verde Destaque
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                      color: Colors.black12,
                    ),
                    _buildListTile(
                      icon: Icons.phone,
                      title: 'Telefone (WhatsApp)',
                      subtitle: '(11) 95947-3402',
                      onTap: () => _launchPhone(context),
                      color: AppColors.accentColor, // Rosa Destaque
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                      color: Colors.black12,
                    ),
                    _buildListTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: _redeVerdeEmail,
                      onTap: () => _launchEmail(context),
                      color: AppColors.primaryColor, // Verde Destaque
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // SEÇÃO 3: REDES SOCIAIS (NOVA)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Conecte-se conosco',
                        // Texto em cor escura
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                    _buildListTile(
                      // Usando um ícone genérico que sugere redes sociais
                      icon: Icons.person_pin_circle_sharp,
                      title: 'Instagram Oficial',
                      subtitle: '@RedeVerdeOficial',
                      onTap: () => _launchInstagram(context),
                      color: AppColors.accentColor, // Rosa Destaque
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Seção 4: Logout (Estilizado)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.logout, color: AppColors.accentColor),
                          const SizedBox(width: 12),
                          Text(
                            "Encerrar Sessão",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.darkText, // Texto em cor escura
                            ),
                          ),
                        ],
                      ),
                      // ... (Botão Sair)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          // Botão Sair em Rosa Destaque
                          backgroundColor: AppColors.accentColor,
                          foregroundColor:
                              Colors.white, // Texto Branco para contraste
                        ),
                        child: const Text("Sair"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
