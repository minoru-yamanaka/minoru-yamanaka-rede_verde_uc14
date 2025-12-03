import 'package:atalaia_ar_condicionados_flutter_application/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Importar 'package:firebase_core/firebase_core.dart'
  runApp(const MyApp());
}


