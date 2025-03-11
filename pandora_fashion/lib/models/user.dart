import 'package:flutter/foundation.dart'; // Importa o foundation.dart para utilizar funcionalidades do Flutter
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'; // Importa o Parse SDK para interação com o Parse Server

// Classe User que representa um usuário
class User {
  User({
    this.id = '', // Inicializa o ID com uma string vazia
    required this.email, // Email do usuário
    required this.password, // Senha do usuário
    required this.name, // Nome do usuário
    this.confirmPassword =
        '', // Inicializa a confirmação de senha com uma string vazia
    this.admin = false, // Inicializa o campo admin como false
  });

  // Factory para criar um objeto User a partir de um ParseObject
  factory User.fromParseObject(ParseObject parseObject) {
    return User(
      id: parseObject.objectId!, // Obtém o ID do ParseObject
      email: parseObject.get<String>('email')!, // Obtém o email do ParseObject
      name: parseObject.get<String>('name')!, // Obtém o nome do ParseObject
      password: '', // Inicializa a senha com uma string vazia
      admin:
          parseObject.get<bool>('admin') ??
          false, // Obtém o campo admin ou inicializa como false
    );
  }

  String id; // ID do usuário
  String name; // Nome do usuário
  String email; // Email do usuário
  String password; // Senha do usuário
  String confirmPassword; // Confirmação da senha
  bool admin; // Indica se o usuário é admin

  // Referência ao ParseObject do usuário
  ParseObject get parseRef => ParseObject('User')..objectId = id;

  // Método para salvar os dados do usuário no Parse Server
  Future<String?> saveData() async {
    // Verifica se os campos obrigatórios são preenchidos
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      return 'Campos obrigatórios não preenchidos';
    }

    try {
      final parseObject =
          ParseObject('User')
            ..set('name', name)
            ..set('email', email)
            ..set('admin', admin);

      if (id.isNotEmpty) {
        parseObject.objectId =
            id; // Se o id já existir, o objeto será atualizado
      }

      final response =
          await parseObject
              .save(); // Salva ou atualiza o usuário no Parse Server

      if (!response.success) {
        return 'Erro ao salvar dados do usuário: ${response.error?.message}';
      }
      return null; // Retorna null se o salvamento foi bem-sucedido
    } catch (e) {
      debugPrint(
        'Erro ao salvar dados do usuário: $e',
      ); // Imprime uma mensagem de erro se a operação falhar
      return 'Erro desconhecido: $e';
    }
  }

  // Método para validar se a senha e a confirmação da senha são iguais
  bool validatePassword() {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return false; // Não permite validação se uma das senhas estiver vazia
    }
    return password == confirmPassword; // Compara se as senhas são iguais
  }

  // Método para validar se a senha tem um tamanho mínimo
  bool isPasswordValid() {
    return password.length >=
        6; // Verifica se a senha tem pelo menos 6 caracteres
  }
}
