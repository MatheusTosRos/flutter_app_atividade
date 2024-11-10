import 'package:flutter/material.dart';
import 'package:flutter_application_historys/models/historia.dart';
import 'package:flutter_application_historys/screens/home_screen.dart';
import 'package:flutter_application_historys/screens/lista_historias_screen.dart';
import 'package:flutter_application_historys/services/api_service.dart';
import 'package:flutter_application_historys/widgets/form_historia_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Histórias BR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: 'Roboto', // Define uma fonte compatível com acentuação
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
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarHistorias();
  }

  Future<void> _carregarHistorias() async {
    setState(() => _isLoading = true);
    try {
      final historias = await _apiService.getHistorias();
      setState(() {
        _historias = historias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarErro('Erro ao carregar histórias: ${e.toString()}');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _adicionarHistoria(Historia historia) async {
    try {
      await _apiService.createHistoria(historia);
      await _carregarHistorias();
      _mostrarSucesso('História adicionada com sucesso!');
    } catch (e) {
      _mostrarErro('Erro ao adicionar história');
    }
  }

  Future<void> _editarHistoria(Historia historia) async {
    try {
      await _apiService.updateHistoria(historia);
      await _carregarHistorias();
      _mostrarSucesso('História atualizada com sucesso!');
    } catch (e) {
      _mostrarErro('Erro ao editar história');
    }
  }

  Future<void> _excluirHistoria(int id) async {
    try {
      await _apiService.deleteHistoria(id);
      await _carregarHistorias();
      _mostrarSucesso('História excluída com sucesso!');
    } catch (e) {
      _mostrarErro('Erro ao excluir história: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: [
                HomeScreen(historias: _historias),
                ListaHistoriasScreen(
                  historias: _historias,
                  onEdit: _editarHistoria,
                  onDelete: _excluirHistoria,
                  onAdd: _adicionarHistoria,
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
        selectedItemColor: Colors.green[900],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.green[900],
              child: const Icon(Icons.add),
              onPressed: () => _mostrarFormulario(context),
            )
          : null,
    );
  }

  void _mostrarFormulario(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FormHistoriaDialog(),
    ).then((historia) {
      if (historia != null) {
        if (historia.id == null) {
          _adicionarHistoria(historia);
        } else {
          _editarHistoria(historia);
        }
      }
    });
  }
}
