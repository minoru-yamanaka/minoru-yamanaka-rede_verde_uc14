import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // NECESSÁRIO para abrir links
import 'package:atalaia_ar_condicionados_flutter_application/Widgets/product_card.dart';

// Chave global para acesso ao contexto do ScaffoldMessenger fora do widget build
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // --- CORES DO PROJETO (MANTIDAS) ---
  final Color _verdePrincipal = const Color(0xFF27C5B2);
  final Color _lightPastelGreen = const Color(0xFFE6F7E1); // Fundo Pastel Claro
  final Color _darkText = const Color(0xFF3C4E4B); // Cor escura para texto

  // --- FUNÇÃO PARA ABRIR LINKS ---
  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Exibe um erro usando o contexto fornecido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: Não foi possível abrir o link: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definindo o texto da proposta
    const String _propostaTexto =
        'Descubra, capture e compartilhe seus lugares favoritos onde a natureza floresce. 🌱\n\nConecte-se com jardineiros da sua comunidade e ajude a espalhar o cultivo colaborativo pelo mundo.';

    return Scaffold(
      // Fundo em Verde Pastel Claro
      backgroundColor: _lightPastelGreen,
      appBar: AppBar(
        title: const Text('RedeVerde'),
        // AppBar em Verde Principal
        backgroundColor: _verdePrincipal,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        children: [
          // Seção Destaques (Banner e texto inicial)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo ao RedeVerde! 💚',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C4E4B), // Usando _darkText
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _propostaTexto,
                  style: TextStyle(
                    fontSize: 16,
                    color: _darkText.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                // BANNER: Imagem temática de jardinagem
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/img/Atalaiabanner.png'),
                ),
              ],
            ),
          ),

          // --- SEÇÃO CARROSSEL: Lugares Recentes/Populares ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Text(
              'Populares na Comunidade 📍',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: [
                SizedBox(
                  width: 250, // Largura de cada card no carrossel
                  child: ProductMiniCard(
                    imagePath: 'assets/img/AtalaiabannerQuadrado.png',
                    title: 'Jardim Secreto',
                    description:
                        'Comunidade focada em permacultura e compostagem orgânica.',
                    // --- LINK 1 ---
                    onTap: () => _launchUrl(
                      context,
                      'https://www.instagram.com/feirajardimsecreto/',
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: ProductMiniCard(
                    imagePath: 'assets/img/AtalaiabannerQuadrado.png',
                    title: 'Horta Coletiva Urbana',
                    description:
                        'Um espaço vibrante no centro da cidade, aberto para voluntários.',
                    // --- LINK 2 ---
                    onTap: () => _launchUrl(
                      context,
                      'https://cidadessemfome.org/?gad_source=1&gad_campaignid=12016206441&gclid=Cj0KCQiAubrJBhCbARIsAHIdxD-_Ul_wUyOrdVnadoZxNmV-pKInpEm56Jj0_wUYordVnadoZxNmV-pKInpEm56Jgxo9sbujSl7vzU5PWWYl0aAgWlEALw_wcB',
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: ProductMiniCard(
                    imagePath: 'assets/img/AtalaiabannerQuadrado.png',
                    title: 'Viveiro de Suculentas',
                    description:
                        'Especialista em espécies raras e trocas de mudas.',
                    // --- LINK 3 ---
                    onTap: () => _launchUrl(
                      context,
                      'https://www.suculentasholambra.com.br/?srsltid=AfmBOorbUMjJ_aZRAOKllMa0He2XflY0_zWOlHPoKilVWchb_dY1gpml',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- SEÇÃO RECURSOS COLABORATIVOS (VERTICAL) ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Divider(color: _darkText.withOpacity(0.2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Text(
              'Ferramentas Colaborativas 🤝',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkText,
              ),
            ),
          ),

          // --- LISTA DE RECURSOS ---
          ProductCard(
            imagePath: 'assets/img/Atalaiabanner.png',
            title: 'Calendário Lunar 🌕',
            description:
                'Saiba o melhor momento para plantar, podar e colher com base nos ciclos lunares e clima.',
            price: 'Acessar',
            // --- LINK 4 ---
            onTap: () => _launchUrl(
              context,
              'https://br.rhythmofnature.net/calendario-jardineiro',
            ),
          ),
          ProductCard(
            imagePath: 'assets/img/Atalaiabanner.png',
            title: 'Troca de Sementes e Mudas',
            description:
                'Conecte-se com membros próximos para trocar o excedente da sua colheita.',
            price: 'Comunidade', // Botão agora será 'Ver Grupo'
            // --- LINK 5: NOVO LINK DO FACEBOOK ADICIONADO AQUI ---
            onTap: () => _launchUrl(
              context,
              'https://www.facebook.com/groups/1615725305136073/?locale=pt_BR',
            ),
          ),
          ProductCard(
            imagePath: 'assets/img/Atalaiabanner.png',
            title: 'Mapeamento de Áreas Verdes',
            description:
                'Capture e categorize novas áreas de plantio, documentando a biodiversidade local.',
            price: 'Explorar',
            // --- LINK 6 ---
            onTap: () => _launchUrl(
              context,
              'https://mapas.semil.sp.gov.br/portal/apps/experiencebuilder/experience/?block_id=layout_2366_block_0&id=ede801f60edc4586a8dcf40e10b7dde0&v=22222%2F',
            ),
          ),
          ProductCard(
            imagePath: 'assets/img/Atalaiabanner.png',
            title: 'Fórum de Dúvidas (QA)',
            description:
                'Tire suas dúvidas sobre pragas, solo e técnicas de cultivo com jardineiros experientes.',
            price: 'Visitar',
            // --- LINK 7 ---
            onTap: () => _launchUrl(
              context,
              'https://teonanacatl.org/forums/guias-de-cultivo.134/',
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}