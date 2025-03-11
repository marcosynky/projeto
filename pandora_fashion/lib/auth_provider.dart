import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthProvider with ChangeNotifier {
  ParseUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters para acesso ao estado atual do usuário, carregamento e erros
  ParseUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Função de login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null; // Limpa a mensagem de erro
    notifyListeners();

    // Valida os campos antes de tentar o login
    if (!await _validateFields(email, password)) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final ParseUser parseUser = ParseUser(email, password, null);
    final ParseResponse response = await parseUser.login();

    if (response.success) {
      _user = parseUser; // Armazena o usuário após o login bem-sucedido
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();

      // Armazenando o token de sessão (isso pode ser feito localmente ou em algum serviço de segurança)

      // Aqui você pode salvar o token para futuras requisições autenticadas (por exemplo, em um armazenamento local seguro)

      return true; // Login bem-sucedido
    } else {
      _errorMessage = response.error?.message ?? "Erro desconhecido";
      _isLoading = false;
      notifyListeners();
      return false; // Login falhou
    }
  }

  // Função de deletar usuário
  Future<void> deleteUser() async {
    if (_user == null) {
      _errorMessage = "Nenhum usuário está logado.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null; // Limpa a mensagem de erro
    notifyListeners();

    try {
      final ParseResponse response = await _user!.delete();

      if (response.success) {
        _user = null; // Limpa a instância do usuário após a exclusão
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        print("Usuário excluído com sucesso.");
      } else {
        _errorMessage = response.error?.message ?? "Erro ao excluir usuário.";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Erro ao tentar deletar o usuário: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  // Função de validação de email e senha
  Future<bool> _validateFields(String email, String password) async {
    if (!_isValidEmail(email)) {
      _errorMessage = "Formato de email inválido.";
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      _errorMessage = "A senha precisa ter no mínimo 6 caracteres.";
      return false;
    }

    return true; // Validação bem-sucedida
  }

  // Verifica se o email tem o formato válido
  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(
      email,
    ); // Retorna verdadeiro se o email for válido
  }

  // Função para verificar se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    if (_user != null) {
      return true;
    } else {
      return false;
    }
  }

  // Função de logout (desfaz a autenticação)
  Future<void> logout() async {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
