import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/widgets/historia_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HistoriaCard Widget Tests', () {
    testWidgets('deve exibir informações da história corretamente',
        (WidgetTester tester) async {
      final historia = Historia(
        id: 1,
        titulo: 'Título da História',
        escopo: 'Descrição da história para teste...',
        autorId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoriaCard(historia: historia),
          ),
        ),
      );

      expect(find.text('Título da História'), findsOneWidget);
      expect(find.text('Descrição da história para teste...'), findsOneWidget);
      expect(find.text('Autor ID: 1'), findsOneWidget);
    });

    testWidgets('deve limitar o texto do escopo com ellipsis',
        (WidgetTester tester) async {
      final historia = Historia(
        id: 1,
        titulo: 'Título',
        escopo: 'Um texto muito longo que deve ser truncado com reticências ao final para não ocupar muito espaço no card da história...',
        autorId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoriaCard(historia: historia),
          ),
        ),
      );

      final texto = tester.widget<Text>(
        find.text(historia.escopo),
      );
      
      expect(texto.maxLines, 3);
      expect(texto.overflow, TextOverflow.ellipsis);
    });
  });
}