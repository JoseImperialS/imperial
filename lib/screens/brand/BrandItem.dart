import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoexamen/models/brand.dart';
import 'dart:async';
import 'dart:convert';


Future<Brand> fetchBrand() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/brands/9'));

  if (response.statusCode == 200) {
    return Brand.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Error al cargar la marca');
  }
}

class BrandItem extends StatefulWidget {
  const BrandItem({super.key});

  @override
  State<BrandItem> createState() => _BrandItemState();
}

class _BrandItemState extends State<BrandItem> {
  late Future<Brand> futureBrand;

  @override
  void initState() {
    super.initState();
    futureBrand = fetchBrand();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Obtener Datos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Obtener Datos'),
            ),
            body: Center(
                child: FutureBuilder<Brand>(
                    future: futureBrand,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(snapshot.data!.id.toString()),
                              Text(snapshot.data!.name),
                            ]);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }))));
  }
}
