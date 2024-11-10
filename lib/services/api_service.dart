import 'dart:convert';
import 'package:flutter_application_historys/models/autor.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Historia>> getHistorias() async {
    final response = await http.get(
      Uri.parse('$baseUrl/historias'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); 
      List jsonResponse = json.decode(decodedBody);
      return jsonResponse.map((item) => Historia.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar histórias');
    }
  }

  Future<List<Autor>> getAutores() async {
    final response = await http.get(
      Uri.parse('$baseUrl/autores'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); 
      List jsonResponse = json.decode(decodedBody);
      return jsonResponse.map((item) => Autor.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar autores');
    }
  }

  Future<Historia> createHistoria(Historia historia) async {
    final response = await http.post(
      Uri.parse('$baseUrl/historias'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: json.encode(historia.toJson()),
    );
    if (response.statusCode == 201) {
      return Historia.fromJson(json.decode(utf8.decode(response.bodyBytes))); 
    } else {
      throw Exception('Falha ao criar história');
    }
  }

  Future<void> updateHistoria(Historia historia) async {
    final response = await http.put(
      Uri.parse('$baseUrl/historias/${historia.id}'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: json.encode(historia.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar história');
    }
  }

Future<void> deleteHistoria(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/historias/$id'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception('Falha ao deletar história');
  }
}

}
