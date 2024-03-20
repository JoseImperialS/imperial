import 'package:proyectoexamen/models/brand.dart'; // Asegúrate de importar la clase Brand
import 'package:proyectoexamen/models/type.dart';

class Part {
  final int id;
  final String name;
  final String code;
  final int model_id;
  final int available;
  final String price;
  final List<Type>? models; // Lista de modelos asociados

  const Part({
    required this.id,
    required this.name,
    required this.code,
    required this.model_id,
    required this.available,
    required this.price,
    required this.models, // Incluir la lista de modelos
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      available: json['available'],
      price: json['price'],
      model_id: json['model_id'],
      models: (json['models'] as List<dynamic>?)
          ?.map((modelJson) => Type.fromJson(modelJson))
          .toList(),
    );
  }
}
