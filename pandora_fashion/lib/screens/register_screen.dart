import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pandora_fashion/common/minhas_cores.dart';
import 'package:pandora_fashion/models/decoration_screen.dart';
import 'package:pandora_fashion/screens/login_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  bool _obscureText = true; // Controla a visibilidade da senha
  bool _obscureConfirmText =
      true; // Controla a visibilidade da confirmação da senha

  // Função para alternar a visibilidade da senha
  void toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Função para alternar a visibilidade da confirmação da senha
  void toggleConfirmVisibility() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    isLoading.dispose();
    super.dispose();
  }

  // Função que realiza o registro do usuário
  // Função que realiza o registro do usuário
  Future<void> _register() async {
    // Verificando se os campos estão preenchidos
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showToast(
        'Todos os campos são obrigatórios!',
        context: context,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
        toastHorizontalMargin: 20,
        borderRadius: BorderRadius.circular(8),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showToast(
        'As senhas não coincidem!',
        context: context,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
        toastHorizontalMargin: 20,
        borderRadius: BorderRadius.circular(8),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Criando um novo usuário no Parse
      final user = ParseUser(
        usernameController.text,
        passwordController.text,
        emailController.text,
      );

      // Realizando o signup no Parse
      var response = await user.signUp();

      isLoading.value = false;

      if (response.success) {
        showToast(
          'Cadastro realizado com sucesso!',
          context: context,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          textStyle: const TextStyle(color: Colors.white),
          toastHorizontalMargin: 20,
          borderRadius: BorderRadius.circular(8),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/base');
      } else {
        showToast(
          response.error!.message,
          // ignore: use_build_context_synchronously
          context: context,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
          toastHorizontalMargin: 20,
          borderRadius: BorderRadius.circular(8),
        );
      }
    } catch (e) {
      // Em caso de erro inesperado
      isLoading.value = false;
      showToast(
        'Erro ao realizar o cadastro: $e',
        context: context,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
        toastHorizontalMargin: 20,
        borderRadius: BorderRadius.circular(8),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fundo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Já tem uma conta? Faça login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white.withOpacity(0.20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Campo de nome de usuário
                          TextFormField(
                            controller: usernameController,
                            decoration: getAuthenticationInputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: MinhasCores.rosa_1,
                              ),
                              hintText: 'Nome de usuário',
                              suffixIcon: null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Campo de email
                          TextFormField(
                            controller: emailController,
                            decoration: getAuthenticationInputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: MinhasCores.rosa_1,
                              ),
                              hintText: 'Email',
                              suffixIcon: null,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 8),
                          // Campo de senha
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            decoration: getAuthenticationInputDecoration(
                              prefixIcon: const Icon(
                                Icons.vpn_key_sharp,
                                color: MinhasCores.rosa_1,
                              ),
                              hintText: 'Senha',
                              suffixIcon: GestureDetector(
                                onTap: toggleVisibility,
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: MinhasCores.rosa_1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Campo de confirmar senha
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: _obscureConfirmText,
                            decoration: getAuthenticationInputDecoration(
                              prefixIcon: const Icon(
                                Icons.vpn_key_sharp,
                                color: MinhasCores.rosa_1,
                              ),
                              hintText: 'Confirmar Senha',
                              suffixIcon: GestureDetector(
                                onTap: toggleConfirmVisibility,
                                child: Icon(
                                  _obscureConfirmText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: MinhasCores.rosa_1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Botão de registro
                          ValueListenableBuilder<bool>(
                            valueListenable: isLoading,
                            builder: (context, loading, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: MinhasCores.rosa_1
                                      .withAlpha(120),
                                  backgroundColor: MinhasCores.rosa_1,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: loading ? null : () => _register(),
                                child:
                                    loading
                                        ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.app_registration,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Registrar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ],
                                        ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
