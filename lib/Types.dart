import 'package:flutter/material.dart';

class Types extends StatefulWidget {
  const Types({super.key, required this.title});

  final String title;

  @override
  State<Types> createState() => _Types();
}

class _Types extends State<Types> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Center(
            child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Types',
              ),
            ],
          )
        ])));
  }
}
