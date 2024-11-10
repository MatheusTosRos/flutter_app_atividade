import 'package:flutter_application_historys/models/autor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Autor Model Tests', () {
    test('deve criar um Autor a partir de JSON', () {
      final json = {
        'id': 1,
        'nome': 'Autor Desconhecido',
      };

      final autor = Autor.fromJson(json);

      expect(autor.id, 1);
      expect(autor.nome, 'Autor Desconhecido');
    });

    test('deve converter Autor para JSON', () {
      final autor = Autor(
        id: 1,
        nome: 'Autor Desconhecido',
      );

      final json = autor.toJson();

      expect(json['id'], 1);
      expect(json['nome'], 'Autor Desconhecido');
    });
  });
}
