import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/widgets/form_historia_dialog.dart';

class ListaHistoriasScreen extends StatelessWidget {
  final List<Historia> historias;
  final Function(Historia) onEdit;
  final Function(int) onDelete;
  final Function(Historia) onAdd;

  const ListaHistoriasScreen({
    Key? key,
    required this.historias,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Histórias'),
        backgroundColor: Colors.black,
      ),
      body: historias.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma história encontrada',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: historias.length,
              itemBuilder: (context, index) {
                final historia = historias[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      historia.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          historia.escopo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Autor ID: ${historia.autorId}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () => _mostrarFormularioEdicao(
                            context,
                            historia,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _confirmarExclusao(
                            context,
                            historia,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _mostrarFormularioEdicao(BuildContext context, Historia historia) {
    showDialog(
      context: context,
      builder: (context) => FormHistoriaDialog(historia: historia),
    ).then((historiaAtualizada) {
      if (historiaAtualizada != null) {
        onEdit(historiaAtualizada);
      }
    });
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
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
              onDelete(historia.id!);
            },
          ),
        ],
      ),
    );
  }
}