import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:proyectoexamen/models/part.dart';

Future<List<Part>> fetchParts() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/parts/'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body
        .map((dynamic item) => Part.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Fallo al cargar los modelos');
  }
}

class PartList extends StatefulWidget {
  const PartList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PartList> createState() => _PartListState();
}

class _PartListState extends State<PartList> {
  late Future<List<Part>> futureParts;
  @override
  void initState() {
    super.initState();
    futureParts = fetchParts();
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
          child: FutureBuilder<List<Part>>(
            future: futureParts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Part part = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PartDetailsScreen(part: part),
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
                                'ID: ${part.id}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Nombre:  ${part.name}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Código: ${part.code}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Modelo ID: ${part.model_id}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Available: ${part.available}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Price: ${part.price.toString()}',
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
                return Center(child: Text('Error Operator ${snapshot.error}'));
              }
              return Center(child: CircularProgressIndicator());
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ID: ${part.id}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Name: ${part.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Code: ${part.code}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Available: ${part.available}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Price: ${part.price}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Associated Models:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (part.models != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: part.models!.map((model) {
                  return Text(
                    'Model ID: ${model.id}, Name: ${model.name}',
                    style: TextStyle(fontSize: 18),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
