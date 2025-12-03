import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:atalaia_ar_condicionados_flutter_application/model/place.dart';

class LocationInput extends StatefulWidget {
  final Function(PlaceLocation) onSelectLocation;

  const LocationInput(this.onSelectLocation, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _hasLocation = false;
  bool _isLoading = false;

  // --- CORES E ESTILO DO PROJETO ---
  final Color _verdePrincipal = const Color(
    0xFF27C5B2,
  ); // Cor de status e borda
  final Color _rosaDestaque = const Color(0xFFFC7ACF); // Cor do Botão (Ação)
  final Color _darkText = Colors.black87; // Para texto em fundos claros
  final _borderRadius = BorderRadius.circular(15.0); // Raio de Borda Unificado

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isLoading = true;
      _hasLocation = false;
    });

    try {
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() => _isLoading = false);
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() => _isLoading = false);
          return;
        }
      }

      locationData = await location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        setState(() => _isLoading = false);
        return;
      }

      final selectedLocation = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );

      setState(() {
        _hasLocation = true;
      });

      widget.onSelectLocation(selectedLocation);
    } catch (e) {
      print("Erro ao pegar localização: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStatusContent(ThemeData theme) {
    // Cor do indicador de carregamento
    if (_isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _verdePrincipal,
        ),
      );
    }

    // Status: Localização Capturada (Ícone e Texto em Verde Principal)
    if (_hasLocation) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: _verdePrincipal, size: 20),
          const SizedBox(width: 8),
          Text(
            'Localização capturada!',
            style: TextStyle(
              color: _verdePrincipal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // Status: Padrão/Aguardando (Ícone e Texto em cor escura)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_off_outlined, color: _darkText, size: 20),
        const SizedBox(width: 8),
        Text('Informar Localização!', style: TextStyle(color: _darkText)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Botão: Rosa Destaque (Borda Arredondada)
        ElevatedButton.icon(
          icon: const Icon(Icons.location_on_outlined, color: Colors.white),
          label: const Text('Buscar Localização Atual'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _rosaDestaque, // Cor Rosa Destaque
            foregroundColor: Colors.white, // Texto Branco para contraste
            shape: RoundedRectangleBorder(
              // Borda Arredondada
              borderRadius: _borderRadius,
            ),
            minimumSize: const Size(double.infinity, 50), // Largura total
          ),
          onPressed: _getCurrentUserLocation,
        ),

        const SizedBox(height: 10),

        // Container de Status: Fundo Verde Transparente com Borda Verde (Borda Arredondada)
        Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Borda Arredondada
            borderRadius: _borderRadius,
            // Fundo transparente sutil em Verde Principal (como nos TextFields)
            color: _verdePrincipal.withOpacity(0.1),
            border: Border.all(
              width: 1,
              // Borda em Verde Principal
              color: _verdePrincipal.withOpacity(0.5),
            ),
          ),
          child: _buildStatusContent(theme),
        ),
      ],
    );
  }
}
