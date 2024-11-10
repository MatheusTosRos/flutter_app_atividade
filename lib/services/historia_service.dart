import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/historia.dart';

class HistoriaService {
  // Se estiver rodando no Android Emulator, use 10.0.2.2 ao invés de localhost
  final String baseUrl = 'http://localhost:3000/historias';
  // Para web ou iOS, use:
  // final String baseUrl = 'http://localhost:3000/historias';

  // Função auxiliar para gerar próximo ID
  Future<int> _getNextId() async {
    try {
      final historias = await getHistorias();
      if (historias.isEmpty) return 1;
      
      int maxId = historias.fold(0, (max, historia) => 
        historia.id != null && historia.id! > max ? historia.id! : max);
      return maxId + 1;
    } catch (e) {
      print('Erro ao gerar próximo ID: $e');
      return 1;
    }
  }

  Future<List<Historia>> getHistorias() async {
    try {
      print('Fazendo requisição GET para: $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      print('Status code: ${response.statusCode}');
      print('Resposta: ${response.body}');

      if (response.body.isEmpty) {
        print('Resposta vazia do servidor');
        return [];
      }

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Historia.fromJson(json)).toList();
      } else {
        print('Erro ao carregar histórias. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exceção ao carregar histórias: $e');
      return [];
    }
  }

  Future<Historia?> criarHistoria(Historia historia) async {
    try {
      historia.id = await _getNextId();
      print('Criando história com ID: ${historia.id}');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(historia.toJson()),
      ).timeout(const Duration(seconds: 5));

      print('Status code criação: ${response.statusCode}');
      print('Resposta criação: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return historia;
      } else {
        print('Erro ao criar história. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exceção ao criar história: $e');
      return null;
    }
  }

  Future<Historia?> atualizarHistoria(Historia historia) async {
    try {
      if (historia.id == null) {
        print('Erro: Tentativa de atualizar história sem ID');
        return null;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/${historia.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(historia.toJson()),
      ).timeout(const Duration(seconds: 5));

      print('Status code atualização: ${response.statusCode}');

      if (response.statusCode == 200) {
        return historia;
      } else {
        print('Erro ao atualizar história. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exceção ao atualizar história: $e');
      return null;
    }
  }

  Future<bool> deletarHistoria(int id) async {
    try {
      print('Deletando história com ID: $id');
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      print('Status code deleção: ${response.statusCode}');

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Exceção ao deletar história: $e');
      return false;
    }
  }
}