// Mocks generated by Mockito 5.4.6 from annotations
// in carg/test/units/services/game/abstract_belote_game_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i16;

import 'package:carg/models/carg_object.dart' as _i9;
import 'package:carg/models/game/belote_game.dart' as _i18;
import 'package:carg/models/game/game.dart' as _i23;
import 'package:carg/models/game/setting/belote_game_setting.dart' as _i20;
import 'package:carg/models/game/setting/game_setting.dart' as _i7;
import 'package:carg/models/players/belote_players.dart' as _i19;
import 'package:carg/models/players/players.dart' as _i24;
import 'package:carg/models/score/belote_score.dart' as _i1;
import 'package:carg/models/score/round/belote_round.dart' as _i2;
import 'package:carg/models/score/round/round.dart' as _i6;
import 'package:carg/models/score/score.dart' as _i5;
import 'package:carg/models/team.dart' as _i14;
import 'package:carg/repositories/base_repository.dart' as _i10;
import 'package:carg/repositories/game/abstract_belote_game_repository.dart'
    as _i21;
import 'package:carg/repositories/score/abstract_belote_score_repository.dart'
    as _i4;
import 'package:carg/repositories/score/abstract_score_repository.dart' as _i8;
import 'package:carg/repositories/team/abstract_team_repository.dart' as _i12;
import 'package:carg/services/impl/team_service.dart' as _i22;
import 'package:carg/services/player/abstract_player_service.dart' as _i13;
import 'package:carg/services/score/abstract_belote_score_service.dart' as _i15;
import 'package:cloud_firestore/cloud_firestore.dart' as _i11;
import 'package:mockito/mockito.dart' as _i3;
import 'package:mockito/src/dummies.dart' as _i17;

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

