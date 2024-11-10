import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Historia Model Tests', () {
    test('deve criar uma Historia a partir de JSON', () {
      final json = {
        'id': 1,
        'titulo': 'A Lenda do Boto',
        'escopo': 'Uma famosa lenda amazônica...',
        'autorId': 1,
      };

      final historia = Historia.fromJson(json);

      expect(historia.id, 1);
      expect(historia.titulo, 'A Lenda do Boto');
      expect(historia.escopo, 'Uma famosa lenda amazônica...');
      expect(historia.autorId, 1);
    });

    test('deve converter Historia para JSON', () {
      final historia = Historia(
        id: 1,
        titulo: 'A Lenda do Boto',
        escopo: 'Uma famosa lenda amazônica...',
        autorId: 1,
      );

      final json = historia.toJson();

      expect(json['id'], 1);
      expect(json['titulo'], 'A Lenda do Boto');
      expect(json['escopo'], 'Uma famosa lenda amazônica...');
      expect(json['autorId'], 1);
    });

    test('deve criar Historia sem ID (para novas histórias)', () {
      final historia = Historia(
        titulo: 'Nova História',
        escopo: 'Descrição...',
        autorId: 1,
      );

      expect(historia.id, null);
      expect(historia.titulo, 'Nova História');
      expect(historia.escopo, 'Descrição...');
      expect(historia.autorId, 1);
    });
  });
}