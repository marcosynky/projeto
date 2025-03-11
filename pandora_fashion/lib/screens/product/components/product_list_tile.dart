import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/produtos', arguments: product);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 150,
          ), // Definição de tamanho mínimo
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinhamento correto dos elementos
            children: [
              SizedBox(
                // Define um tamanho fixo para a imagem
                width: 100,
                height: 100,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.network(
                    product.images.isNotEmpty
                        ? product.images.first
                        : 'https://via.placeholder.com/150', // Imagem padrão
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                // Garante que o texto não quebre o layout
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 19.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        product.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        "A partir de",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24, // Evita problemas de altura variável
                      child: FutureBuilder<num>(
                        future: product.basePriceAsync,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              "Carregando...",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 19.0,
                                color: Colors.grey,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text(
                              "Erro ao carregar",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 19.0,
                                color: Colors.red,
                              ),
                            );
                          } else {
                            final preco = snapshot.data ?? 0;
                            if (preco == 0) {
                              return const Text(
                                "Sem estoque",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 19.0,
                                  color: Colors.red,
                                ),
                              );
                            }

                            return Text(
                              "R\$ ${preco.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 19.0,
                                color: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
