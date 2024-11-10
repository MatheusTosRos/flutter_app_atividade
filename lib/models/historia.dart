class Historia {
  final int? id;
  final String titulo;
  final String escopo;
  final int autorId;

  Historia({
    this.id,
    required this.titulo,
    required this.escopo,
    required this.autorId,
  });

  factory Historia.fromJson(Map<String, dynamic> json) {
    return Historia(
      id: json['id'],
      titulo: json['titulo'],
      escopo: json['escopo'],
      autorId: json['autorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'escopo': escopo,
      'autorId': autorId,
    };
  }
}