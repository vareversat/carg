// Mocks generated by Mockito 5.3.2 from annotations
// in carg/test/widgets/tarot_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i19;

import 'package:carg/models/carg_object.dart' as _i11;
import 'package:carg/models/game/game.dart' as _i5;
import 'package:carg/models/game/tarot.dart' as _i13;
import 'package:carg/models/player.dart' as _i20;
import 'package:carg/models/players/players.dart' as _i6;
import 'package:carg/models/score/round/round.dart' as _i9;
import 'package:carg/models/score/score.dart' as _i8;
import 'package:carg/models/score/tarot_score.dart' as _i18;
import 'package:carg/repositories/base_repository.dart' as _i12;
import 'package:carg/repositories/game/abstract_game_repository.dart' as _i7;
import 'package:carg/repositories/game/abstract_tarot_game_repository.dart'
    as _i3;
import 'package:carg/repositories/player/abstract_player_repository.dart'
    as _i16;
import 'package:carg/repositories/score/abstract_score_repository.dart' as _i15;
import 'package:carg/repositories/score/abstract_tarot_score_repository.dart'
    as _i14;
import 'package:carg/services/game/abstract_tarot_game_service.dart' as _i17;
import 'package:carg/services/player/abstract_player_service.dart' as _i4;
import 'package:carg/services/score/abstract_score_service.dart' as _i10;
import 'package:carg/services/score/abstract_tarot_score_service.dart' as _i2;
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

