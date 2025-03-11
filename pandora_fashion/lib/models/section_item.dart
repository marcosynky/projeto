// Classe SectionItem que representa um item de uma seção
class SectionItem {
  SectionItem({
    required this.image, // URL da imagem
    this.product, // ID do produto, pode ser nulo
  });

  final String image; // Atributo que armazena a URL da imagem
  final String? product; // Atributo que armazena o ID do produto, pode ser nulo

  // Factory para criar uma instância de SectionItem a partir de um mapa
  factory SectionItem.fromMap(Map<String, dynamic> map) {
    // Verifica se a chave existe e se o valor é do tipo esperado
    final image = map['image'] is String ? map['image'] as String : '';
    final product = map['product'] is String ? map['product'] as String : null;

    return SectionItem(
      image: image, // Inicializa a URL da imagem
      product: product, // Inicializa o ID do produto, pode ser nulo
    );
  }

  // Método para converter a instância de SectionItem para uma string
  @override
  String toString() {
    return 'SectionItem{image: $image, product: ${product ?? "não disponível"}}';
    // Se 'product' for nulo, exibe "não disponível" ao invés de null
  }
}
