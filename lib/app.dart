// -------------------------------------------------------------------------------------
// NOTA SOBRE A ESTRUTURA DO PROJETO:
// Você tem duas linhas de import para a LoginPage. A que está ativa determina qual
// "versão" do seu aplicativo será iniciada. Isso funciona, mas para gerenciar
// versões diferentes, a prática recomendada é usar "branches" do Git.
// -------------------------------------------------------------------------------------

// Esta linha está comentada, então o código dentro de 'Pages0/login_page.dart' não será usado.
// import 'package:atalaia_ar_condicionados_flutter_application/Pages0/login_page.dart';

// Esta é a linha que está ativa. O aplicativo vai carregar a LoginPage da pasta 'Pages'.
import 'package:atalaia_ar_condicionados_flutter_application/Pages/login_page.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/main_screen_PagesNew.dart';
import 'package:atalaia_ar_condicionados_flutter_application/providers/greate_places.dart';

// Importa a biblioteca principal do Flutter, que contém os widgets e ferramentas essenciais.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🛑 SOLUÇÃO: Adicionar o Provider aqui
    return ChangeNotifierProvider(
      // Cria a instância de GreatePlaces
      create: (ctx) => GreatePlaces(), 
      child: MaterialApp(
        // 🛑 PROPRIEDADE PARA REMOVER O BANNER DE DEBUG
        debugShowCheckedModeBanner: false,
        title: 'Atalaia App',
        theme: ThemeData(
          // ... (seu tema)
        ),
        // O home deve ser o seu MainScreen2
        home: const LoginPage(), 
        // ... (suas rotas, se houver)
      ),
    );
  }
}
