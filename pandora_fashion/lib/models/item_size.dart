class ItemSize {
  String name; // Nome do item
  double price; // Preço do item
  int stock; // Estoque do item

  // Construtor
  ItemSize({required this.name, required this.price, required this.stock});

  // Propriedade para verificar se há estoque disponível
  bool get hasStock => stock > 0;

  // Construtor a partir de um mapa
  ItemSize.fromMap(Map<String, dynamic> map)
    : name = map['name'] as String,
      price =
          map['price']
              as double, // Certifique-se de que o preço seja convertido para double
      stock = map['stock'] as int {
    // Valida o estoque ao criar a partir do mapa
    if (stock < 0) {
      throw ArgumentError('O estoque não pode ser negativo');
    }
  }

  // Método para converter a instância para um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name, // Nome do item
      'price': price, // Preço do item
      'stock': stock, // Estoque do item
    };
  }

  @override
  String toString() {
    // Sobrescreve o método toString para retornar uma string com as propriedades do item
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}
