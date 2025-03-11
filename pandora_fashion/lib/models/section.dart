import 'package:pandora_fashion/models/section_item.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'; // Importa o SDK do Parse Server

// Classe Section que representa uma seção
class Section {
  String name; // Nome da seção
  String type; // Tipo da seção
  List<SectionItem> items; // Lista de itens da seção

  // Construtor que cria uma instância de Section a partir de um ParseObject
  Section.fromParseObject(ParseObject parseObject)
    : name =
          parseObject.get<String>('name') ??
          'Nome não disponível', // Inicializa o nome da seção com valor default
      type =
          parseObject.get<String>('type') ??
          'Tipo não disponível', // Inicializa o tipo da seção com valor default
      items =
          (parseObject.get<List>('items') ?? []).map((item) {
            // Verifica e mapeia a lista de itens, ou inicializa como uma lista vazia
            return SectionItem.fromMap(item as Map<String, dynamic>);
          }).toList();

  // Método para converter a instância de Section para uma string
  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: ${items.join(', ')}}';
    // A junção dos itens torna a string mais legível
  }
}
