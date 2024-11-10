import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/screens/home_screen.dart';
import 'package:flutter_application_historys/screens/lista_historias_screen.dart';
import 'package:flutter_application_historys/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Histórias BR',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.green[900],
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService _apiService = ApiService();
  List<Historia> _historias = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarHistorias();
  }

  Future<void> _carregarHistorias() async {
    try {
      final historias = await _apiService.getHistorias();
      setState(() {
        _historias = historias;
      });
    } catch (e) {
      _mostrarErro('Erro ao carregar histórias');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(historias: _historias),
          ListaHistoriasScreen(
            historias: _historias,
            onEdit: _editarHistoria,
            onDelete: _excluirHistoria,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Histórias',
          ),
        ],
      ),
    );
  }

  Future<void> _editarHistoria(Historia historia) async {
    try {
      await _apiService.updateHistoria(historia);
      await _carregarHistorias();
    } catch (e) {
      _mostrarErro('Erro ao editar história');
    }
  }

  Future<void> _excluirHistoria(int id) async {
    try {
      await _apiService.deleteHistoria(id);
      await _carregarHistorias();
    } catch (e) {
      _mostrarErro('Erro ao excluir história');
    }
  }
}