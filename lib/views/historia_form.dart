import 'package:flutter/material.dart';
import '../models/historia.dart';
import '../services/historia_service.dart';

class HistoriaForm extends StatefulWidget {
  final Historia? historia;

  const HistoriaForm({super.key, this.historia});

  @override
  State<HistoriaForm> createState() => _HistoriaFormState();
}

class _HistoriaFormState extends State<HistoriaForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = HistoriaService();

  late TextEditingController _tituloController;
  late TextEditingController _escopoController;
  late TextEditingController _autorController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.historia?.titulo);
    _escopoController = TextEditingController(text: widget.historia?.escopo);
    _autorController = TextEditingController(text: widget.historia?.autor);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _escopoController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  Future<void> _salvarHistoria() async {
    if (_formKey.currentState!.validate()) {
      try {
        final historia = Historia(
          id: widget.historia?.id,
          titulo: _tituloController.text,
          escopo: _escopoController.text,
          autor: _autorController.text,
        );

        if (widget.historia == null) {
          await _service.criarHistoria(historia);
        } else {
          await _service.atualizarHistoria(historia);
        }

        if (mounted) {
          Navigator.of(context).pop(historia);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao salvar história')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.historia == null ? 'Nova História' : 'Editar História'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _escopoController,
                decoration: const InputDecoration(
                  labelText: 'Escopo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um escopo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um autor';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvarHistoria,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
