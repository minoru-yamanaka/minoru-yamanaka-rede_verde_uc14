//import 'package:atalaia_ar_condicionados_flutter_application/Pages/main_screen_PagesNew.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/main_screen_PagesNew.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/register_page.dart';
import 'package:atalaia_ar_condicionados_flutter_application/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // --- CORES DO PROJETO ---
  final Color _redeVerdeGreen = const Color(0xFF27C5B2); // Verde Principal
  final Color _pinkAccent = const Color(0xFFFC7ACF); // Rosa Destaque
  final Color _primaryTextColor = const Color(
    0xFF3C4E4B,
  ); // Azul Escuro (Para textos e links escuros)

  final FirebaseService _firebaseService = FirebaseService(
    collectionName: "usuarios",
  );

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  realizarLogin() async {
    final email = _emailController.text.trim();
    final senha = _passwordController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    try {
      final usuario = await _firebaseService.getByEmail(email);

      if (usuario == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Conta não encontrado')));
        return;
      }

      if (usuario['senha'] == senha) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen2()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Column(
              children: [
                const Text(
                  "Sucesso",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Usuário Logado com sucesso"),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Senha incorreta')));
      }
    } catch (erro) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao fazer login: $erro')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // --- BANNER ---
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset('assets/img/Atalaiabanner.png'),
            ),
            const SizedBox(height: 50.0),

            // --- CAMPO EMAIL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    // 🛑 Destaque de foco Rosa (Accent Color)
                    borderSide: BorderSide(color: _pinkAccent, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            // --- CAMPO DE SENHA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: _primaryTextColor, // Ícone escuro para contraste
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    // 🛑 Destaque de foco Rosa (Accent Color)
                    borderSide: BorderSide(color: _pinkAccent, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // --- BOTÃO LOGIN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Trocado TextButton por ElevatedButton para estilo mais proeminente
                  style: ElevatedButton.styleFrom(
                    // 🛑 Cor de fundo Verde (Ação Principal)
                    backgroundColor: _redeVerdeGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    realizarLogin();
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          Colors.white, // Texto Branco para contraste no Verde
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8.0),

            // --- BOTÃO DE REGISTRO ---
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text(
                'Registre-se agora',
                // 🛑 Cor do link Verde (Primary Color)
                style: TextStyle(
                  color: _redeVerdeGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
            // 🛑 Cor da divisória ajustada
            const SizedBox(width: 300, child: Divider(color: Colors.black26)),
            const SizedBox(height: 20),

            // --- TEXTO CONTINUAR COM ---
            Text(
              'Ou continue com',
              // 🛑 Cor do texto Verde (Primary Color)
              style: TextStyle(
                color: _primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // --- ÍCONES SOCIAIS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // Cores mantidas para representar as marcas
                FaIcon(FontAwesomeIcons.google, size: 30, color: Colors.red),
                SizedBox(width: 20),
                FaIcon(FontAwesomeIcons.apple, size: 30, color: Colors.black),
                SizedBox(width: 20),
                FaIcon(FontAwesomeIcons.facebook, size: 30, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
