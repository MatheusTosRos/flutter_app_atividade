class Autor {
  final int id;
  final String nome;

  Autor({required this.id, required this.nome});

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}