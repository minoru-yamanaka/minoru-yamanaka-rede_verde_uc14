import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarioLunarPage extends StatefulWidget {
  const CalendarioLunarPage({super.key});

  @override
  State<CalendarioLunarPage> createState() => _CalendarioLunarPageState();
}

class _CalendarioLunarPageState extends State<CalendarioLunarPage> {
  // --- CORES REUTILIZADAS DO PROJETO ANTERIOR ---
  final Color _verdePrincipal = const Color(0xFF27C5B2);
  final Color _rosaDestaque = const Color(0xFFFC7ACF);
  final Color _lightPastelGreen = const Color(0xFFE6F7E1);
  final Color _darkText = const Color(0xFF3C4E4B);

  // --- CONFIGURAÇÃO DA API DE CLIMA ---
  final String _apiKey = '64e1a43beea0ccd8308742e5814fa338'; // Sua chave
  final double _mockLat = -23.5505; // Latitude de São Paulo (Exemplo)
  final double _mockLon = -46.6333; // Longitude de São Paulo (Exemplo)

  // --- DADOS DE ESTADO ---
  DateTime _dataAtual = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _faseLunar = '';
  String _estacaoAtual = '';
  String _dicaEstacao = '';

  // Variáveis do Clima
  String _previsaoTempo = 'Carregando previsão...';
  IconData _iconeClima = Icons.cloud_queue;

  @override
  void initState() {
    initializeDateFormatting('pt_BR', null).then((_) {
      if (mounted) {
        setState(() {
          Intl.defaultLocale = 'pt_BR';
          _selectedDay = _dataAtual;
          _atualizarDadosLuaEEstacao();
        });
        _fetchWeatherData();
      }
    });

    super.initState();
  }

  // --- MÉTODO PARA CALCULAR FASE LUNAR PRECISA (Algoritmo Adaptado) ---
  String _calcularFaseLunarReal(DateTime date) {
    final ReferenceDay = DateTime.utc(2000, 1, 1);
    final daysSinceReference = date.difference(ReferenceDay).inDays;

    const cycleLength = 29.5305882;
    const referencePhase = 0.0;

    final currentPhaseDays =
        (daysSinceReference % cycleLength) + referencePhase;

    double age = currentPhaseDays < 0
        ? currentPhaseDays + cycleLength
        : currentPhaseDays;

    if (age < 1.84) {
      return 'Lua Nova 🌑 (Ideal para Raízes)';
    } else if (age < 5.53) {
      return 'Lua Crescente 🌙 (Transição)';
    } else if (age < 9.22) {
      return 'Quarto Crescente 🌓 (Ideal para Folhas e Caules)';
    } else if (age < 12.91) {
      return 'Lua Crescente Gibosa 🌔 (Transição)';
    } else if (age < 16.6) {
      return 'Lua Cheia 🌕 (Ideal para Frutos e Flores)';
    } else if (age < 20.29) {
      return 'Lua Minguante Gibosa 🌖 (Transição)';
    } else if (age < 23.98) {
      return 'Quarto Minguante 🌗 (Ideal para Poda e Transplante)';
    } else if (age < 27.67) {
      return 'Lua Minguante 🌘 (Transição)';
    } else {
      return 'Lua Nova 🌑 (Ideal para Raízes)';
    }
  }

  // --- LÓGICA DE CLIMA ---

