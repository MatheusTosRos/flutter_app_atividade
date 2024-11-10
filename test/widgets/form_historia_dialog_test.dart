import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/widgets/form_historia_dialog.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('FormHistoriaDialog Widget Tests', () {
    testWidgets('deve exibir campos do formulário vazios para nova história',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormHistoriaDialog(),
          ),
        ),
      );

      expect(find.text('Nova História'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Salvar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('deve exibir campos preenchidos para edição de história',
        (WidgetTester tester) async {
      final historia = Historia(
        id: 1,
        titulo: 'História Existente',
        escopo: 'Descrição existente',
        autorId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormHistoriaDialog(historia: historia),
          ),
        ),
      );

      expect(find.text('Editar História'), findsOneWidget);
      expect(find.text('História Existente'), findsOneWidget);
      expect(find.text('Descrição existente'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('deve validar campos obrigatórios',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormHistoriaDialog(),
          ),
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Por favor, insira um título'), findsOneWidget);
      expect(find.text('Por favor, insira um escopo'), findsOneWidget);
      expect(find.text('Por favor, insira o ID do autor'), findsOneWidget);
    });
  });
}