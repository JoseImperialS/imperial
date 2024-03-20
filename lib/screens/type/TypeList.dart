import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:proyectoexamen/models/type.dart';

Future<List<Type>> fetchTypes() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/types/'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body
        .map((dynamic item) => Type.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Fallo al cargar los modelos');
  }
}

class TypeList extends StatefulWidget {
  const TypeList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  late Future<List<Type>> futureTypes;

  @override
  void initState() {
    super.initState();
    futureTypes = fetchTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FutureBuilder<List<Type>>(
            future: futureTypes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Type type = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TypeDetailsScreen(type: type),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 4,
                          primary: Colors
                              .blue, // Cambiar el color según sea necesario
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID: ${type.id}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Nombre: ${type.name}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Primer año: ${type.first_year}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Último año: ${type.last_year}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Nombre de la marca: ${type.brand.name}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              return Center(child: CircularProgressIndicator());
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ID: ${type.id}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Nombre: ${type.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Primer año: ${type.first_year}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Último año: ${type.last_year}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Nombre de la marca: ${type.brand.name}',
              style: TextStyle(fontSize: 18),
            ),
            // Agrega más detalles aquí si es necesario
          ],
        ),
      ),
    );
  }
}
