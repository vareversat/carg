import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AlgoliaHelper {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static String _apiKey = '';
  static String _appID = '';

  Map<String, String> get _header {
    return <String, String>{
      'X-Algolia-Application-Id': _appID,
      'X-Algolia-API-Key': _apiKey,
      'Content-Type': 'application/json',
    };
  }

  AlgoliaHelper._create();

  static Future<AlgoliaHelper> create() async {
    var component = AlgoliaHelper._create();
    final algoliaConfig = jsonDecode(await rootBundle.loadString(
      'assets/config/algolia.json',
    ));
    _appID = algoliaConfig['app_id'].toString();
    _apiKey = algoliaConfig['api_key'].toString();
    return component;
  }

  Future<List<dynamic>> search(String query) async {
    final params = {
      'query': query,
    };
    final uri = Uri.https(
        '$_appID-dsn.algolia.net', '/1/indexes/player_$flavor', params);

    final response = await http.get(uri, headers: _header);
    var body = json.decode(response.body);
    return body['hits'];
  }

  Future<List<dynamic>> filter(
      {required String field, String? value}) async {
    final params = {
      'filters': '$field:$value',
    };
    final uri = Uri.https(
        '$_appID-dsn.algolia.net', '/1/indexes/player_$flavor/browse', params);

    final response = await http.get(uri, headers: _header);
    var body = json.decode(response.body);
    return body['hits'];
  }
}
