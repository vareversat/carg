import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChangeLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Journal des modifications'),
        ),
        body: FutureBuilder(
            future: rootBundle.loadString('CHANGELOG.md'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Markdown(data: snapshot.data);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
