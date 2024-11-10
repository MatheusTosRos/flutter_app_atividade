import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/widgets/form_historia_dialog.dart';

class ListaHistoriasScreen extends StatelessWidget {
  final List<Historia> historias;
  final Function(Historia) onEdit;
  final Function(int) onDelete;

  const ListaHistoriasScreen({
    Key? key,
    required this.historias,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Histórias'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: historias.length,
        itemBuilder: (context, index) {
          final historia = historias[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(historia.titulo),
              subtitle: Text(historia.escopo),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEdit(historia),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmarExclusao(context, historia),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
        onPressed: () => _mostrarFormulario(context),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, Historia historia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir "${historia.titulo}"?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Excluir'),
            onPressed: () {
              Navigator.pop(context);
              onDelete(historia.id!);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FormHistoriaDialog(),
    );
  }
}