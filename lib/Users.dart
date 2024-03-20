import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key, required this.title});

  final String title;

  @override
  State<Users> createState() => _Users();
}

class _Users extends State<Users> {
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
                'Users',
              ),
            ],
          )
        ])));
  }
}