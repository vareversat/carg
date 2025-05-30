// Mocks generated by Mockito 5.4.6 from annotations
// in carg/test/units/services/game/abstract_game_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i14;

import 'package:carg/models/carg_object.dart' as _i6;
import 'package:carg/models/game/game.dart' as _i16;
import 'package:carg/models/game/setting/game_setting.dart' as _i3;
import 'package:carg/models/player.dart' as _i20;
import 'package:carg/models/players/players.dart' as _i17;
import 'package:carg/models/score/round/round.dart' as _i2;
import 'package:carg/models/score/score.dart' as _i1;
import 'package:carg/models/team.dart' as _i12;
import 'package:carg/repositories/base_repository.dart' as _i7;
import 'package:carg/repositories/game/abstract_game_repository.dart' as _i18;
import 'package:carg/repositories/player/abstract_player_repository.dart'
    as _i9;
import 'package:carg/repositories/score/abstract_score_repository.dart' as _i5;
import 'package:carg/repositories/team/abstract_team_repository.dart' as _i10;
import 'package:carg/services/impl/player_service.dart' as _i19;
import 'package:carg/services/impl/team_service.dart' as _i21;
import 'package:carg/services/player/abstract_player_service.dart' as _i11;
import 'package:carg/services/score/abstract_score_service.dart' as _i13;
import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:mockito/mockito.dart' as _i4;
import 'package:mockito/src/dummies.dart' as _i15;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAbstractScoreRepository_0<
        T1 extends _i1.Score<_i2.Round<_i3.GameSetting>>> extends _i4.SmartFake
    implements _i5.AbstractScoreRepository<T1> {
  _FakeAbstractScoreRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseRepository_1<T1 extends _i6.CargObject> extends _i4.SmartFake
    implements _i7.BaseRepository<T1> {
  _FakeBaseRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseFirestore_2 extends _i4.SmartFake
    implements _i8.FirebaseFirestore {
  _FakeFirebaseFirestore_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerRepository_3 extends _i4.SmartFake
    implements _i9.AbstractPlayerRepository {
  _FakeAbstractPlayerRepository_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractTeamRepository_4 extends _i4.SmartFake
    implements _i10.AbstractTeamRepository {
  _FakeAbstractTeamRepository_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerService_5 extends _i4.SmartFake
    implements _i11.AbstractPlayerService {
  _FakeAbstractPlayerService_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTeam_6 extends _i4.SmartFake implements _i12.Team {
  _FakeTeam_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AbstractScoreService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractScoreService<T extends _i1.Score<_i2.Round<_i3.GameSetting>>>
    extends _i4.Mock implements _i13.AbstractScoreService<T> {
  MockAbstractScoreService() {
    _i4.throwOnMissingStub(this);
  }

  @override
  _i5.AbstractScoreRepository<T> get scoreRepository => (super.noSuchMethod(
        Invocation.getter(#scoreRepository),
        returnValue: _FakeAbstractScoreRepository_0<T>(
          this,
          Invocation.getter(#scoreRepository),
        ),
      ) as _i5.AbstractScoreRepository<T>);

  @override
  _i7.BaseRepository<_i1.Score<_i2.Round<_i3.GameSetting>>> get repository =>
      (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue:
            _FakeBaseRepository_1<_i1.Score<_i2.Round<_i3.GameSetting>>>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i7.BaseRepository<_i1.Score<_i2.Round<_i3.GameSetting>>>);

  @override
  _i14.Future<T?> getScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #getScoreByGame,
          [gameId],
        ),
        returnValue: _i14.Future<T?>.value(),
      ) as _i14.Future<T?>);

  @override
  _i14.Stream<T?> getScoreByGameStream(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #getScoreByGameStream,
          [gameId],
        ),
        returnValue: _i14.Stream<T?>.empty(),
      ) as _i14.Stream<T?>);

  @override
  _i14.Future<void> deleteScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteScoreByGame,
          [gameId],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i14.Future<_i1.Score<_i2.Round<_i3.GameSetting>>?> get(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue:
            _i14.Future<_i1.Score<_i2.Round<_i3.GameSetting>>?>.value(),
      ) as _i14.Future<_i1.Score<_i2.Round<_i3.GameSetting>>?>);

  @override
  _i14.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> update(_i1.Score<_i2.Round<_i3.GameSetting>>? t) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<String> create(_i1.Score<_i2.Round<_i3.GameSetting>>? t) =>
      (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i14.Future<String>.value(_i15.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i14.Future<String>);
}

/// A class which mocks [AbstractGameRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractGameRepository<
        T extends _i16.Game<_i17.Players, _i3.GameSetting>> extends _i4.Mock
    implements _i18.AbstractGameRepository<T> {
  MockAbstractGameRepository() {
    _i4.throwOnMissingStub(this);
  }

  @override
  String get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _i15.dummyValue<String>(
          this,
          Invocation.getter(#database),
        ),
      ) as String);

  @override
  String get environment => (super.noSuchMethod(
        Invocation.getter(#environment),
        returnValue: _i15.dummyValue<String>(
          this,
          Invocation.getter(#environment),
        ),
      ) as String);

  @override
  _i8.FirebaseFirestore get provider => (super.noSuchMethod(
        Invocation.getter(#provider),
        returnValue: _FakeFirebaseFirestore_2(
          this,
          Invocation.getter(#provider),
        ),
      ) as _i8.FirebaseFirestore);

  @override
  String get connectionString => (super.noSuchMethod(
        Invocation.getter(#connectionString),
        returnValue: _i15.dummyValue<String>(
          this,
          Invocation.getter(#connectionString),
        ),
      ) as String);

  @override
  set lastFetchGameDocument(
          _i8.DocumentSnapshot<Object?>? _lastFetchGameDocument) =>
      super.noSuchMethod(
        Invocation.setter(
          #lastFetchGameDocument,
          _lastFetchGameDocument,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set connectionString(String? _connectionString) => super.noSuchMethod(
        Invocation.setter(
          #connectionString,
          _connectionString,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i14.Future<List<T>> getAllGamesOfPlayer(
    String? playerId,
    int? pageSize,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllGamesOfPlayer,
          [
            playerId,
            pageSize,
          ],
        ),
        returnValue: _i14.Future<List<T>>.value(<T>[]),
      ) as _i14.Future<List<T>>);

  @override
  _i14.Future<T?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i14.Future<T?>.value(),
      ) as _i14.Future<T?>);

  @override
  _i14.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> updateField(
    String? id,
    String? fieldName,
    dynamic value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateField,
          [
            id,
            fieldName,
            value,
          ],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> partialUpdate(
    T? t,
    Map<String, dynamic>? partToUpdate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #partialUpdate,
          [
            t,
            partToUpdate,
          ],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> update(T? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<String> create(T? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i14.Future<String>.value(_i15.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i14.Future<String>);
}

/// A class which mocks [PlayerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlayerService extends _i4.Mock implements _i19.PlayerService {
  MockPlayerService() {
    _i4.throwOnMissingStub(this);
  }

  @override
  _i9.AbstractPlayerRepository get playerRepository => (super.noSuchMethod(
        Invocation.getter(#playerRepository),
        returnValue: _FakeAbstractPlayerRepository_3(
          this,
          Invocation.getter(#playerRepository),
        ),
      ) as _i9.AbstractPlayerRepository);

  @override
  _i7.BaseRepository<_i20.Player> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_1<_i20.Player>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i7.BaseRepository<_i20.Player>);

  @override
  _i14.Future<String> create(_i20.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i14.Future<String>.value(_i15.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i14.Future<String>);

  @override
  _i14.Future<void> incrementPlayedGamesByOne(
    String? playerId,
    _i16.Game<_i17.Players, _i3.GameSetting>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> incrementWonGamesByOne(
    String? playerId,
    _i16.Game<_i17.Players, _i3.GameSetting>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<_i20.Player?> getPlayerOfUser(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPlayerOfUser,
          [userId],
        ),
        returnValue: _i14.Future<_i20.Player?>.value(),
      ) as _i14.Future<_i20.Player?>);

  @override
  _i14.Future<List<_i20.Player>> searchPlayers({
    String? query = '',
    _i20.Player? currentPlayer,
    bool? myPlayers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchPlayers,
          [],
          {
            #query: query,
            #currentPlayer: currentPlayer,
            #myPlayers: myPlayers,
          },
        ),
        returnValue: _i14.Future<List<_i20.Player>>.value(<_i20.Player>[]),
      ) as _i14.Future<List<_i20.Player>>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i14.Future<_i20.Player?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i14.Future<_i20.Player?>.value(),
      ) as _i14.Future<_i20.Player?>);

  @override
  _i14.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> update(_i20.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);
}

/// A class which mocks [TeamService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTeamService extends _i4.Mock implements _i21.TeamService {
  MockTeamService() {
    _i4.throwOnMissingStub(this);
  }

  @override
  _i10.AbstractTeamRepository get teamRepository => (super.noSuchMethod(
        Invocation.getter(#teamRepository),
        returnValue: _FakeAbstractTeamRepository_4(
          this,
          Invocation.getter(#teamRepository),
        ),
      ) as _i10.AbstractTeamRepository);

  @override
  _i11.AbstractPlayerService get playerService => (super.noSuchMethod(
        Invocation.getter(#playerService),
        returnValue: _FakeAbstractPlayerService_5(
          this,
          Invocation.getter(#playerService),
        ),
      ) as _i11.AbstractPlayerService);

  @override
  _i7.BaseRepository<_i12.Team> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_1<_i12.Team>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i7.BaseRepository<_i12.Team>);

  @override
  _i14.Future<_i12.Team> getTeamByPlayers(List<String?>? playerIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTeamByPlayers,
          [playerIds],
        ),
        returnValue: _i14.Future<_i12.Team>.value(_FakeTeam_6(
          this,
          Invocation.method(
            #getTeamByPlayers,
            [playerIds],
          ),
        )),
      ) as _i14.Future<_i12.Team>);

  @override
  _i14.Future<_i12.Team> incrementPlayedGamesByOne(
    String? id,
    _i16.Game<_i17.Players, _i3.GameSetting>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            id,
            game,
          ],
        ),
        returnValue: _i14.Future<_i12.Team>.value(_FakeTeam_6(
          this,
          Invocation.method(
            #incrementPlayedGamesByOne,
            [
              id,
              game,
            ],
          ),
        )),
      ) as _i14.Future<_i12.Team>);

  @override
  _i14.Future<_i12.Team> incrementWonGamesByOne(
    String? id,
    _i16.Game<_i17.Players, _i3.GameSetting>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            id,
            game,
          ],
        ),
        returnValue: _i14.Future<_i12.Team>.value(_FakeTeam_6(
          this,
          Invocation.method(
            #incrementWonGamesByOne,
            [
              id,
              game,
            ],
          ),
        )),
      ) as _i14.Future<_i12.Team>);

  @override
  _i14.Future<List<_i12.Team>> getAllTeamOfPlayer(
    String? playerId,
    int? pageSize,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllTeamOfPlayer,
          [
            playerId,
            pageSize,
          ],
        ),
        returnValue: _i14.Future<List<_i12.Team>>.value(<_i12.Team>[]),
      ) as _i14.Future<List<_i12.Team>>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i14.Future<_i12.Team?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i14.Future<_i12.Team?>.value(),
      ) as _i14.Future<_i12.Team?>);

  @override
  _i14.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<void> update(_i12.Team? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i14.Future<void>.value(),
        returnValueForMissingStub: _i14.Future<void>.value(),
      ) as _i14.Future<void>);

  @override
  _i14.Future<String> create(_i12.Team? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i14.Future<String>.value(_i15.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i14.Future<String>);
}
