import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Importações de Navegação
import 'package:atalaia_ar_condicionados_flutter_application/Pages/main_screen_PagesNew.dart';
import 'package:atalaia_ar_condicionados_flutter_application/Pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // --- CORES DO PROJETO (REDEVERDE) ---
  final Color _redeVerdeGreen = const Color(0xFF27C5B2); // Verde Principal
  final Color _pinkAccent = const Color(0xFFFC7ACF); // Rosa Destaque
  final Color _primaryTextColor = const Color(
    0xFF3C4E4B,
  ); // Cor escura para textos

  final _formKey = GlobalKey<FormState>();

  // Controladores de Texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmacaoController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _aceitouTermos = false;
  bool _isLoading = false;

  // A lógica de registro simplificada para fins de demonstração da UI
  void _handleRegister() {
    if (_formKey.currentState!.validate() && _aceitouTermos) {
      // Simulação de carregamento
      setState(() => _isLoading = true);

      // Simula a navegação após 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen2()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registro bem-sucedido!"),
            backgroundColor: Colors.green,
          ),
        );
      });
    } else if (!_aceitouTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você deve aceitar os termos de uso."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- WIDGET PARA CAMPO DE TEXTO PADRONIZADO (Com cores RedeVerde) ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: _redeVerdeGreen.withOpacity(0.7)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: _primaryTextColor.withOpacity(0.6),
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            // Foco na cor Rosa Destaque (Accent Color)
            borderSide: BorderSide(color: _pinkAccent, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          if (labelText.contains('Email') && !value.contains('@')) {
            return 'E-mail inválido';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // --- BANNER ---
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/img/Atalaiabanner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 30.0),

              Text(
                'Criar Nova Conta',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _redeVerdeGreen, // Título Verde Principal
                ),
              ),
              const SizedBox(height: 20.0),

              // --- CAMPOS DE TEXTO ---
              _buildTextField(
                controller: _nomeController,
                labelText: 'Nome Completo',
                icon: Icons.person_outline,
              ),

              _buildTextField(
                controller: _emailController,
                labelText: 'Endereço de Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              _buildTextField(
                controller: _senhaController,
                labelText: 'Senha',
                icon: Icons.lock_outline,
                isPassword: true,
                isObscure: !_isPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),

              _buildTextField(
                controller: _confirmacaoController,
                labelText: 'Confirmar Senha',
                icon: Icons.lock_outline,
                isPassword: true,
                isObscure: !_isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              // --- CHECKBOX E TERMOS ---
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: CheckboxListTile(
                  title: Text(
                    "Aceito os termos de uso e política de privacidade.",
                    style: TextStyle(color: _primaryTextColor),
                  ),
                  value: _aceitouTermos,
                  onChanged: (bool? value) {
                    setState(() {
                      _aceitouTermos = value!;
                    });
                  },
                  activeColor: _redeVerdeGreen, // Checkbox Verde Principal
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 24.0),

              // --- BOTÃO DE REGISTRO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Cor de fundo Verde (Ação Principal)
                      backgroundColor: _redeVerdeGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'REGISTRAR',
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Colors.white, // Texto Branco para contraste
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

              // --- JÁ TEM UMA CONTA? ENTRAR ---
              TextButton(
                onPressed: () {
                  // Assume que a LoginPage existe e pode ser importada/navegada
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  'Já tem uma conta? Entrar',
                  style: TextStyle(
                    color: _redeVerdeGreen, // Link Verde Principal
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- DIVISÓRIA ---
              const SizedBox(width: 300, child: Divider(color: Colors.black26)),
              const SizedBox(height: 20),

              // --- TEXTO CONTINUAR COM ---
              Text(
                'Ou continue com',
                style: TextStyle(
                  color: _primaryTextColor, // Cor escura para o texto
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),

              // --- ÍCONES SOCIAIS (Cores adaptadas para a paleta) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícones sociais com Destaque Rosa
                  FaIcon(FontAwesomeIcons.google, size: 30, color: _pinkAccent),
                  const SizedBox(width: 20),
                  FaIcon(
                    FontAwesomeIcons.apple,
                    size: 30,
                    color: _primaryTextColor,
                  ), // Cor escura
                  const SizedBox(width: 20),
                  FaIcon(
                    FontAwesomeIcons.facebook,
                    size: 30,
                    color: _pinkAccent,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}