import 'package:proyectoexamen/models/brand.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Type {
  final int id;
  final String name;
  final int first_year;
  final int last_year;
  final Brand brand;

  const Type(
      {required this.id,
      required this.name,
      required this.first_year,
      required this.last_year,
      required this.brand});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
      first_year: json['first_year'],
      last_year: json['last_year'],
      brand: Brand.fromJson(json['brand']),
    );
  }
}

Future<List<Type>> fetchTypes() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/types/'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map((dynamic item) => Type.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Manejar el error de decodificación JSON
      throw Exception('Error al decodificar la respuesta JSON: $e');
    }
  } else {
    throw Exception('Fallo al cargar los modelos');
  }
}
