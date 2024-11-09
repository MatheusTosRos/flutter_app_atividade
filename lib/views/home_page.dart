import 'package:flutter/material.dart';
import '../models/historia.dart';
import '../services/historia_service.dart';
import 'historia_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HistoriaService _service = HistoriaService();
  List<Historia> _historias = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorias();
  }

  Future<void> _carregarHistorias() async {
    try {
      final historias = await _service.getHistorias();
      setState(() {
        _historias = historias;
      });
    } catch (e) {
      _mostrarErro('Erro ao carregar histórias');
    }
  }

  Future<void> _deletarHistoria(Historia historia) async {
    try {
      await _service.deletarHistoria(historia.id!);
      await _carregarHistorias();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('História deletada com sucesso!')),
        );
      }
    } catch (e) {
      _mostrarErro('Erro ao deletar história');
    }
  }

  void _mostrarErro(String mensagem) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    }
  }

  Future<void> _abrirFormulario([Historia? historia]) async {
    final resultado = await showDialog<Historia>(
      context: context,
      builder: (context) => HistoriaForm(historia: historia),
    );

    if (resultado != null) {
      await _carregarHistorias();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórias BR'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _historias.length,
        itemBuilder: (context, index) {
          final historia = _historias[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    historia.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _abrirFormulario(historia),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text(
                                'Deseja realmente excluir esta história?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deletarHistoria(historia);
                                },
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    historia.escopo,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Autor: ${historia.autor}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
