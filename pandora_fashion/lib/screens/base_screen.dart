import 'package:flutter/material.dart';
import 'package:pandora_fashion/common/minhas_cores.dart';
import 'package:pandora_fashion/models/page_manager.dart';
import 'package:pandora_fashion/screens/home/home_screen.dart';
import 'package:pandora_fashion/screens/product/products_screen.dart';
import 'package:pandora_fashion/screens/pedidos_screen.dart';
import 'package:pandora_fashion/screens/usuarios_screen.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pandora_fashion/models/user_manager.dart';
import 'package:pandora_fashion/common/custom/custom_drawer.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    final userManager = Provider.of<UserManager>(context);
    final pageManager = Provider.of<PageManager>(context);

    // Lista de telas na ordem correta
    List<Widget> screens = [
      HomeScreen(), // Página 0
      ProductsScreen(), // Página 1
      if (userManager.user?.admin ?? false)
        const UsuariosScreen(), // Página 2 (Usuários - Admins)
      if (userManager.user?.admin ?? false)
        const PedidosScreen(), // Página 3 (Pedidos - Admins)
    ];

    // Lista de ícones na ordem correta
    List<Widget> navItems = [
      const Icon(Icons.home, size: 30, color: Colors.white), // Página 0
      const Icon(Icons.shopping_bag, size: 30, color: Colors.white), // Página 1
      if (userManager.user?.admin ?? false) ...[
        const Icon(Icons.people, size: 30, color: Colors.white), // Página 2
        const Icon(Icons.list_alt, size: 30, color: Colors.white), // Página 3
      ],
      const Icon(Icons.location_on, size: 30, color: Colors.white), // Página 4
    ];

    // Garantir que o índice da página não ultrapasse o número de telas
    int currentIndex = pageManager.page;
    if (currentIndex >= screens.length) {
      currentIndex =
          0; // Definir um valor padrão caso o índice esteja fora do alcance
    }

    return Scaffold(
      drawer:
          const CustomDrawer(), // O Drawer é agora visível no Scaffold principal
      appBar: AppBar(
        title: const Text(
          'Pandora Fashion',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: MinhasCores.rosa_1,
        elevation: 0,
        toolbarHeight: 80.0,
      ),
      body: IndexedStack(
        index:
            currentIndex, // Usa o índice validado para garantir que o índice é válido
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: MinhasCores.rosa_1,
        color: MinhasCores.rosa_2,
        buttonBackgroundColor: MinhasCores.rosa_3,
        height: 60,
        items: navItems,
        onTap: (index) {
          pageManager.setPage(index); // Atualiza o índice no PageManager
        },
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}
