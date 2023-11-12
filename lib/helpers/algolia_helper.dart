import 'dart:convert';

import 'package:carg/const.dart';
import 'package:carg/models/player.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AlgoliaHelper {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static String apiKey = '';
  static String appID = '';
  static String url = '';
  static String path = '';

  AlgoliaHelper._create();

  static Future<AlgoliaHelper> create() async {
    var component = AlgoliaHelper._create();
    final algoliaConfig = jsonDecode(
      await rootBundle.loadString(
        Const.algoliaConfigPath,
      ),
    );
    appID = algoliaConfig['app_id'].toString();
    apiKey = algoliaConfig['api_key'].toString();
    url = '$appID-dsn.algolia.net';
    path = '/1/indexes/player-$flavor';

    return component;
  }

  Map<String, String> get _header {
    return <String, String>{
      'X-Algolia-Application-Id': appID,
      'X-Algolia-API-Key': apiKey,
      'Content-Type': 'application/json',
    };
  }

  String getAlgoliaFilter(bool? admin, String? playerId, bool? myPlayers) {
    if (myPlayers == null) {
      return admin != null && admin
          ? 'owned_by:$playerId OR owned:false OR testing:true'
          : '(owned_by:$playerId OR owned:false) AND NOT testing:true';
    } else {
      if (myPlayers) {
        return 'owned_by:$playerId AND NOT testing:true';
      } else {
        return admin != null && admin
            ? 'owned:false OR testing:true'
            : 'owned:false AND NOT testing:true';
      }
    }
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final params = {
      'query': query,
    };
    final uri = Uri.https(url, path, params);

    final response = await http.get(uri, headers: _header);
    var body = json.decode(response.body);

    return body['hits'];
  }

  Future<List<dynamic>> filter({
    required String query,
    required Player currentPlayer,
    bool? myPlayers,
  }) async {
    var filters =
        getAlgoliaFilter(currentPlayer.admin, currentPlayer.id, myPlayers);
    final params = {
      'query': query,
      'filters': filters,
    };
    final uri = Uri.https(url, '$path/browse', params);

    final response = await http.get(uri, headers: _header);
    var body = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(body);
    }
    return body['hits'];
  }
}
