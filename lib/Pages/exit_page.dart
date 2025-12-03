import 'package:atalaia_ar_condicionados_flutter_application/Config/app_colors.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Config/app_text_style.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/login_page.dart';
import 'package:flutter/material.dart';

class ExitPage extends StatelessWidget {
  const ExitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorPages,
      appBar: AppBar(
        title: Text(
          "Sair",
          style: AppTextStyle.titleAppBar.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sair", style: AppTextStyle.subtitlePages),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.folder_copy, size: 33, color: Colors.blue),
                          SizedBox(width: 14),
                          Text(
                            "Sair",
                            style: AppTextStyle.titleAppBar.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 45,
                        right: 25,
                        top: 10,
                      ),
                      child: Text(
                        "Sair",
                        style: AppTextStyle.subtitlePages.copyWith(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            // Navega para a tela principal e remove a tela de login da pilha
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: Text("Sair"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
