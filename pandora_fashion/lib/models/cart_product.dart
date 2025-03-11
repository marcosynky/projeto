import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/item_size.dart';
import 'package:pandora_fashion/models/product.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CartProduct extends ChangeNotifier {
  // Construtor que cria um CartProduct a partir de um Product
  CartProduct.fromProduct(this.product) {
    id = ''; // Inicializa o ID com uma string vazia
    productId = product.id; // Obtém o ID do produto
    quantity = 1; // Inicializa a quantidade com 1
    size = product.selectedSize.name; // Obtém o tamanho selecionado do produto
  }

  // Construtor que cria um CartProduct a partir de um ParseObject do Parse Server
  CartProduct.fromParseObject(ParseObject document) {
    id = document.objectId!; // Inicializa o ID a partir do objeto Parse
    productId =
        document.get<String>('pid') ?? ''; // Obtém o ID do produto no carrinho
    quantity =
        document.get<int>('quantity') ?? 1; // Quantidade do produto no carrinho
    size = document.get<String>('size') ?? ''; // Tamanho do produto no carrinho

    // Inicializa o produto como um objeto Product vazio antes de carregar do Parse
    product = Product(id: '', name: '', description: '', images: [], sizes: []);

    // Carrega o produto do Parse
    _loadProductFromParse();
  }

  late String id; // ID do produto no carrinho
  late String productId; // ID do produto
  late int quantity; // Quantidade do produto no carrinho
  late String size; // Tamanho do produto no carrinho

  late Product product; // Referência ao produto

  // Função para carregar o produto do Parse Server
  Future<void> _loadProductFromParse() async {
    final productQuery = QueryBuilder<ParseObject>(ParseObject('Product'))
      ..whereEqualTo(
        'objectId',
        productId,
      ); // Consulta o produto no Parse Server

    final ParseResponse productResponse = await productQuery.query();

    if (productResponse.success && productResponse.results != null) {
      product = Product.fromParseObject(productResponse.results![0]);
      notifyListeners(); // Notifica os listeners para atualizar a interface
    } else {
      print(
        'Erro ao carregar o produto do Parse: ${productResponse.error?.message}',
      );
    }
  }

  // Getter que retorna o tamanho do produto
  ItemSize? get itemSize {
    return product.findSize(
      size,
    ); // Busca o tamanho do produto na lista de tamanhos
  }

  // Getter que retorna o preço unitário do produto
  num get unitPrice {
    final itemSize = product.findSize(
      size,
    ); // Busca o tamanho do produto na lista
    return itemSize?.price ?? 0.0; // Retorna o preço do tamanho ou 0.0
  }

  // Getter que retorna o preço total (unitPrice * quantity)
  num get totalPrice {
    return unitPrice * quantity;
  }

  // Converte o CartProduct para um Map
  Map<String, dynamic> toCartItemMap() {
    return {'pid': productId, 'quantity': quantity, 'size': size};
  }

  // Verifica se o produto pode ser empilhado (mesmo ID e tamanho)
  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  // Incrementa a quantidade do produto
  void increment() {
    quantity++;
    notifyListeners();
  }

  // Decrementa a quantidade do produto
  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  // Verifica se o estoque é suficiente para a quantidade
  bool get hasStock {
    final itemSize = this.itemSize;
    if (itemSize == null) return false;
    return itemSize.stock >= quantity;
  }

  // Função para salvar o CartProduct no Parse Server
  Future<void> saveToCart() async {
    final cartItem =
        ParseObject('CartItem')
          ..set('pid', productId)
          ..set('quantity', quantity)
          ..set('size', size)
          ..set(
            'product',
            ParseObject('Product')..objectId = productId,
          ); // Relaciona o produto

    final ParseResponse response = await cartItem.save();

    if (response.success) {
      id = response.result!.objectId!;
      print('Produto adicionado ao carrinho');
    } else {
      print('Erro ao salvar produto no carrinho: ${response.error?.message}');
    }
  }

  // Função para atualizar o CartProduct no Parse Server
  Future<void> updateCart() async {
    final cartItem = ParseObject('CartItem')..objectId = id;
    cartItem.set('quantity', quantity);

    final ParseResponse response = await cartItem.save();

    if (response.success) {
      print('Produto atualizado no carrinho');
    } else {
      print(
        'Erro ao atualizar produto no carrinho: ${response.error?.message}',
      );
    }
  }

  // Função para remover o CartProduct do Parse Server
  Future<void> removeFromCart() async {
    final cartItem = ParseObject('CartItem')..objectId = id;

    final ParseResponse response = await cartItem.delete();

    if (response.success) {
      print('Produto removido do carrinho');
    } else {
      print('Erro ao remover produto do carrinho: ${response.error?.message}');
    }
  }
}
