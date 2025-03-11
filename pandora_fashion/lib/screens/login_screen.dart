import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:pandora_fashion/auth_provider.dart'; // Import AuthProvider
import 'package:pandora_fashion/common/minhas_cores.dart';
import 'package:pandora_fashion/models/decoration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);

  // Função para alternar a visibilidade da senha
  void toggleVisibility() {
    _obscureTextNotifier.value = !_obscureTextNotifier.value;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  // Função que realiza o login
  Future<void> _login(AuthProvider authProvider) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showToast(
        'Por favor, preencha todos os campos.',
        context: context,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
        toastHorizontalMargin: 20,
        borderRadius: BorderRadius.circular(8),
      );
      return;
    }

    // Chama o método de login do AuthProvider
    final success = await authProvider.login(
      emailController.text,
      passwordController.text,
    );

    if (success) {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/base',
        ); // Navega para a tela principal após login
      }
    } else {
      showToast(
        authProvider.errorMessage ?? 'Falha no login. Tente novamente!',
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
                Navigator.pushNamed(
                  context,
                  '/register',
                ); // Navega para a tela de registro
              },
              child: const Text(
                'Criar Conta',
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
                          ValueListenableBuilder<bool>(
                            valueListenable: _obscureTextNotifier,
                            builder: (context, obscureText, child) {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: obscureText,
                                decoration: getAuthenticationInputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.vpn_key_sharp,
                                    color: MinhasCores.rosa_1,
                                  ),
                                  hintText: 'Senha',
                                  suffixIcon: GestureDetector(
                                    onTap: toggleVisibility,
                                    child: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: MinhasCores.rosa_1,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Implementação de recuperação de senha pode ser adicionada aqui
                              },
                              child: const Text(
                                'Esqueceu a senha?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ValueListenableBuilder<bool>(
                            valueListenable:
                                authProvider.isLoading
                                    ? ValueNotifier<bool>(true)
                                    : ValueNotifier<bool>(false),
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
                                onPressed:
                                    loading
                                        ? null
                                        : () => _login(
                                          authProvider,
                                        ), // Desabilita o botão enquanto está carregando
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
                                              Icons.login_rounded,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Login',
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