class _FakeAbstractBeloteScoreRepository_0<
        T1 extends _i1.BeloteScore<_i2.BeloteRound>> extends _i3.SmartFake
    implements _i4.AbstractBeloteScoreRepository<T1> {
  _FakeAbstractBeloteScoreRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractScoreRepository_1<
        T1 extends _i5.Score<_i6.Round<_i7.GameSetting>>> extends _i3.SmartFake
    implements _i8.AbstractScoreRepository<T1> {
  _FakeAbstractScoreRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseRepository_2<T1 extends _i9.CargObject> extends _i3.SmartFake
    implements _i10.BaseRepository<T1> {
  _FakeBaseRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseFirestore_3 extends _i3.SmartFake
    implements _i11.FirebaseFirestore {
  _FakeFirebaseFirestore_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractTeamRepository_4 extends _i3.SmartFake
    implements _i12.AbstractTeamRepository {
  _FakeAbstractTeamRepository_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerService_5 extends _i3.SmartFake
    implements _i13.AbstractPlayerService {
  _FakeAbstractPlayerService_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTeam_6 extends _i3.SmartFake implements _i14.Team {
  _FakeTeam_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AbstractBeloteScoreService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractBeloteScoreService<T extends _i1.BeloteScore<_i2.BeloteRound>>
    extends _i3.Mock implements _i15.AbstractBeloteScoreService<T> {
  MockAbstractBeloteScoreService() {
    _i3.throwOnMissingStub(this);
  }

  @override
  _i4.AbstractBeloteScoreRepository<T> get beloteScoreRepository =>
      (super.noSuchMethod(
        Invocation.getter(#beloteScoreRepository),
        returnValue: _FakeAbstractBeloteScoreRepository_0<T>(
          this,
          Invocation.getter(#beloteScoreRepository),
        ),
      ) as _i4.AbstractBeloteScoreRepository<T>);

  @override
  _i8.AbstractScoreRepository<T> get scoreRepository => (super.noSuchMethod(
        Invocation.getter(#scoreRepository),
        returnValue: _FakeAbstractScoreRepository_1<T>(
          this,
          Invocation.getter(#scoreRepository),
        ),
      ) as _i8.AbstractScoreRepository<T>);

  @override
  _i10.BaseRepository<_i5.Score<_i6.Round<_i7.GameSetting>>> get repository =>
      (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue:
            _FakeBaseRepository_2<_i5.Score<_i6.Round<_i7.GameSetting>>>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i10.BaseRepository<_i5.Score<_i6.Round<_i7.GameSetting>>>);

  @override
  _i16.Future<T?> generateNewScore(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #generateNewScore,
          [gameId],
        ),
        returnValue: _i16.Future<T?>.value(),
      ) as _i16.Future<T?>);

  @override
  _i16.Future<T?> getScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #getScoreByGame,
          [gameId],
        ),
        returnValue: _i16.Future<T?>.value(),
      ) as _i16.Future<T?>);

  @override
  _i16.Stream<T?> getScoreByGameStream(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #getScoreByGameStream,
          [gameId],
        ),
        returnValue: _i16.Stream<T?>.empty(),
      ) as _i16.Stream<T?>);

  @override
  _i16.Future<void> deleteScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteScoreByGame,
          [gameId],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i16.Future<_i5.Score<_i6.Round<_i7.GameSetting>>?> get(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue:
            _i16.Future<_i5.Score<_i6.Round<_i7.GameSetting>>?>.value(),
      ) as _i16.Future<_i5.Score<_i6.Round<_i7.GameSetting>>?>);

  @override
  _i16.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<void> update(_i5.Score<_i6.Round<_i7.GameSetting>>? t) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<String> create(_i5.Score<_i6.Round<_i7.GameSetting>>? t) =>
      (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i16.Future<String>.value(_i17.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i16.Future<String>);
}

/// A class which mocks [AbstractBeloteGameRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractBeloteGameRepository<
        T extends _i18.Belote<_i19.BelotePlayers, _i20.BeloteGameSetting>>
    extends _i3.Mock implements _i21.AbstractBeloteGameRepository<T> {
  MockAbstractBeloteGameRepository() {
    _i3.throwOnMissingStub(this);
  }

  @override
  String get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _i17.dummyValue<String>(
          this,
          Invocation.getter(#database),
        ),
      ) as String);

  @override
  String get environment => (super.noSuchMethod(
        Invocation.getter(#environment),
        returnValue: _i17.dummyValue<String>(
          this,
          Invocation.getter(#environment),
        ),
      ) as String);

  @override
  _i11.FirebaseFirestore get provider => (super.noSuchMethod(
        Invocation.getter(#provider),
        returnValue: _FakeFirebaseFirestore_3(
          this,
          Invocation.getter(#provider),
        ),
      ) as _i11.FirebaseFirestore);

  @override
  String get connectionString => (super.noSuchMethod(
        Invocation.getter(#connectionString),
        returnValue: _i17.dummyValue<String>(
          this,
          Invocation.getter(#connectionString),
        ),
      ) as String);

  @override
  set lastFetchGameDocument(
          _i11.DocumentSnapshot<Object?>? _lastFetchGameDocument) =>
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
  _i16.Future<List<T>> getAllGamesOfPlayer(
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
        returnValue: _i16.Future<List<T>>.value(<T>[]),
      ) as _i16.Future<List<T>>);

  @override
  _i16.Future<T?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i16.Future<T?>.value(),
      ) as _i16.Future<T?>);

  @override
  _i16.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<void> updateField(
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
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<void> partialUpdate(
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
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<void> update(T? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<String> create(T? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i16.Future<String>.value(_i17.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i16.Future<String>);
}

/// A class which mocks [TeamService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTeamService extends _i3.Mock implements _i22.TeamService {
  MockTeamService() {
    _i3.throwOnMissingStub(this);
  }

  @override
  _i12.AbstractTeamRepository get teamRepository => (super.noSuchMethod(
        Invocation.getter(#teamRepository),
        returnValue: _FakeAbstractTeamRepository_4(
          this,
          Invocation.getter(#teamRepository),
        ),
      ) as _i12.AbstractTeamRepository);

  @override
  _i13.AbstractPlayerService get playerService => (super.noSuchMethod(
        Invocation.getter(#playerService),
        returnValue: _FakeAbstractPlayerService_5(
          this,
          Invocation.getter(#playerService),
        ),
      ) as _i13.AbstractPlayerService);

  @override
  _i10.BaseRepository<_i14.Team> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_2<_i14.Team>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i10.BaseRepository<_i14.Team>);

  @override
  _i16.Future<_i14.Team> getTeamByPlayers(List<String?>? playerIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTeamByPlayers,
          [playerIds],
        ),
        returnValue: _i16.Future<_i14.Team>.value(_FakeTeam_6(
          this,
          Invocation.method(
            #getTeamByPlayers,
            [playerIds],
          ),
        )),
      ) as _i16.Future<_i14.Team>);

  @override
  _i16.Future<_i14.Team> incrementPlayedGamesByOne(
    String? id,
    _i23.Game<_i24.Players, _i7.GameSetting>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            id,
            game,
          ],
        ),
        returnValue: _i16.Future<_i14.Team>.value(_FakeTeam_6(
          this,
          Invocation.method(
            #incrementPlayedGamesByOne,
            [
              id,
              game,
            ],
          ),
        )),
      ) as _i16.Future<_i14.Team>);

  @override
  _i16.Future<_i14.Team> incrementWonGamesByOne(
    String? id,
    _i23.Game<_i24.Players, _i7.GameSetting>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            id,
            game,
          ],
        ),
        returnValue: _i16.Future<_i14.Team>.value(_FakeTeam_6(
          this,
          Invocation.method(
            #incrementWonGamesByOne,
            [
              id,
              game,
            ],
          ),
        )),
      ) as _i16.Future<_i14.Team>);

  @override
  _i16.Future<List<_i14.Team>> getAllTeamOfPlayer(
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
        returnValue: _i16.Future<List<_i14.Team>>.value(<_i14.Team>[]),
      ) as _i16.Future<List<_i14.Team>>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i16.Future<_i14.Team?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i16.Future<_i14.Team?>.value(),
      ) as _i16.Future<_i14.Team?>);

  @override
  _i16.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<void> update(_i14.Team? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i16.Future<void>.value(),
        returnValueForMissingStub: _i16.Future<void>.value(),
      ) as _i16.Future<void>);

  @override
  _i16.Future<String> create(_i14.Team? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i16.Future<String>.value(_i17.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i16.Future<String>);
}
