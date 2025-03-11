import 'package:flutter/material.dart';
import 'package:pandora_fashion/common/custom/custom_drawer.dart';
import 'package:pandora_fashion/common/minhas_cores.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
            elevation: 0,
            toolbarHeight: 70.0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Pandora Fashion', // Título da AppBar
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 200, // Define a altura do container
              color:
                  Colors
                      .white, // Define a cor de fundo do container como branco
            ),
          ),
        ],
      ),
    );
  }
}
