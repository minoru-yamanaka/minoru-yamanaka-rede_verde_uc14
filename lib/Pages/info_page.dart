// import 'package:flutter/material.dart';
// import 'package:atalaia_ar_condicionados_flutter_application/Pages/localizacao_page.dart';
// // IMPORTANTE: Importe o novo widget do chatbot que criamos
// import 'package:atalaia_ar_condicionados_flutter_application/Pages/chatbot_widget.dart';

// class InfoPage extends StatelessWidget {
//   InfoPage({super.key});

//   final TextEditingController controllerSearch = TextEditingController();

//   // Função para abrir o chatbot em um Modal Bottom Sheet
//   void _openChatbot(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       // Permite que o sheet seja mais alto que a metade da tela
//       isScrollControlled: true,
//       // Deixa os cantos superiores arredondados
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         // Define a altura do BottomSheet para 90% da tela
//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.9,
//           child: ChatbotWidget(
//             text: controllerSearch.text,
//           ), // Aqui usamos nosso novo widget!
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const titleStyle = TextStyle(
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//       color: Color(0xFF343B6C),
//     );
//     const contentStyle = TextStyle(
//       fontSize: 16,
//       color: Colors.black87,
//       height: 1.5,
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Informações'),
//         backgroundColor: const Color(0xFF0C1D34),
//         foregroundColor: Colors.white,
//         elevation: 1,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(
//           16.0,
//         ).copyWith(bottom: 80), // Espaço extra no final para o FAB não cobrir
//         children: [
//           Center(
//             child: SizedBox(
//               child: Text(
//                 "Duvidas",
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 14, 2, 82),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           TextField(
//             onSubmitted: (value) {
//               print(value);
//               _openChatbot(context);
//             },
//             controller: controllerSearch,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               prefixIcon: const Icon(Icons.search),
//               hintText: 'Alguma duvida? Nossa IA responde..',
//             ),
//           ),
//           SizedBox(height: 25),
//           // --- Seus Cards de informação permanecem os mesmos ---
//           Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: Image.asset(
//                     'assets/img/Atalaiabanner.png',
//                     width: 410,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Quando fazer a higienização?", style: titleStyle),
//                       SizedBox(height: 12),
//                       Text(
//                         "A recomendação geral é realizar a higienização completa pelo menos uma vez por ano. Em ambientes com alto fluxo de pessoas, o ideal é a cada 6 meses.",
//                         style: contentStyle,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: Image.asset(
//                     'assets/img/Atalaiabanner.png',
//                     width: 410,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Como economizar energia com o ar-condicionado?",
//                         style: titleStyle,
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         "• Mantenha os filtros sempre limpos.\n• Deixe portas e janelas fechadas.\n• Mantenha uma temperatura estável (entre 22ºC e 24ºC).",
//                         style: contentStyle,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: Image.asset(
//                     'assets/img/Atalaiabanner.png',
//                     width: 410,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Text(
//                         "Sinais de que seu ar precisa de manutenção",
//                         style: titleStyle,
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         "• Ruídos ou vibrações estranhas.\n• O aparelho não gela como antes.\n• Vazamentos de água ou cheiro de mofo.",
//                         style: contentStyle,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
