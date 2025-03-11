import 'package:flutter/material.dart';
import 'package:pandora_fashion/models/section.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  List<Section> sections = [];

  Future<void> _loadSections() async {
    final query = QueryBuilder<ParseObject>(
      ParseObject('Home'),
    ); // Consulta a classe "Home" no Parse Server

    try {
      final ParseResponse response = await query.query(); // Executa a consulta

      if (response.success && response.results != null) {
        sections.clear(); // Limpa a lista antes de adicionar novas seções

        for (final parseObject in response.results!) {
          final section = Section.fromParseObject(parseObject as ParseObject);
          sections.add(section);

          for (final item in section.items) {
            print('Loaded image URL: ${item.image}');
          }
        }
        notifyListeners(); // Notifica os listeners após carregar as seções
      } else {
        print('Erro ao carregar seções: ${response.error?.message}');
        sections = []; // Garante que as seções estarão vazias em caso de erro
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao carregar seções: $e');
      sections = []; // Garante que as seções estarão vazias em caso de erro
      notifyListeners();
    }
  }
}
