class Historia {
  int? id;
  String titulo;
  String escopo;
  String autor;

  Historia({
    this.id,
    required this.titulo,
    required this.escopo,
    required this.autor,
  });

  factory Historia.fromJson(Map<String, dynamic> json) {
    return Historia(
      id: json['id'],
      titulo: json['titulo'],
      escopo: json['escopo'],
      autor: json['autor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'escopo': escopo,
      'autor': autor,
    };
  }
}
