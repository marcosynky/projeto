import 'package:flutter/material.dart';
import 'package:pandora_fashion/screens/base_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
// Importe o PageManager aqui

void main() async {
  // Garantir que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o Parse SDK
  await initializeParse();

  runApp(MyApp());
}

// Função para inicializar o Parse SDK
Future<void> initializeParse() async {
  try {
    const String appId = 'xnugxrXBR6RusrwHTNwVuynUmOYR3Cu708gIh0Xc';
    const String clientKey = 'JvoJylkMNEi8iAssw7Qlgh27cvuOqaDL9don6NPe';
    const String parseServerUrl = 'https://parseapi.back4app.com/';

    final parse = Parse();
    await parse.initialize(
      appId,
      parseServerUrl,
      clientKey: clientKey,
      debug: true, // Habilita o modo de debug (opcional)
    );
  } catch (e) {
    print('Erro ao inicializar o Parse SDK: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(), // Função que retorna a rota inicial
      builder: (context, snapshot) {
        // Se o Future ainda não foi resolvido
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pandora_Fashion',
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ), // Exibe o carregamento
            ),
          );
        }

        // Caso o Future seja resolvido, continua com o MaterialApp com a rota inicial
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pandora Fashion',
            initialRoute: snapshot.data, // Usando a rota retornada
            routes: {
              '/': (context) => LoginScreen(),
              '/register': (context) => RegisterScreen(),
              '/base': (context) => BaseScreen(),
            },
          );
        }

        // Se o Future falhou, exibe uma tela de erro
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pandora Fashion',
          home: Scaffold(
            body: Center(child: Text('Erro ao carregar a tela inicial')),
          ),
        );
      },
    );
  }

  // Função para definir a rota inicial com base na autenticação do usuário
  Future<String> _getInitialRoute() async {
    // Verificando se o usuário está autenticado
    ParseUser? user = await ParseUser.currentUser();

    // Adicione a verificação para garantir que 'user' não é null
    if (user != null) {
      return '/base'; // Se o usuário estiver logado, leva para a tela principal
    } else {
      return '/'; // Caso contrário, vai para a tela de login
    }
  }
}
