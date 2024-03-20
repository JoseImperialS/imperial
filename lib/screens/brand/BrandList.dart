import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:proyectoexamen/models/brand.dart';

class Brand {
  final int id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Type {
  final int id;
  final String name;
  final int first_year;
  final int last_year;
  final int brand_id;

  Type({
    required this.id,
    required this.name,
    required this.first_year,
    required this.last_year,
    required this.brand_id,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
      first_year: json['first_year'],
      last_year: json['last_year'],
      brand_id: json['brand_id'],
    );
  }
}

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




Future<List<Brand>> fetchBrands() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/brands/'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Brand.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load brands');
  }
}

Future<List<Type>> fetchTypesForBrand(int brandId) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/api/brands/$brandId/types'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Type.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load types for brand');
  }
}

Future<List<Part>> fetchPartsForModel(int modelId) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/api/models/$modelId/parts'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Part.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load parts for model');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark, // Establecer el brillo en oscuro
        primarySwatch: Colors.blue,
      ),
      home: BrandListPage(),
    );
  }
}



class BrandListPage extends StatefulWidget {
  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  late Future<List<Brand>> futureBrands;

  @override
  void initState() {
    super.initState();
    futureBrands = fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brands'),
      ),
      body: Container(
        color: Colors.grey[900], // Cambiar el color de fondo a oscuro
        child: Center(
          child: FutureBuilder<List<Brand>>(
            future: futureBrands,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Brand brand = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TypeListPage(brandId: brand.id),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(
                            brand.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white, // Texto blanco
                            ),
                          ),
                          leading: Icon(Icons.arrow_forward),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(
                  "${snapshot.error}",
                  style: TextStyle(color: Colors.white), // Texto blanco
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class TypeListPage extends StatefulWidget {
  final int brandId;

  const TypeListPage({Key? key, required this.brandId}) : super(key: key);

  @override
  _TypeListPageState createState() => _TypeListPageState();
}

class _TypeListPageState extends State<TypeListPage> {
  late Future<List<Type>> futureTypes;

  @override
  void initState() {
    super.initState();
    futureTypes = fetchTypesForBrand(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Types'),
      ),
      body: Container(
        color: Colors.grey[900], // Color de fondo oscuro
        child: Center(
          child: FutureBuilder<List<Type>>(
            future: futureTypes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Type type = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        type.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Color de texto claro
                        ),
                      ),
                      subtitle: Text(
                        'ID: ${type.id}',
                        style: TextStyle(
                            color: Colors.white), // Color de texto claro
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TypeDetailsScreen(type: type),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(
                  "${snapshot.error}",
                  style: TextStyle(color: Colors.white), // Color de texto claro
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class TypeDetailsScreen extends StatelessWidget {
  final Type type;

  const TypeDetailsScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name),
      ),
      body: Container(
        color: Colors.grey[900], // Color de fondo oscuro
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ID: ${type.id}',
              style: TextStyle(
                  fontSize: 18, color: Colors.white), // Color de texto claro
            ),
            SizedBox(height: 8),
            Text(
              'Nombre: ${type.name}',
              style: TextStyle(
                  fontSize: 18, color: Colors.white), // Color de texto claro
            ),
            Text(
              'Inicio: ${type.first_year}',
              style: TextStyle(
                  fontSize: 18, color: Colors.white), // Color de texto claro
            ),
            Text(
              'Final: ${type.last_year}',
              style: TextStyle(
                  fontSize: 18, color: Colors.white), // Color de texto claro
            ),
            Text(
              'Nombre de la marca: ${type.brand_id}',
              style: TextStyle(
                  fontSize: 18, color: Colors.white), // Color de texto claro
            ),
            SizedBox(height: 16),
            Text(
              'Ver Partes',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Color de texto claro
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartListPage(modelId: type.id),
                  ),
                );
              },
              child: Text('Ver Partes'),
            ),
          ],
        ),
      ),
    );
  }
}

class PartListPage extends StatefulWidget {
  final int modelId;

  const PartListPage({Key? key, required this.modelId}) : super(key: key);

  @override
  _PartListPageState createState() => _PartListPageState();
}

class _PartListPageState extends State<PartListPage> {
  late Future<List<Part>> futureParts;

  @override
  void initState() {
    super.initState();
    futureParts = fetchPartsForModel(widget.modelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parts'),
      ),
      body: Container(
        // Contenedor para el color de fondo
        color: Colors.grey[900], // Color de fondo oscuro
        child: Center(
          child: FutureBuilder<List<Part>>(
            future: futureParts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  "${snapshot.error}",
                  style: TextStyle(color: Colors.white), // Color de texto claro
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Part part = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        part.name,
                        style: TextStyle(
                          color: Colors.white, // Color de texto claro
                        ),
                      ),
                      subtitle: Text(
                        'ID: ${part.id}',
                        style: TextStyle(
                            color: Colors.white), // Color de texto claro
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PartDetailsScreen(part: part),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                // Si no hay datos y no hay errores, se muestra un mensaje de carga vacía.
                return Text(
                  "No hay datos disponibles.",
                  style: TextStyle(color: Colors.white), // Color de texto claro
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class PartDetailsScreen extends StatelessWidget {
  final Part part;

  const PartDetailsScreen({Key? key, required this.part}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part Details'),
      ),
      body: Container(
        // Contenedor para el color de fondo
        color: Colors.grey[900], // Color de fondo oscuro
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ID: ${part.id}',
                style: TextStyle(
                    fontSize: 18, color: Colors.white), // Texto blanco
              ),
              SizedBox(height: 8),
              Text(
                'Name: ${part.name}',
                style: TextStyle(
                    fontSize: 18, color: Colors.white), // Texto blanco
              ),
              SizedBox(height: 8),
              Text(
                'Code: ${part.code}',
                style: TextStyle(
                    fontSize: 18, color: Colors.white), // Texto blanco
              ),
              SizedBox(height: 8),
              Text(
                'Available: ${part.available}',
                style: TextStyle(
                    fontSize: 18, color: Colors.white), // Texto blanco
              ),
              SizedBox(height: 8),
              Text(
                'Price: ${part.price}',
                style: TextStyle(
                    fontSize: 18, color: Colors.white), // Texto blanco
              ),
              SizedBox(height: 16),
              Text(
                'Associated Models:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto blanco
                ),
              ),
              SizedBox(height: 8),
              if (part.models != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: part.models!.map((model) {
                    return Text(
                      'Model ID: ${model.id}, Name: ${model.name}',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white), // Texto blanco
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
