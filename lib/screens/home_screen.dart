import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import '../widgets/historia_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Historia> historias;

  const HomeScreen({Key? key, required this.historias}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórias BR - Dashboard'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: historias.length,
          itemBuilder: (context, index) {
            return HistoriaCard(historia: historias[index]);
          },
        ),
      ),
    );
  }
}