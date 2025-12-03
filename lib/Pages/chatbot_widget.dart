import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

// Modelo de Dados para cada Mensagem (Mantido)
class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}

// O Widget principal agora é a página
class ChatbotPage extends StatefulWidget {
  final String initialQuery;

  const ChatbotPage({super.key, this.initialQuery = ''});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  // --- CORES DO PROJETO (PALETA PASTEEL) ---
  final Color _verdePrincipal = const Color(
    0xFF27C5B2,
  ); // Verde Principal (Teal) - Balão do Bot, AppBar, e Círculo de Envio
  final Color _rosaDestaque = const Color(
    0xFFFC7ACF,
  ); // Rosa Destaque (Pink Accent) - Balão do Usuário e Botões de Ação
  final Color _lightPastelGreen = const Color(
    0xFFE6F7E1,
  ); // Fundo do Chat e Fundo da Área de Input
  final Color _darkText = Colors.black87;

  // --- API KEY (Mantido) ---
  final String _apiKey =
      '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';
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  String _lastBotResponse = '';

  // DADOS RESTAURADOS PARA O PROJETO ATALAIA (Ar Condicionado)
  final Map<String, String> _respostasPredefinidas = {
    "olá":
        "Olá! Sou o assistente virtual da Atalaia Ar Condicionados. Como posso ajudar?",
    "oi":
        "Olá! Sou o assistente virtual da Atalaia Ar Condicionados. Como posso ajudar?",
    "bom dia":
        "Bom dia! Bem-vindo ao nosso assistente virtual. Em que posso ser útil?",
    "higienização":
        "A higienização completa remove ácaros e bactérias. Recomendamos fazer a cada 6 ou 12 meses. Gostaria de agendar?",
    "manutenção":
        "A manutenção preventiva aumenta a vida útil do seu aparelho. É ideal para garantir o bom funcionamento. Podemos agendar uma visita?",
    "instalação":
        "Realizamos a instalação de aparelhos de todas as marcas. Para um orçamento, preciso de mais detalhes.",
    "obrigado":
        "De nada! Se precisar de mais alguma coisa, a Atalaia Ar Condicionados está à sua disposição.",
    "tchau":
        "Até logo! Se precisar de algo mais, a Atalaia Ar Condicionados está à sua disposição.",
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.initialQuery.isNotEmpty) {
          _handleSendMessage(text: widget.initialQuery);
        } else {
          setState(() {
            _messages.add(
              ChatMessage(
                text:
                    "Olá! Sou seu assistente virtual da RedeVerde. Pergunte-me sobre nossos serviços, locais de plantio ou tire suas dúvidas sobre cultivo, como regras de rega ou tipos de adubação.",
                isUserMessage: false,
              ),
            );
          });
        }
      }
    });
  }

  // --- FUNÇÕES DE COMPARTILHAMENTO E API (Mantidas) ---
  void _exportLastResponse() {
    if (_lastBotResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nenhuma resposta da IA para exportar.',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
        ),
      );
      return;
    }

    final shareText =
        '❄️ **Resposta da IA da Atalaia** ❄️\n\n'
        '**Resposta:**\n$_lastBotResponse\n\n'
        'Entre em contato com a Atalaia Ar Condicionados!';

    Share.share(shareText);
  }

  void _exportFullConversation() {
    if (_messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A conversa está vazia.',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
        ),
      );
      return;
    }

    String fullText = '💬 **Conversa Completa com Assistente Atalaia** ❄️\n\n';

    for (final message in _messages) {
      final sender = message.isUserMessage ? 'Você' : 'Assistente';
      final prefix = message.isUserMessage ? '👤' : '🤖';

      fullText += '$prefix $sender: ${message.text}\n';
    }

    fullText += '\n---\nAtalaia Ar Condicionados à sua disposição.';

    Share.share(fullText);
  }

  void _handleSendMessage({String? text}) async {
    final messageToSend = text ?? _controller.text.trim();
    if (messageToSend.isEmpty || _isLoading) return;

    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(text: messageToSend, isUserMessage: true));
      _isLoading = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 500));

    String? predefinedAnswer;
    for (var key in _respostasPredefinidas.keys) {
      if (messageToSend.toLowerCase().contains(key)) {
        predefinedAnswer = _respostasPredefinidas[key];
        break;
      }
    }

    String finalResponse;
    if (predefinedAnswer != null) {
      finalResponse = predefinedAnswer;
    } else {
      try {
        finalResponse = await _getApiResponse(messageToSend);
      } catch (e) {
        finalResponse =
            "Desculpe, estou com dificuldades na minha conexão. Tente novamente mais tarde.";
      }
    }

    setState(() {
      _messages.add(ChatMessage(text: finalResponse, isUserMessage: false));
      _lastBotResponse = finalResponse;
      _isLoading = false;
    });

    _scrollToBottom();
  }

  Future<String> _getApiResponse(String question) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");
    final headers = {
      "Authorization": "Bearer $_apiKey",
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "model": "deepseek/deepseek-v3-base:free",
      "messages": [
        {
          "role": "system",
          "content":
              "Você é um assistente virtual de uma empresa de ar condicionado chamada Atalaia. Seja prestativo e foque em responder sobre serviços como instalação, manutenção, higienização e orçamentos.",
        },
        {"role": "user", "content": question},
      ],
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response from API');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Balões
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUserMessage;

    // Cor do balão do bot é o Verde Principal
    final botBubbleColor = _verdePrincipal;
    // Cor do balão do usuário é o Rosa Destaque
    final userBubbleColor = _rosaDestaque;

    // Cor do texto: Branco, já que ambos os balões são escuros.
    const textColor = Colors.white;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? userBubbleColor : botBubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isUser
                ? const Radius.circular(15)
                : const Radius.circular(4),
            bottomRight: isUser
                ? const Radius.circular(4)
                : const Radius.circular(15),
          ),
        ),
        child: Text(message.text, style: const TextStyle(color: textColor)),
      ),
    );
  }

  // Área de Input e Botões (AJUSTADA PARA O VERDE PASTEL CLARO E BORDAS 15.0)
  Widget _buildInputArea() {
    // Raio de Borda Unificado
    final _borderRadius = BorderRadius.circular(15.0);

    return Container(
      // Fundo da área de input agora é o Verde Pastel Claro (como o fundo do chat)
      color: _lightPastelGreen,
      child: Column(
        children: [
          // Botão Compartilhar Última Resposta (ROSA DESTAQUE)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _exportLastResponse,
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text('COMPARTILHAR ÚLTIMA RESPOSTA DA IA'),
                style: ElevatedButton.styleFrom(
                  // Fundo ROSA DESTAQUE
                  backgroundColor: _rosaDestaque,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: _borderRadius, // Ajustado para 15.0
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Botão Compartilhar Conversa Completa (ROSA DESTAQUE)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _exportFullConversation,
                icon: const Icon(Icons.history, color: Colors.white),
                label: const Text('COMPARTILHAR TODA A CONVERSA'),
                style: ElevatedButton.styleFrom(
                  // Fundo ROSA DESTAQUE
                  backgroundColor: _rosaDestaque,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: _borderRadius, // Ajustado para 15.0
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Campo de entrada e botão de enviar (AJUSTADO PARA O TEMA PASTEL E BORDAS 15.0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      // Estilo do texto no input
                      style: TextStyle(color: _darkText),
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem...",
                        hintStyle: TextStyle(color: _darkText.withOpacity(0.5)),
                        // Borda Padrão (15.0)
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: _verdePrincipal.withOpacity(0.8),
                          ),
                        ),
                        // Borda Normal (15.0)
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: _verdePrincipal.withOpacity(0.5),
                          ),
                        ),
                        filled: true,
                        // Cor de preenchimento VERDE PRINCIPAL SUTIL
                        fillColor: _verdePrincipal.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        // Borda de Foco (15.0)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          // Borda de foco ROSA DESTAQUE
                          borderSide: BorderSide(
                            color: _rosaDestaque,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _handleSendMessage(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Botão de Envio (Circular)
                  FloatingActionButton(
                    heroTag: 'send_btn',
                    onPressed: _handleSendMessage,
                    mini: true,
                    // Removi 'mini: true' para um botão circular de tamanho padrão
                    // e mantive o design consistente:
                    backgroundColor: _verdePrincipal,
                    elevation: 0,
                    // Ícone BRANCO no círculo Verde Principal
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo do Scaffold (Área do chat) VERDE PASTEL CLARO
      backgroundColor: _lightPastelGreen,
      appBar: AppBar(
        title: const Text('Assistente Virtual Atalaia'),
        // AppBar VERDE PRINCIPAL
        backgroundColor: _verdePrincipal,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Área de mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: _verdePrincipal),
                    ),
                  );
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          _buildInputArea(), // Área de input e botões
        ],
      ),
    );
  }
}