class _FakeAbstractTarotScoreService_0 extends _i1.SmartFake
    implements _i2.AbstractTarotScoreService {
  _FakeAbstractTarotScoreService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractTarotGameRepository_1 extends _i1.SmartFake
    implements _i3.AbstractTarotGameRepository {
  _FakeAbstractTarotGameRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerService_2 extends _i1.SmartFake
    implements _i4.AbstractPlayerService {
  _FakeAbstractPlayerService_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractGameRepository_3<T extends _i5.Game<_i6.Players>>
    extends _i1.SmartFake implements _i7.AbstractGameRepository<T> {
  _FakeAbstractGameRepository_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractScoreService_4<T extends _i8.Score<_i9.Round>>
    extends _i1.SmartFake implements _i10.AbstractScoreService<T> {
  _FakeAbstractScoreService_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseRepository_5<T extends _i11.CargObject> extends _i1.SmartFake
    implements _i12.BaseRepository<T> {
  _FakeBaseRepository_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTarot_6 extends _i1.SmartFake implements _i13.Tarot {
  _FakeTarot_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractTarotScoreRepository_7 extends _i1.SmartFake
    implements _i14.AbstractTarotScoreRepository {
  _FakeAbstractTarotScoreRepository_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractScoreRepository_8<T extends _i8.Score<_i9.Round>>
    extends _i1.SmartFake implements _i15.AbstractScoreRepository<T> {
  _FakeAbstractScoreRepository_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractPlayerRepository_9 extends _i1.SmartFake
    implements _i16.AbstractPlayerRepository {
  _FakeAbstractPlayerRepository_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AbstractTarotGameService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractTarotGameService extends _i1.Mock
    implements _i17.AbstractTarotGameService {
  MockAbstractTarotGameService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AbstractTarotScoreService get tarotScoreService => (super.noSuchMethod(
        Invocation.getter(#tarotScoreService),
        returnValue: _FakeAbstractTarotScoreService_0(
          this,
          Invocation.getter(#tarotScoreService),
        ),
      ) as _i2.AbstractTarotScoreService);
  @override
  _i3.AbstractTarotGameRepository get tarotGameRepository =>
      (super.noSuchMethod(
        Invocation.getter(#tarotGameRepository),
        returnValue: _FakeAbstractTarotGameRepository_1(
          this,
          Invocation.getter(#tarotGameRepository),
        ),
      ) as _i3.AbstractTarotGameRepository);
  @override
  _i4.AbstractPlayerService get playerService => (super.noSuchMethod(
        Invocation.getter(#playerService),
        returnValue: _FakeAbstractPlayerService_2(
          this,
          Invocation.getter(#playerService),
        ),
      ) as _i4.AbstractPlayerService);
  @override
  _i7.AbstractGameRepository<_i13.Tarot> get gameRepository =>
      (super.noSuchMethod(
        Invocation.getter(#gameRepository),
        returnValue: _FakeAbstractGameRepository_3<_i13.Tarot>(
          this,
          Invocation.getter(#gameRepository),
        ),
      ) as _i7.AbstractGameRepository<_i13.Tarot>);
  @override
  _i10.AbstractScoreService<_i18.TarotScore> get scoreService =>
      (super.noSuchMethod(
        Invocation.getter(#scoreService),
        returnValue: _FakeAbstractScoreService_4<_i18.TarotScore>(
          this,
          Invocation.getter(#scoreService),
        ),
      ) as _i10.AbstractScoreService<_i18.TarotScore>);
  @override
  _i12.BaseRepository<_i13.Tarot> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_5<_i13.Tarot>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i12.BaseRepository<_i13.Tarot>);
  @override
  _i19.Future<_i13.Tarot?> getGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #getGame,
          [gameId],
        ),
        returnValue: _i19.Future<_i13.Tarot?>.value(),
      ) as _i19.Future<_i13.Tarot?>);
  @override
  _i19.Future<void> deleteGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteGame,
          [gameId],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<List<_i13.Tarot>> getAllGamesOfPlayerPaginated(
    String? playerId,
    int? pageSize,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllGamesOfPlayerPaginated,
          [
            playerId,
            pageSize,
          ],
        ),
        returnValue: _i19.Future<List<_i13.Tarot>>.value(<_i13.Tarot>[]),
      ) as _i19.Future<List<_i13.Tarot>>);
  @override
  _i19.Future<_i13.Tarot> createGameWithPlayerList(
    List<String?>? playerListForOrder,
    List<String?>? playerListForTeam,
    DateTime? startingDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createGameWithPlayerList,
          [
            playerListForOrder,
            playerListForTeam,
            startingDate,
          ],
        ),
        returnValue: _i19.Future<_i13.Tarot>.value(_FakeTarot_6(
          this,
          Invocation.method(
            #createGameWithPlayerList,
            [
              playerListForOrder,
              playerListForTeam,
              startingDate,
            ],
          ),
        )),
      ) as _i19.Future<_i13.Tarot>);
  @override
  _i19.Future<void> endAGame(
    _i13.Tarot? game,
    DateTime? endingDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #endAGame,
          [
            game,
            endingDate,
          ],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<String> create(_i13.Tarot? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i19.Future<String>.value(''),
      ) as _i19.Future<String>);
  @override
  _i19.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<_i13.Tarot?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i19.Future<_i13.Tarot?>.value(),
      ) as _i19.Future<_i13.Tarot?>);
  @override
  _i19.Future<void> update(_i13.Tarot? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
}

/// A class which mocks [AbstractTarotScoreService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractTarotScoreService extends _i1.Mock
    implements _i2.AbstractTarotScoreService {
  MockAbstractTarotScoreService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i14.AbstractTarotScoreRepository get tarotScoreRepository =>
      (super.noSuchMethod(
        Invocation.getter(#tarotScoreRepository),
        returnValue: _FakeAbstractTarotScoreRepository_7(
          this,
          Invocation.getter(#tarotScoreRepository),
        ),
      ) as _i14.AbstractTarotScoreRepository);
  @override
  _i15.AbstractScoreRepository<_i18.TarotScore> get scoreRepository =>
      (super.noSuchMethod(
        Invocation.getter(#scoreRepository),
        returnValue: _FakeAbstractScoreRepository_8<_i18.TarotScore>(
          this,
          Invocation.getter(#scoreRepository),
        ),
      ) as _i15.AbstractScoreRepository<_i18.TarotScore>);
  @override
  _i12.BaseRepository<_i8.Score<_i9.Round>> get repository =>
      (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_5<_i8.Score<_i9.Round>>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i12.BaseRepository<_i8.Score<_i9.Round>>);
  @override
  _i19.Future<_i18.TarotScore?> getScoreByGame(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGame,
          [gameId],
        ),
        returnValue: _i19.Future<_i18.TarotScore?>.value(),
      ) as _i19.Future<_i18.TarotScore?>);
  @override
  _i19.Stream<_i18.TarotScore?> getScoreByGameStream(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGameStream,
          [gameId],
        ),
        returnValue: _i19.Stream<_i18.TarotScore?>.empty(),
      ) as _i19.Stream<_i18.TarotScore?>);
  @override
  _i19.Future<void> deleteScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteScoreByGame,
          [gameId],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<_i8.Score<_i9.Round>?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i19.Future<_i8.Score<_i9.Round>?>.value(),
      ) as _i19.Future<_i8.Score<_i9.Round>?>);
  @override
  _i19.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<void> update(_i8.Score<_i9.Round>? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<String> create(_i8.Score<_i9.Round>? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i19.Future<String>.value(''),
      ) as _i19.Future<String>);
}

/// A class which mocks [AbstractPlayerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAbstractPlayerService extends _i1.Mock
    implements _i4.AbstractPlayerService {
  MockAbstractPlayerService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i16.AbstractPlayerRepository get playerRepository => (super.noSuchMethod(
        Invocation.getter(#playerRepository),
        returnValue: _FakeAbstractPlayerRepository_9(
          this,
          Invocation.getter(#playerRepository),
        ),
      ) as _i16.AbstractPlayerRepository);
  @override
  _i12.BaseRepository<_i20.Player> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_5<_i20.Player>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i12.BaseRepository<_i20.Player>);
  @override
  _i19.Future<void> incrementPlayedGamesByOne(
    String? playerId,
    _i5.Game<_i6.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<void> incrementWonGamesByOne(
    String? playerId,
    _i5.Game<_i6.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<_i20.Player?> getPlayerOfUser(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPlayerOfUser,
          [userId],
        ),
        returnValue: _i19.Future<_i20.Player?>.value(),
      ) as _i19.Future<_i20.Player?>);
  @override
  _i19.Future<List<_i20.Player>> searchPlayers({
    String? query = r'',
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
        returnValue: _i19.Future<List<_i20.Player>>.value(<_i20.Player>[]),
      ) as _i19.Future<List<_i20.Player>>);
  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<_i20.Player?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i19.Future<_i20.Player?>.value(),
      ) as _i19.Future<_i20.Player?>);
  @override
  _i19.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<void> update(_i20.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  _i19.Future<String> create(_i20.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i19.Future<String>.value(''),
      ) as _i19.Future<String>);
}
