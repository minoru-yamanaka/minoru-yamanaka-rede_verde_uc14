import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atalaia_ar_condicionados_flutter_application/model/place.dart';
import 'package:atalaia_ar_condicionados_flutter_application/providers/greate_places.dart';
import 'package:atalaia_ar_condicionados_flutter_application/widgets/image_input.dart';
import 'package:atalaia_ar_condicionados_flutter_application/widgets/location_input.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- Controladores e Cores ---
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _nomeRuaController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();

  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  // --- CORES DO PROJETO ---
  final Color _verdePrincipal = const Color(
    0xFF27C5B2,
  ); // Verde Principal (AppBar, texto no fundo claro)
  final Color _rosaDestaque = const Color(
    0xFFFC7ACF,
  ); // Rosa Destaque (Botões, foco em inputs)
  final Color _lightPastelGreen = const Color(
    0xFFE6F7E1,
  ); // NOVO: Fundo do Scaffold (Verde Pastel Claro)
  final Color _darkText = Colors.black87; // Para texto em fundos claros

  final _spacing = const SizedBox(height: 16);
  // Raio de Borda Unificado
  final _borderRadius = BorderRadius.circular(15.0);

  final placesRegex = RegExp(
    r'--- Lugar #\d+ ---\s*Título: (.*?)\s*Nota: (.*?)\s*Endereço: (.*?)\s*Coordenadas: Lat: (.*?), Lng: (.*?)\s*',
    dotAll: true,
  );

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _nomeRuaController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  void _selectImage(File image) {
    _pickedImage = image;
  }

  void _selectLocation(PlaceLocation location) {
    _pickedLocation = location;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null || _pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecione o Título, a Imagem e a Localização.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final completeLocation = PlaceLocation(
      latitude: _pickedLocation!.latitude,
      longitude: _pickedLocation!.longitude,
      address: _pickedLocation!.address ?? 'Endereço não encontrado',
      nomeRua: _nomeRuaController.text,
      cep: _cepController.text,
      numero: _numeroController.text,
    );

    Provider.of<GreatePlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
      completeLocation,
      _noteController.text,
    );

    _titleController.clear();
    _noteController.clear();
    _nomeRuaController.clear();
    _cepController.clear();
    _numeroController.clear();
    _pickedImage = null;
    _pickedLocation = null;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lugar cadastrado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // NOVA FUNÇÃO: Excluir um item da lista
  void _deletePlace(String id, String title) {
    Provider.of<GreatePlaces>(context, listen: false).removePlace(id);

    // Feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Local "$title" removido.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // --- LÓGICA DE IMPORTAÇÃO E PARSING (Simplificada para brevidade) ---
  Future<void> _showImportDialog() async {
    final importController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar Lugares'),
        content: TextField(
          controller: importController,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: "Cole o texto exportado aqui...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar', style: TextStyle(color: _verdePrincipal)),
          ),
          ElevatedButton(
            onPressed: () {
              if (importController.text.isNotEmpty) {
                // Aqui seria a chamada _parseAndImportText
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Função de parsing desabilitada para o código pronto.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            // Cor do botão Importar: Rosa Destaque
            style: ElevatedButton.styleFrom(
              backgroundColor: _rosaDestaque,
              foregroundColor: Colors.white,
              // Ajuste da borda do botão
              shape: RoundedRectangleBorder(borderRadius: _borderRadius),
            ),
            child: const Text('Importar'),
          ),
        ],
      ),
    );
    importController.dispose();
  }

  // --- LÓGICA DE COMPARTILHAMENTO DE TODOS (Simplificada para brevidade) ---
  void _shareAllPlaces() {
    final greatePlaces = Provider.of<GreatePlaces>(context, listen: false);

    if (greatePlaces.itemsCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há lugares para compartilhar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    String shareText = '🌳 **Meus Lugares Favoritos da RedeVerde** 🌳\n\n';

    for (int i = 0; i < greatePlaces.itemsCount; i++) {
      final place = greatePlaces.itemByIndex(i);
      final note = place.note ?? 'Sem nota';
      final rua = place.location?.nomeRua ?? 'Rua não informada';
      final numero = place.location?.numero ?? 'S/N';
      final cep = place.location?.cep ?? '';
      final lat = place.location?.latitude;
      final lng = place.location?.longitude;

      String endereco = '$rua, $numero';
      if (cep.isNotEmpty) {
        endereco += ' - CEP $cep';
      }

      shareText += '--- Lugar #${i + 1} ---\n';
      shareText += 'Título: ${place.title}\n';
      shareText += 'Nota: $note\n';
      shareText += 'Endereço: $endereco\n';
      shareText +=
          'Coordenadas: Lat: ${lat != null ? lat.toStringAsFixed(5) : 'N/A'}, Lng: ${lng != null ? lng.toStringAsFixed(5) : 'N/A'}\n\n';
    }

    Share.share(shareText);
  }

  // --- ESTILOS (Ajustados para o tema de fundo pastel e borda arredondada) ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      // Texto da label agora é mais escuro para contrastar com o fundo claro
      labelStyle: TextStyle(color: _darkText),
      // Ícone agora é Verde Principal
      prefixIcon: Icon(icon, color: _verdePrincipal, size: 20),
      filled: true,
      fillColor: _verdePrincipal.withOpacity(0.1), // Suave verde para o campo
      enabledBorder: OutlineInputBorder(
        // Borda Arredondada
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: _verdePrincipal.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        // Borda Arredondada
        borderRadius: _borderRadius,
        // Borda de foco: Rosa Destaque
        borderSide: BorderSide(color: _rosaDestaque, width: 2),
      ),
      // Adicionando borda também para o caso padrão (sem enabledBorder/focusedBorder)
      border: OutlineInputBorder(borderRadius: _borderRadius),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo: Verde Pastel Claro
      backgroundColor: _lightPastelGreen,
      appBar: AppBar(
        title: const Text('Cadastrar Novo Lugar'),
        // AppBar: Verde Principal
        backgroundColor: _verdePrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // --- CAMPOS DO FORMULÁRIO ---
                      TextFormField(
                        controller: _titleController,
                        style: TextStyle(color: _darkText),
                        decoration: _buildInputDecoration(
                          'Título',
                          Icons.title_rounded,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'O Título é obrigatório.'
                            : null,
                      ),
                      _spacing,
                      TextFormField(
                        controller: _nomeRuaController,
                        style: TextStyle(color: _darkText),
                        decoration: _buildInputDecoration(
                          'Nome da Rua (Opcional)',
                          Icons.signpost_outlined,
                        ),
                      ),
                      _spacing,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _cepController,
                              style: TextStyle(color: _darkText),
                              decoration: _buildInputDecoration(
                                'CEP (Opcional)',
                                Icons.pin_drop_outlined,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _numeroController,
                              style: TextStyle(color: _darkText),
                              decoration: _buildInputDecoration(
                                'Nº (Opcional)',
                                Icons.numbers_rounded,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      _spacing,
                      TextFormField(
                        controller: _noteController,
                        style: TextStyle(color: _darkText),
                        decoration: _buildInputDecoration(
                          'Nota (Opcional)',
                          Icons.note_alt_outlined,
                        ),
                        maxLines: 3,
                      ),
                      _spacing,
                      // ImageInput e LocationInput precisam ser verificados se usam a variável _borderRadius internamente.
                      ImageInput(_selectImage),
                      _spacing,
                      LocationInput(_selectLocation),

                      // BOTÃO ADICIONAR
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Adicionar'),
                          // Cor do botão Adicionar: Rosa Destaque
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _rosaDestaque,
                            foregroundColor: Colors.white,
                            // Ajuste da borda do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: _borderRadius,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _submitForm,
                        ),
                      ),

                      // --- SEÇÃO DA LISTA ---
                      const Divider(
                        color: Colors.black26,
                        height: 32,
                      ), // Divisor mais escuro para o fundo claro
                      Text(
                        'Histórico de Lugares Cadastrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _verdePrincipal,
                        ),
                      ), // Texto em Verde Principal
                      const SizedBox(height: 12),

                      Consumer<GreatePlaces>(
                        builder: (context, greatePlaces, ch) => Column(
                          children: [
                            greatePlaces.itemsCount == 0
                                // Texto em _darkText para contrastar com o fundo claro
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Nenhum local cadastrado!',
                                      style: TextStyle(
                                        color: _darkText.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: greatePlaces.itemsCount,
                                    itemBuilder: (context, i) {
                                      final place = greatePlaces.itemByIndex(i);
                                      final note = place.note ?? 'Sem nota';
                                      final rua =
                                          place.location?.nomeRua ??
                                          'Rua não informada';
                                      final numero =
                                          place.location?.numero ?? 'S/N';
                                      final cep = place.location?.cep ?? '';
                                      // ... lógica de endereço ...
                                      String endereco = '$rua, $numero';
                                      if (cep.isNotEmpty) {
                                        endereco += ' - CEP $cep';
                                      }
                                      String subtitleText = '$note\n$endereco';

                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: FileImage(
                                            place.image,
                                          ),
                                        ),
                                        // Título e subtítulo agora em cores mais escuras
                                        title: Text(
                                          place.title,
                                          style: TextStyle(
                                            color: _darkText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Text(
                                          subtitleText,
                                          style: TextStyle(
                                            color: _darkText.withOpacity(0.85),
                                          ),
                                        ),
                                        // Row para o ícone de Excluir e Compartilhar
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Botão de Compartilhar: Rosa Destaque
                                            IconButton(
                                              icon: const Icon(Icons.share),
                                              color: _rosaDestaque,
                                              onPressed: () {
                                                final lat =
                                                    place.location?.latitude;
                                                final lng =
                                                    place.location?.longitude;
                                                final texto =
                                                    'Vou compartilhar meu achado da RedeVerde! 🌱\nLugar: ${place.title}\nNota: ${place.note ?? 'Sem nota'}\nEndereço: $endereco\nCoordenadas: Lat: ${lat != null ? lat.toStringAsFixed(5) : 'N/A'}, Lng: ${lng != null ? lng.toStringAsFixed(5) : 'N/A'}';
                                                Share.share(texto);
                                              },
                                            ),
                                            // Botão de Excluir (Mantido em Vermelho para Ação de Risco)
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                              color: Colors.redAccent,
                                              onPressed: () => _deletePlace(
                                                place.id,
                                                place.title,
                                              ),
                                            ),
                                          ],
                                        ),
                                        isThreeLine: true,
                                        onTap: () {},
                                      );
                                    },
                                  ),

                            // // BOTÃO 1: Importar Lugares
                            // if (greatePlaces.itemsCount >= 0)
                            //   Padding(
                            //     padding: const EdgeInsets.only(top: 20),
                            //     child: SizedBox(
                            //       width: double.infinity,
                            //       child: ElevatedButton.icon(
                            //         icon: const Icon(
                            //           Icons.download,
                            //           color: Colors.white,
                            //         ),
                            //         label: const Text('Importar Lugares'),
                            //         onPressed: _showImportDialog,
                            //         // Cor do botão Importar: Rosa Destaque
                            //         style: ElevatedButton.styleFrom(
                            //           backgroundColor: _rosaDestaque,
                            //           foregroundColor: Colors.white,
                            //           // Ajuste da borda do botão
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: _borderRadius,
                            //           ),
                            //           minimumSize: const Size(
                            //             double.infinity,
                            //             50,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),

                            // BOTÃO 2: Compartilhar Todos os Lugares
                            if (greatePlaces.itemsCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Compartilhar Todos os Lugares',
                                    ),
                                    onPressed: _shareAllPlaces,
                                    // Cor do botão Compartilhar: Rosa Destaque
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _rosaDestaque,
                                      foregroundColor: Colors.white,
                                      // Ajuste da borda do botão
                                      shape: RoundedRectangleBorder(
                                        borderRadius: _borderRadius,
                                      ),
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
