import 'dart:io';
import 'package:flutter/material.dart';
import 'package:atalaia_ar_condicionados_flutter_application/model/place.dart';
import 'dart:math';

class GreatePlaces with ChangeNotifier {
  final List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  // ATUALIZADO para aceitar localização e nota
  void addPlace(
    String title,
    File image,
    PlaceLocation location,
    String? note,
  ) {
    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      image: image,
      location: location, // <-- ATUALIZADO
      note: note, // <-- ATUALIZADO
    );

    _items.add(newPlace);
    notifyListeners();
  }
  
  // 🛑 NOVO MÉTODO: Remover um local pelo ID
  void removePlace(String id) {
    // Remove o item da lista onde o ID corresponde ao fornecido.
    _items.removeWhere((place) => place.id == id);
    notifyListeners();
  }
}