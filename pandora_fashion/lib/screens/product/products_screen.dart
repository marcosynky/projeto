import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:pandora_fashion/common/custom/custom_drawer.dart'; // Importa o CustomDrawer
import 'package:pandora_fashion/common/minhas_cores.dart'; // Importa as cores personalizadas
import 'package:pandora_fashion/models/product_manager.dart'; // Importa o ProductManager
import 'package:pandora_fashion/models/user_manager.dart'; // Importa o UserManager
import 'package:pandora_fashion/screens/product/components/product_list_tile.dart'; // Importa o ProductListTile
import 'package:pandora_fashion/screens/product/components/search_dialog.dart'; // Importa o SearchDialog
import 'package:provider/provider.dart'; // Importa o Provider

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor:
              MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
          drawer: const CustomDrawer(), // Adiciona o drawer personalizado
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu), // Ícone de menu
                  color: Colors.white, // Cor do ícone
                  onPressed:
                      () => Scaffold.of(context).openDrawer(), // Abre o drawer
                );
              },
            ),
            title: Consumer<ProductManager>(
              builder: (_, productManager, __) {
                if (productManager.search == null ||
                    productManager.search!.isEmpty) {
                  return const Text(
                    "Produtos\nCamisetas", // Título da AppBar
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                        context: context,
                        builder:
                            (_) => SearchDialog(
                              initialText: productManager.search!,
                            ),
                      );
                      if (search != null) {
                        productManager.search =
                            search; // Atualiza o termo de busca
                      }
                    },
                    child: Text(
                      productManager.search!,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  );
                }
              },
            ),
            centerTitle: true, // Centraliza o título
            backgroundColor:
                MinhasCores.rosa_1, // Define a cor de fundo da AppBar
            elevation: 0, // Remove a sombra da AppBar
            toolbarHeight: 90.0, // Define a altura da AppBar
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.0),
              ),
            ),
            actions: [
              Consumer<ProductManager>(
                builder: (_, productManager, __) {
                  if (productManager.search == null ||
                      productManager.search!.isEmpty) {
                    return IconButton(
                      onPressed: () async {
                        final search = await showDialog<String>(
                          context: context,
                          builder: (_) => const SearchDialog(initialText: ''),
                        );
                        if (search != null) {
                          context.read<ProductManager>().search =
                              search; // Atualiza o termo de busca
                        }
                      },
                      icon: const Icon(
                        Icons.search, // Ícone de busca
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        context.read<ProductManager>().search =
                            ''; // Limpa o termo de busca
                      },
                      icon: const Icon(
                        Icons.close, // Ícone de fechar
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/edit_product');
                      },
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          body: Consumer<ProductManager>(
            builder: (_, productManager, __) {
              final filteredProducts = productManager.filteredProducts;

              // Verifica se a lista de produtos está vazia e mostra um indicador de carregamento
              if (filteredProducts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Exibe o carregando enquanto busca
              }

              return ListView.builder(
                padding: const EdgeInsets.all(
                  4.0,
                ), // Define o padding do ListView
                itemCount: filteredProducts.length, // Define o número de itens
                itemBuilder: (_, index) {
                  return ProductListTile(
                    product:
                        filteredProducts[index], // Passa o produto para o tile
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor:
                MinhasCores.rosa_3, // Define a cor do FloatingActionButton
            foregroundColor:
                Colors.white, // Cor do ícone do FloatingActionButton
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed('/cart'), // Navega para a tela de carrinho
            child: const Icon(Icons.shopping_cart), // Ícone de carrinho
          ),
        ),
      ],
    );
  }
}
