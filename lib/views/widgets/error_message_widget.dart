import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? message;

  const ErrorMessageWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.smartphone),
              Text('-----'),
              Icon(Icons.close),
              Text('----- '),
              Icon(Icons.cloud),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Connexion au serveur impossible',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
