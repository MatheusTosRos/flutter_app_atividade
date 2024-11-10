import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService Tests', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('getHistorias deve retornar lista de histórias quando bem-sucedido', () async {
      when(mockClient.get(Uri.parse('${ApiService.baseUrl}/historias')))
          .thenAnswer((_) async => http.Response(
                '''[
                  {
                    "id": 1,
                    "titulo": "A Lenda do Boto",
                    "escopo": "Uma famosa lenda amazônica...",
                    "autorId": 1
                  }
                ]''',
                200,
              ));

      final historias = await apiService.getHistorias();

      expect(historias.length, 1);
      expect(historias[0].titulo, 'A Lenda do Boto');
    });

    test('getHistorias deve lançar exceção quando falhar', () async {
      when(mockClient.get(Uri.parse('${ApiService.baseUrl}/historias')))
          .thenAnswer((_) async => http.Response('Error', 404));

      expect(apiService.getHistorias(), throwsException);
    });

    test('createHistoria deve retornar historia quando bem-sucedido', () async {
      final novaHistoria = Historia(
        titulo: 'Nova História',
        escopo: 'Descrição...',
        autorId: 1,
      );

      when(mockClient.post(
        Uri.parse('${ApiService.baseUrl}/historias'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async => http.Response(
            '''
            {
              "id": 1,
              "titulo": "Nova História",
              "escopo": "Descrição...",
              "autorId": 1
            }
            ''',
            201,
          ));

      final historia = await apiService.createHistoria(novaHistoria);

      expect(historia.id, 1);
      expect(historia.titulo, 'Nova História');
    });
  });
}