import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/user.dart' as user_model;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    as user_model;

// Importa o modelo User com alias

// Classe UserManager que estende ChangeNotifier para gerenciar o usuário
class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser(); // Carrega o usuário ao iniciar o UserManager
  }

  user_model.User? _user; // Usuário atual
  user_model.User? get user => _user; // Getter para o usuário atual

  bool _loading = false; // Variável para indicar o estado de carregamento
  bool get loading => _loading; // Getter para o estado de carregamento
  bool get isLoggedIn => _user != null; // Verifica se o usuário está logado

  // Método para fazer login
  Future<void> signIn({
    required String email, // Email do usuário
    required String password, // Senha do usuário
    required Function(String) onFail, // Função de callback para falha
    required Function(user_model.User)
    onSuccess, // Função de callback para sucesso
  }) async {
    loading = true; // Define o estado de carregamento como verdadeiro

    try {
      final user_model.ParseUser parseUser = user_model.ParseUser(
        email,
        password,
        null,
      );
      final user_model.ParseResponse response = await parseUser.login();

      if (response.success) {
        final userObject = response.result as user_model.ParseObject;
        _user = user_model.User.fromParseObject(userObject);

        await _checkAdminStatus(
          parseUser,
        ); // Verifica se o usuário é administrador
        onSuccess(_user!); // Retorna o usuário autenticado
      } else {
        onFail(response.error?.message ?? "Erro desconhecido");
      }
    } catch (e) {
      onFail("Erro ao fazer login: $e");
    } finally {
      loading = false; // Finaliza o estado de carregamento
      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    }
  }

  // Método para registrar um novo usuário
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required Function(String) onFail,
    required Function(user_model.User) onSuccess,
  }) async {
    loading = true;

    try {
      final user_model.ParseUser parseUser = user_model.ParseUser(
        email,
        password,
        null,
      );
      parseUser.set('name', name);
      final user_model.ParseResponse response = await parseUser.signUp();

      if (response.success) {
        _user = user_model.User(
          id: parseUser.objectId!,
          email: email,
          password: password,
          name: name,
        );

        await _checkAdminStatus(
          parseUser,
        ); // Verifica se o usuário é administrador
        onSuccess(_user!);
      } else {
        onFail(response.error?.message ?? "Erro desconhecido");
      }
    } catch (e) {
      onFail("Erro ao registrar: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    if (_user != null) {
      try {
        user_model.ParseUser currentUser =
            await user_model.ParseUser.currentUser();
        await currentUser
            .logout(); // Agora você pode chamar logout após o await
        _user = null; // Limpa o usuário
        notifyListeners();
      } catch (e) {
        print('Erro ao realizar logout: $e');
      }
    }
  }

  // Setter para o estado de carregamento
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Carrega o usuário atual
  Future<void> _loadCurrentUser() async {
    try {
      user_model.ParseUser? currentUser =
          await user_model.ParseUser.currentUser();
      if (currentUser != null) {
        _user = user_model.User(
          id: currentUser.objectId!, // Obtém o ID diretamente do ParseUser
          email: currentUser.emailAddress!, // Obtém o email diretamente
          password: '', // Não armazena a senha
          name:
              '', // Inicializa com um nome vazio, pois o nome será atualizado depois
        );
        await _checkAdminStatus(
          currentUser,
        ); // Verifica se o usuário é administrador
      } else {
        _user = null;
      }
    } catch (e) {
      print('Erro ao carregar usuário atual: $e');
    } finally {
      notifyListeners();
    }
  }

  // Verifica se o usuário é um administrador
  Future<void> _checkAdminStatus(user_model.ParseUser parseUser) async {
    try {
      final query = user_model.QueryBuilder(user_model.ParseObject('Admins'))
        ..whereEqualTo('user', parseUser);

      final response = await query.query();
      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        _user!.admin = true; // Marca como administrador se encontrado
      }
    } catch (e) {
      print('Erro ao verificar status de administrador: $e');
    }
    notifyListeners();
  }

  // Verifica se o usuário tem permissão de admin
  bool get adminEnabled => user != null && user!.admin;
}
