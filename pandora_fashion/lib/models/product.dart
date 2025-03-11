import 'package:pandora_fashion/models/item_size.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Product {
  late String id;
  late String name;
  late String description;
  late List<String> images;
  late List<ItemSize> sizes;
  late double basePrice;
  late ItemSize selectedSize; // Campo para armazenar o tamanho selecionado

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.sizes,
  });

  // Método para buscar o tamanho na lista de tamanhos
  ItemSize? findSize(String sizeName) {
    try {
      return sizes.firstWhere(
        (size) => size.name == sizeName,
      ); // Retorna o tamanho correspondente
    } catch (e) {
      return null; // Retorna null se o tamanho não for encontrado
    }
  }

  // Método para converter o Product em ParseObject
  ParseObject toParseObject() {
    final productObject =
        ParseObject('Product')
          ..set('name', name)
          ..set('description', description)
          ..set('images', images)
          ..set('sizes', sizes.map((s) => s.toMap()).toList());
    return productObject;
  }

  // Definindo o método fromParseObject para criar a instância de Product a partir do ParseObject
  Product.fromParseObject(ParseObject parseObject) {
    id = parseObject.objectId!;
    name = parseObject.get<String>('name')!;
    description = parseObject.get<String>('description')!;
    images = List<String>.from(parseObject.get<List>('images') ?? []);
    sizes =
        (parseObject.get<List>('sizes') ?? [])
            .map((size) => ItemSize.fromMap(size as Map<String, dynamic>))
            .toList();
    selectedSize =
        sizes.isNotEmpty
            ? sizes.first
            : ItemSize(
              name: '',
              price: 0,
              stock: 0,
            ); // Inicializa o selectedSize com o primeiro tamanho ou vazio
  }
  Future<void> updateProductToParse({
    List<String>? images,
    List<ItemSize>? sizes,
  }) async {
    final productObject =
        ParseObject('Product')
          ..set('name', name)
          ..set('description', description)
          ..set(
            'images',
            images ?? this.images,
          ) // Se images for null, usa a lista de imagens atual
          ..set(
            'sizes',
            sizes?.map((s) => s.toMap()).toList() ?? this.sizes,
          ); // Se sizes for null, usa os tamanhos atuais

    final ParseResponse response = await productObject.save();
    if (response.success) {
      id = response.result!.objectId!;
      print('Produto atualizado com sucesso');
    } else {
      print('Erro ao atualizar produto: ${response.error?.message}');
    }
  }

  // Método para salvar o produto no Parse
  Future<void> saveToParse() async {
    final productObject =
        ParseObject('Product')
          ..set('name', name)
          ..set('description', description)
          ..set('images', images)
          ..set('sizes', sizes.map((s) => s.toMap()).toList());

    final ParseResponse response = await productObject.save();
    if (response.success) {
      id = response.result!.objectId!; // Atualiza o ID do produto
      print('Produto salvo com sucesso');
    } else {
      print('Erro ao salvar produto: ${response.error?.message}');
      throw Exception('Erro ao salvar produto');
    }
  }

  // Método para clonar um produto
  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(
        images,
      ), // Cria uma nova lista para não afetar a original
      sizes: List.from(sizes), // Cria uma nova lista para não afetar a original
    );
  }

  // Getter para basePrice
  Future<num> get basePriceAsync async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simula atraso assíncrono
    return sizes.isNotEmpty ? sizes.first.price : 0.0;
  }
}
