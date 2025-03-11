import 'package:flutter/material.dart';

// Classe PageManager que gerencia a página atual
class PageManager extends ChangeNotifier {
  PageManager(); // Construtor sem argumentos, já que não precisamos de um PageController

  int page = 0; // Variável que armazena a página atual

  // Método para definir a página atual com animação
  void setPage(
    int value, {
    Duration duration = const Duration(
      milliseconds: 300,
    ), // Define a duração da animação
    Curve curve = Curves.ease, // Define a curva da animação
  }) {
    if (value != page) {
      // Evita a navegação para a mesma página
      page = value; // Atualiza a página atual
      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    }
  }
}
