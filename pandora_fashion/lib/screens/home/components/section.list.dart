import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/section.dart';
import 'package:pandora_fashion/screens/home/components/item_tile.dart';
import 'package:pandora_fashion/screens/home/components/section_header.dart'; // Importa o pacote Flutter para construção de interfaces
// Importa o componente SectionHeader

// Classe SectionList que estende StatelessWidget para criar uma lista de seção
class SectionList extends StatelessWidget {
  final Section section; // Declaração do atributo section

  const SectionList(
    this.section, {
    super.key,
  }); // Construtor da classe SectionList

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // Define a margem horizontal e vertical do container
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinha os itens da coluna à esquerda
        children: <Widget>[
          SectionHeader(section), // Adiciona o cabeçalho da seção
          SizedBox(
            height: 150, // Define a altura do ListView
            child: ListView.separated(
              scrollDirection:
                  Axis.horizontal, // Define a direção de rolagem como horizontal
              itemBuilder: (_, index) {
                return ItemTile(section.items[index]);
              }, // Cria um ItemTile para cada item na seção
              separatorBuilder:
                  (_, __) => const SizedBox(
                    width: 4,
                  ), // Define o espaçamento entre os itens da lista
              itemCount:
                  section.items.length, // Define o número de itens na lista
            ),
          ),
        ],
      ),
    );
  }
}
