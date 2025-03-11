import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/cart_product.dart';
import 'package:pandora_fashion/models/product.dart';
import 'package:pandora_fashion/models/user.dart';
import 'package:pandora_fashion/models/user_manager.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];
  User? user;
  num productsPrice = 0.0;

  // Atualiza o usuário e carrega os itens do carrinho
  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();
    if (user != null) {
      _loadCartItems();
    }
  }

  // Carrega os itens do carrinho do Parse Server
  Future<void> _loadCartItems() async {
    if (user != null) {
      final query = QueryBuilder<ParseObject>(ParseObject('CartItem'))
        ..whereEqualTo('user', ParseObject('_User')..set('objectId', user!.id));

      final ParseResponse response = await query.query();
      if (response.success && response.results != null) {
        items =
            response.results!
                .map(
                  (e) =>
                      CartProduct.fromParseObject(e)
                        ..addListener(_onItemUpdate),
                )
                .toList();
        notifyListeners();
      } else {
        print('Erro ao carregar itens do carrinho: ${response.error?.message}');
      }
    }
  }

  // Adiciona um produto ao carrinho
  void addToCart(Product product) {
    try {
      final existingProduct = items.firstWhere((p) => p.stackable(product));
      existingProduct.increment();
      _updateCartProduct(existingProduct);
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);

      final parseCartItem =
          ParseObject('CartItem')
            ..set('user', ParseObject('_User')..set('objectId', user!.id))
            ..set('product', product.toParseObject())
            ..set('quantity', cartProduct.quantity);

      parseCartItem.save().then((parseResponse) {
        cartProduct.id = parseResponse.result!.objectId;
        _updateCartProduct(cartProduct);
      });

      notifyListeners();
    }
  }

  // Função chamada quando um item é atualizado
  void _onItemUpdate() {
    productsPrice = 0.0;
    final itemsToRemove = <CartProduct>[];

    for (final cartProduct in items) {
      if (cartProduct.quantity == 0) {
        itemsToRemove.add(cartProduct);
      } else {
        productsPrice += cartProduct.totalPrice;
        _updateCartProduct(cartProduct);
      }
    }

    // Remove itens que foram excluídos
    for (final cartProduct in itemsToRemove) {
      removeFromCart(cartProduct);
    }
    notifyListeners();
  }

  // Remove um produto do carrinho
  void removeFromCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    final cartItem = ParseObject('CartItem')..set('objectId', cartProduct.id);
    cartItem.delete().then((response) {
      if (response.success) {
        print('Produto removido com sucesso');
      } else {
        print('Erro ao remover produto: ${response.error?.message}');
      }
    });

    cartProduct.removeListener(_onItemUpdate);
    notifyListeners();
  }

  // Atualiza o produto no Parse Server
  void _updateCartProduct(CartProduct cartProduct) {
    if (user != null) {
      final cartItem = ParseObject('CartItem')..set('objectId', cartProduct.id);
      cartItem.set('quantity', cartProduct.quantity);
      cartItem.save().then((response) {
        if (!response.success) {
          print(
            'Erro ao atualizar produto no carrinho: ${response.error?.message}',
          );
        }
      });
    }
  }

  // Verifica se o carrinho é válido (se todos os produtos têm estoque)
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false;
      }
    }
    return true;
  }

  // Verifica se todos os produtos têm estoque
  bool get hasStock {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false;
      }
    }
    return true;
  }
}
