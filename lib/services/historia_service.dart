import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/historia.dart';

class HistoriaService {
  final String baseUrl = 'http://localhost:3000/historias';

  Future<List<Historia>> getHistorias() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Historia.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar histórias');
    }
  }

  Future<Historia> criarHistoria(Historia historia) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(historia.toJson()),
    );
    if (response.statusCode == 201) {
      return Historia.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar história');
    }
  }

  Future<Historia> atualizarHistoria(Historia historia) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${historia.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(historia.toJson()),
    );
    if (response.statusCode == 200) {
      return Historia.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar história');
    }
  }

  Future<void> deletarHistoria(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar história');
    }
  }
}
