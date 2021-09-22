// Mocks generated by Mockito 5.0.15 from annotations
// in carg/test/widgets/register_screen_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:carg/models/game/game.dart' as _i5;
import 'package:carg/models/player.dart' as _i2;
import 'package:carg/models/players/players.dart' as _i6;
import 'package:carg/services/player_service.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakePlayer_0 extends _i1.Fake implements _i2.Player {}

/// A class which mocks [PlayerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlayerService extends _i1.Mock implements _i3.PlayerService {
  MockPlayerService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Player>> searchPlayers(
          {String? query = r'', String? playerId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #searchPlayers, [], {#query: query, #playerId: playerId}),
              returnValue: Future<List<_i2.Player>>.value(<_i2.Player>[]))
          as _i4.Future<List<_i2.Player>>);

  @override
  _i4.Future<dynamic> incrementPlayedGamesByOne(
          String? id, _i5.Game<_i6.Players>? game) =>
      (super.noSuchMethod(
          Invocation.method(#incrementPlayedGamesByOne, [id, game]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);

  @override
  _i4.Future<dynamic> incrementWonGamesByOne(
          String? id, _i5.Game<_i6.Players>? game) =>
      (super.noSuchMethod(
          Invocation.method(#incrementWonGamesByOne, [id, game]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);

  @override
  _i4.Future<_i2.Player> getPlayer(String? id) =>
      (super.noSuchMethod(Invocation.method(#getPlayer, [id]),
              returnValue: Future<_i2.Player>.value(_FakePlayer_0()))
          as _i4.Future<_i2.Player>);

  @override
  _i4.Future<_i2.Player?> getPlayerOfUser(String? userId) =>
      (super.noSuchMethod(Invocation.method(#getPlayerOfUser, [userId]),
          returnValue: Future<_i2.Player?>.value()) as _i4.Future<_i2.Player?>);

  @override
  _i4.Future<void> updatePlayer(_i2.Player? player) =>
      (super.noSuchMethod(Invocation.method(#updatePlayer, [player]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);

  @override
  _i4.Future<String> addPlayer(_i2.Player? player) =>
      (super.noSuchMethod(Invocation.method(#addPlayer, [player]),
          returnValue: Future<String>.value('')) as _i4.Future<String>);

  @override
  _i4.Future<dynamic> deletePlayer(_i2.Player? player) =>
      (super.noSuchMethod(Invocation.method(#deletePlayer, [player]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);

  @override
  String toString() => super.toString();
}
