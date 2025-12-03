import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) onSelectImage;

  const ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  // --- CORES E ESTILO DO PROJETO ---
  final Color _verdePrincipal = const Color(
    0xFF27C5B2,
  ); // Usado para borda/fundo sutil
  final Color _rosaDestaque = const Color(0xFFFC7ACF); // Cor dos Botões
  final Color _darkText = Colors.black87; // Para texto em fundos claros
  final _borderRadius = BorderRadius.circular(15.0); // Raio de Borda Unificado

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: source, maxWidth: 600);

    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    widget.onSelectImage(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ajuste de Estilo: Caixa de pré-visualização (Bordas Arredondadas)
        Container(
          width: double.infinity,
          height: 180,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Borda Arredondada (15.0)
            borderRadius: _borderRadius,
            // Fundo sutil Verde Principal
            color: _verdePrincipal.withOpacity(0.1),
            border: Border.all(
              width: 1,
              // Borda em Verde Principal
              color: _verdePrincipal.withOpacity(0.5),
            ),
          ),
          child: _storedImage != null
              ? ClipRRect(
                  // Adicionando ClipRRect para cortar a imagem se ela tiver quebras de linha
                  borderRadius: _borderRadius,
                  child: Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity, // Preenche a altura do Container
                  ),
                )
              // Ajuste de Estilo: Placeholder com ícone e texto
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      // Ícone em Verde Principal
                      color: _verdePrincipal.withOpacity(0.7),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhuma Imagem!',
                      textAlign: TextAlign.center,
                      // Texto em cor escura para contraste
                      style: TextStyle(color: _darkText.withOpacity(0.7)),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 10),
        // Ajuste de Estilo: Botões (Bordas Arredondadas)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text('Câmera'),
                style: ElevatedButton.styleFrom(
                  // Fundo Rosa Destaque
                  backgroundColor: _rosaDestaque,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    // Borda Arredondada
                    borderRadius: _borderRadius,
                  ),
                  minimumSize: const Size(0, 45),
                ),
                onPressed: () => _takePicture(ImageSource.camera),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.image_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text('Galeria'),
                style: ElevatedButton.styleFrom(
                  // Fundo Rosa Destaque
                  backgroundColor: _rosaDestaque,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    // Borda Arredondada
                    borderRadius: _borderRadius,
                  ),
                  minimumSize: const Size(0, 45),
                ),
                onPressed: () => _takePicture(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