  Future<void> _fetchWeatherData() async {
    if (_apiKey == 'SUA_CHAVE_API_OPENWEATHER_AQUI') {
      setState(() {
        _previsaoTempo = 'Erro: Chave API não configurada.';
      });
      return;
    }

    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$_mockLat&lon=$_mockLon&appid=$_apiKey&units=metric&lang=pt_br';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final temp = data['main']['temp'].round().toString();
        final description = data['weather'][0]['description'];
        final mainWeather = data['weather'][0]['main'];

        setState(() {
          _previsaoTempo =
              '${description[0].toUpperCase()}${description.substring(1)}, ${temp}°C';
          _iconeClima = _getWeatherIcon(mainWeather);
        });
      } else {
        setState(() {
          _previsaoTempo = 'Falha ao carregar o clima: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _previsaoTempo = 'Erro de conexão ou dados. Tente novamente.';
      });
    }
  }

  IconData _getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.beach_access;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud_queue;
    }
  }

  // --- LÓGICA DE DADOS (LUA E ESTAÇÃO) ---

  void _atualizarDadosLuaEEstacao() {
    final now = _dataAtual;
    _faseLunar = _calcularFaseLunarReal(now);

    final mes = now.month;
    if (mes >= 12 || mes <= 2) {
      _estacaoAtual = 'Verão ☀️';
      _dicaEstacao =
          'Foco em irrigação e plantas resistentes ao calor intenso. Ideal para plantar melancia e quiabo.';
    } else if (mes >= 3 && mes <= 5) {
      _estacaoAtual = 'Outono 🍂';
      _dicaEstacao =
          'Hora de plantar alho, cebola e espécies que toleram frio. Prepare o solo para o inverno.';
    } else if (mes >= 6 && mes <= 8) {
      _estacaoAtual = 'Inverno ❄️';
      _dicaEstacao =
          'Proteja plantas sensíveis e evite o excesso de rega. Concentre-se em podas de formação.';
    } else {
      _estacaoAtual = 'Primavera 🌸';
      _dicaEstacao =
          'Período ideal para semear flores e hortaliças de ciclo curto. O crescimento é acelerado!';
    }
  }

  String _getDicaDeCultivo() {
    if (_faseLunar.contains('Nova')) {
      return 'Na Lua Nova 🌑, a energia da planta está concentrada na raiz. Ideal para plantio de raízes (batata 🥔, cenoura 🥕, rabanete) e adubação. ✨';
    } else if (_faseLunar.contains('Quarto Crescente') ||
        _faseLunar.contains('Crescente')) {
      return 'Na Lua Crescente 🌙, a seiva sobe. Perfeito para plantar folhagens e caules (alface 🥬, couve, aipo). O crescimento é rápido e abundante! 🚀';
    } else if (_faseLunar.contains('Cheia')) {
      return 'Na Lua Cheia 🌕, a seiva está distribuída por toda a planta. Ideal para colher frutos 🍎 e ervas aromáticas. Evite podas, a cicatrização é mais lenta. ✂️';
    } else {
      return 'Na Lua Minguante 🌗, a energia volta para o subsolo. Ótimo momento para podas, transplantes 🌱 e limpeza do jardim, pois a planta resiste melhor. 💪';
    }
  }
  // --- WIDGETS DE CONSTRUÇÃO ---

  // MÉTODO PARA CARDS HORIZONTAIS (Originalmente usado nos dados de Jardinagem, mas não mais usado)
  Widget _buildHorizontalCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _darkText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO PARA CARDS VERTICAIS (Usado nos Dados de Jardinagem)
  Widget _buildVerticalCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      // NOTE: Sem Expanded, ocupa a largura total do Column
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrevisaoTempoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previsão do Tempo (Local)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(_iconeClima, color: Colors.blue, size: 36),
              const SizedBox(width: 12),
              Text(
                _previsaoTempo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lembre-se: O clima afeta diretamente a eficácia do plantio e da poda.',
            style: TextStyle(fontSize: 14, color: _darkText.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILD ---

  @override
  Widget build(BuildContext context) {
    if (_selectedDay == null) {
      return Scaffold(
        backgroundColor: _lightPastelGreen,
        body: Center(child: CircularProgressIndicator(color: _verdePrincipal)),
      );
    }

    // Não precisamos mais dividir a dica de cultivo em itens, voltando ao formato de bloco único.

    return Scaffold(
      backgroundColor: _lightPastelGreen,
      appBar: AppBar(
        title: const Text('Calendário Lunar para Cultivos'),
        backgroundColor: _verdePrincipal,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. --- VISUALIZAÇÃO DO CALENDÁRIO (TOPO) ---
            Text(
              'Calendário do Mês (Interativo)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkText,
              ),
            ),
            const SizedBox(height: 10),

            // CONTAINER ENVOLVENDO O CALENDÁRIO
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _lightPastelGreen.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _darkText.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                locale: 'pt_BR',
                daysOfWeekHeight: 30.0,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: _darkText),
                  weekendStyle: TextStyle(
                    color: _rosaDestaque,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                firstDay: DateTime.utc(_dataAtual.year - 5, 1, 1),
                lastDay: DateTime.utc(_dataAtual.year + 5, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: _darkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  decoration: BoxDecoration(
                    color: _lightPastelGreen.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: _darkText),
                  rightChevronIcon: Icon(Icons.chevron_right, color: _darkText),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: _rosaDestaque.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: _verdePrincipal,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: _darkText),
                  weekendTextStyle: TextStyle(color: _rosaDestaque),
                  outsideDaysVisible: false,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _dataAtual = selectedDay;

                      _atualizarDadosLuaEEstacao();
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // 2. --- SEÇÃO PREVISÃO DO TEMPO ---
            _buildPrevisaoTempoCard(),

            const SizedBox(height: 24),

            // 3. --- SEÇÃO DICAS DE CULTIVO (REVERTIDA PARA BLOCO ÚNICO) ---
            Text(
              'Dicas de Cultivo 💡',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkText,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _rosaDestaque.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getDicaDeCultivo(), // Texto completo em um único bloco
                style: TextStyle(fontSize: 16, color: _darkText),
              ),
            ),

            const SizedBox(height: 24),

            // 4. --- SEÇÃO DADOS ATUAIS DA JARDINAGEM (ÚLTIMO Bloco - Vertical) ---
            Text(
              'Dados Atuais da Jardinagem 🌱',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkText,
              ),
            ),
            const SizedBox(height: 16),

            // Usando Column para empilhar os cards (Lista Vertical)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildVerticalCard(
                  'Fase da Lua:',
                  _faseLunar,
                  Icons.wb_sunny_outlined,
                  _rosaDestaque,
                ),

                const SizedBox(height: 16), // Espaçamento entre os cards

                _buildVerticalCard(
                  'Estação: ${_estacaoAtual}',
                  _dicaEstacao,
                  Icons.nature,
                  _verdePrincipal,
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
