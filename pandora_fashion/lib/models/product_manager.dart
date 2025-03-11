import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/product.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// Classe ProductManager que estende ChangeNotifier para gerenciar os produtos
class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  List<Product> allProducts = []; // Lista que armazena todos os produtos

  String? _search = ''; // String para armazenar o termo de busca

  String? get search => _search; // Getter para o termo de busca

  set search(String? value) {
    _search = value; // Define o valor do termo de busca
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  List<Product> get filteredProducts {
    if (_search == null || _search!.isEmpty) {
      return allProducts; // Retorna todos os produtos se não houver termo de busca
    } else {
      return allProducts
          .where((p) => p.name.toLowerCase().contains(_search!.toLowerCase()))
          .toList(); // Retorna os produtos que correspondem ao termo de busca
    }
  }

  // Método para carregar todos os produtos do Parse Server
  Future<void> _loadAllProducts() async {
    try {
      // Fazendo a consulta para o Parse Server
      final query = QueryBuilder<ParseObject>(ParseObject('Product'));
      final response = await query.query();

      if (response.success && response.results != null) {
        allProducts =
            response.results!.map((doc) {
              final product = Product.fromParseObject(doc as ParseObject);
              return product;
            }).toList(); // Mapeia os documentos para objetos Product

        notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
      } else {
        // Caso a resposta não seja bem-sucedida
        print("Erro ao carregar produtos: ${response.error?.message}");
        // Opcional: você pode exibir uma mensagem de erro ou tratar a falha de outra forma
      }
    } catch (e) {
      // Tratar qualquer erro que possa ocorrer durante a consulta ao Parse Server
      print("Erro ao carregar produtos: $e");
      // Aqui, você pode exibir um Toast ou alguma mensagem para o usuário
    }
  }

  // Função para encontrar um produto pelo ID
  Product? findProductById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null; // Retorna null se o produto não for encontrado
    }
  }
}
