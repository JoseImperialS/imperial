import 'package:flutter/material.dart';

class Parts extends StatefulWidget {
  const Parts({super.key, required this.title});

  final String title;

  @override
  State<Parts> createState() => _Parts();
}

class _Parts extends State<Parts> {
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
                'Parts',
              ),
            ],
          )
        ])));
  }
}