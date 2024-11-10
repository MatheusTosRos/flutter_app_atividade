import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';

class FormHistoriaDialog extends StatefulWidget {
  final Historia? historia;

  const FormHistoriaDialog({Key? key, this.historia}) : super(key: key);

  @override
  _FormHistoriaDialogState createState() => _FormHistoriaDialogState();
}

class _FormHistoriaDialogState extends State<FormHistoriaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _escopoController;
  late TextEditingController _autorIdController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.historia?.titulo ?? '');
    _escopoController = TextEditingController(text: widget.historia?.escopo ?? '');
    _autorIdController = TextEditingController(
      text: widget.historia?.autorId.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.historia == null ? 'Nova História' : 'Editar História'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um título';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _escopoController,
              decoration: const InputDecoration(labelText: 'Escopo'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um escopo';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _autorIdController,
              decoration: const InputDecoration(labelText: 'ID do Autor'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o ID do autor';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Salvar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final historia = Historia(
                id: widget.historia?.id,
                titulo: _tituloController.text,
                escopo: _escopoController.text,
                autorId: int.parse(_autorIdController.text),
              );
              Navigator.pop(context, historia);
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _escopoController.dispose();
    _autorIdController.dispose();
    super.dispose();
  }
}
