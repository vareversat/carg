// Mocks generated by Mockito 5.4.2 from annotations
// in carg/test/units/services/game/tarot/tarot_game_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i15;

import 'package:carg/models/carg_object.dart' as _i6;
import 'package:carg/models/game/game.dart' as _i20;
import 'package:carg/models/game/tarot.dart' as _i17;
import 'package:carg/models/player.dart' as _i19;
import 'package:carg/models/players/players.dart' as _i21;
import 'package:carg/models/score/round/round.dart' as _i4;
import 'package:carg/models/score/score.dart' as _i3;
import 'package:carg/models/score/tarot_score.dart' as _i14;
import 'package:carg/models/team.dart' as _i12;
import 'package:carg/repositories/base_repository.dart' as _i7;
import 'package:carg/repositories/impl/game/tarot_game_repository.dart' as _i16;
import 'package:carg/repositories/player/abstract_player_repository.dart'
    as _i9;
import 'package:carg/repositories/score/abstract_score_repository.dart' as _i5;
import 'package:carg/repositories/score/abstract_tarot_score_repository.dart'
    as _i2;
import 'package:carg/repositories/team/abstract_team_repository.dart' as _i10;
import 'package:carg/services/impl/player_service.dart' as _i18;
import 'package:carg/services/impl/score/tarot_score_service.dart' as _i13;
import 'package:carg/services/impl/team_service.dart' as _i22;
import 'package:carg/services/player/abstract_player_service.dart' as _i11;
import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAbstractTarotScoreRepository_0 extends _i1.SmartFake
    implements _i2.AbstractTarotScoreRepository {
  _FakeAbstractTarotScoreRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractScoreRepository_1<T extends _i3.Score<_i4.Round>>
    extends _i1.SmartFake implements _i5.AbstractScoreRepository<T> {
  _FakeAbstractScoreRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseRepository_2<T extends _i6.CargObject> extends _i1.SmartFake
    implements _i7.BaseRepository<T> {
  _FakeBaseRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseFirestore_3 extends _i1.SmartFake
    implements _i8.FirebaseFirestore {
  _FakeFirebaseFirestore_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerRepository_4 extends _i1.SmartFake
    implements _i9.AbstractPlayerRepository {
  _FakeAbstractPlayerRepository_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractTeamRepository_5 extends _i1.SmartFake
    implements _i10.AbstractTeamRepository {
  _FakeAbstractTeamRepository_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerService_6 extends _i1.SmartFake
    implements _i11.AbstractPlayerService {
  _FakeAbstractPlayerService_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTeam_7 extends _i1.SmartFake implements _i12.Team {
  _FakeTeam_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TarotScoreService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTarotScoreService extends _i1.Mock implements _i13.TarotScoreService {
  MockTarotScoreService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AbstractTarotScoreRepository get tarotScoreRepository =>
      (super.noSuchMethod(
        Invocation.getter(#tarotScoreRepository),
        returnValue: _FakeAbstractTarotScoreRepository_0(
          this,
          Invocation.getter(#tarotScoreRepository),
        ),
      ) as _i2.AbstractTarotScoreRepository);

  @override
  _i5.AbstractScoreRepository<_i14.TarotScore> get scoreRepository =>
      (super.noSuchMethod(
        Invocation.getter(#scoreRepository),
        returnValue: _FakeAbstractScoreRepository_1<_i14.TarotScore>(
          this,
          Invocation.getter(#scoreRepository),
        ),
      ) as _i5.AbstractScoreRepository<_i14.TarotScore>);

  @override
  _i7.BaseRepository<_i3.Score<_i4.Round>> get repository =>
      (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_2<_i3.Score<_i4.Round>>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i7.BaseRepository<_i3.Score<_i4.Round>>);

  @override
  _i15.Future<_i14.TarotScore?> getScoreByGame(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGame,
          [gameId],
        ),
        returnValue: _i15.Future<_i14.TarotScore?>.value(),
      ) as _i15.Future<_i14.TarotScore?>);

  @override
  _i15.Stream<_i14.TarotScore?> getScoreByGameStream(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGameStream,
          [gameId],
        ),
        returnValue: _i15.Stream<_i14.TarotScore?>.empty(),
      ) as _i15.Stream<_i14.TarotScore?>);

  @override
  _i15.Future<void> deleteScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteScoreByGame,
          [gameId],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.Future<_i3.Score<_i4.Round>?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i15.Future<_i3.Score<_i4.Round>?>.value(),
      ) as _i15.Future<_i3.Score<_i4.Round>?>);

  @override
  _i15.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> update(_i3.Score<_i4.Round>? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<String> create(_i3.Score<_i4.Round>? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i15.Future<String>.value(''),
      ) as _i15.Future<String>);
}

/// A class which mocks [TarotGameRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTarotGameRepository extends _i1.Mock
    implements _i16.TarotGameRepository {
  MockTarotGameRepository() {
    _i1.throwOnMissingStub(this);
  }

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
  String get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: '',
      ) as String);

  @override
  String get environment => (super.noSuchMethod(
        Invocation.getter(#environment),
        returnValue: '',
      ) as String);

  @override
  _i8.FirebaseFirestore get provider => (super.noSuchMethod(
        Invocation.getter(#provider),
        returnValue: _FakeFirebaseFirestore_3(
          this,
          Invocation.getter(#provider),
        ),
      ) as _i8.FirebaseFirestore);

  @override
  String get connectionString => (super.noSuchMethod(
        Invocation.getter(#connectionString),
        returnValue: '',
      ) as String);

  @override
  set connectionString(String? _connectionString) => super.noSuchMethod(
        Invocation.setter(
          #connectionString,
          _connectionString,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.Future<_i17.Tarot?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i15.Future<_i17.Tarot?>.value(),
      ) as _i15.Future<_i17.Tarot?>);

  @override
  _i15.Future<List<_i17.Tarot>> getAllGamesOfPlayer(
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
        returnValue: _i15.Future<List<_i17.Tarot>>.value(<_i17.Tarot>[]),
      ) as _i15.Future<List<_i17.Tarot>>);

  @override
  _i15.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> updateField(
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
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> partialUpdate(
    _i17.Tarot? t,
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
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> update(_i17.Tarot? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<String> create(_i17.Tarot? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i15.Future<String>.value(''),
      ) as _i15.Future<String>);
}

/// A class which mocks [PlayerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlayerService extends _i1.Mock implements _i18.PlayerService {
  MockPlayerService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.AbstractPlayerRepository get playerRepository => (super.noSuchMethod(
        Invocation.getter(#playerRepository),
        returnValue: _FakeAbstractPlayerRepository_4(
          this,
          Invocation.getter(#playerRepository),
        ),
      ) as _i9.AbstractPlayerRepository);

  @override
  _i7.BaseRepository<_i19.Player> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_2<_i19.Player>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i7.BaseRepository<_i19.Player>);

  @override
  _i15.Future<String> create(_i19.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i15.Future<String>.value(''),
      ) as _i15.Future<String>);

  @override
  _i15.Future<void> incrementPlayedGamesByOne(
    String? playerId,
    _i20.Game<_i21.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> incrementWonGamesByOne(
    String? playerId,
    _i20.Game<_i21.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<_i19.Player?> getPlayerOfUser(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPlayerOfUser,
          [userId],
        ),
        returnValue: _i15.Future<_i19.Player?>.value(),
      ) as _i15.Future<_i19.Player?>);

  @override
  _i15.Future<List<_i19.Player>> searchPlayers({
    String? query = r'',
    _i19.Player? currentPlayer,
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
        returnValue: _i15.Future<List<_i19.Player>>.value(<_i19.Player>[]),
      ) as _i15.Future<List<_i19.Player>>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.Future<_i19.Player?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i15.Future<_i19.Player?>.value(),
      ) as _i15.Future<_i19.Player?>);

  @override
  _i15.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> update(_i19.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);
}

/// A class which mocks [TeamService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTeamService extends _i1.Mock implements _i22.TeamService {
  MockTeamService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.AbstractTeamRepository get teamRepository => (super.noSuchMethod(
        Invocation.getter(#teamRepository),
        returnValue: _FakeAbstractTeamRepository_5(
          this,
          Invocation.getter(#teamRepository),
        ),
      ) as _i10.AbstractTeamRepository);

  @override
  _i11.AbstractPlayerService get playerService => (super.noSuchMethod(
        Invocation.getter(#playerService),
        returnValue: _FakeAbstractPlayerService_6(
          this,
          Invocation.getter(#playerService),
        ),
      ) as _i11.AbstractPlayerService);

  @override
  _i7.BaseRepository<_i12.Team> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_2<_i12.Team>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i7.BaseRepository<_i12.Team>);

  @override
  _i15.Future<_i12.Team> getTeamByPlayers(List<String?>? playerIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTeamByPlayers,
          [playerIds],
        ),
        returnValue: _i15.Future<_i12.Team>.value(_FakeTeam_7(
          this,
          Invocation.method(
            #getTeamByPlayers,
            [playerIds],
          ),
        )),
      ) as _i15.Future<_i12.Team>);

  @override
  _i15.Future<_i12.Team> incrementPlayedGamesByOne(
    String? id,
    _i20.Game<_i21.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            id,
            game,
          ],
        ),
        returnValue: _i15.Future<_i12.Team>.value(_FakeTeam_7(
          this,
          Invocation.method(
            #incrementPlayedGamesByOne,
            [
              id,
              game,
            ],
          ),
        )),
      ) as _i15.Future<_i12.Team>);

  @override
  _i15.Future<_i12.Team> incrementWonGamesByOne(
    String? id,
    _i20.Game<_i21.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            id,
            game,
          ],
        ),
        returnValue: _i15.Future<_i12.Team>.value(_FakeTeam_7(
          this,
          Invocation.method(
            #incrementWonGamesByOne,
            [
              id,
              game,
            ],
          ),
        )),
      ) as _i15.Future<_i12.Team>);

  @override
  _i15.Future<List<_i12.Team>> getAllTeamOfPlayer(
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
        returnValue: _i15.Future<List<_i12.Team>>.value(<_i12.Team>[]),
      ) as _i15.Future<List<_i12.Team>>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i15.Future<_i12.Team?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i15.Future<_i12.Team?>.value(),
      ) as _i15.Future<_i12.Team?>);

  @override
  _i15.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<void> update(_i12.Team? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i15.Future<void>.value(),
        returnValueForMissingStub: _i15.Future<void>.value(),
      ) as _i15.Future<void>);

  @override
  _i15.Future<String> create(_i12.Team? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i15.Future<String>.value(''),
      ) as _i15.Future<String>);
}
