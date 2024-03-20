class Brand {
  final int id;
  final String name;

  const Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
  return Brand(
    id: json['id'] as int,
    name: json['name'] as String,
    // Asegúrate de incluir otros atributos de la clase Brand aquí según corresponda
  );
} 
}
