// Mocks generated by Mockito 5.4.2 from annotations
// in carg/test/units/services/round/belote/fake_abstract_belote_round_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i12;

import 'package:carg/models/carg_object.dart' as _i8;
import 'package:carg/models/score/belote_score.dart' as _i1;
import 'package:carg/models/score/french_belote_score.dart' as _i11;
import 'package:carg/models/score/round/belote_round.dart' as _i2;
import 'package:carg/models/score/round/round.dart' as _i6;
import 'package:carg/models/score/score.dart' as _i5;
import 'package:carg/repositories/base_repository.dart' as _i9;
import 'package:carg/repositories/score/abstract_belote_score_repository.dart'
    as _i4;
import 'package:carg/repositories/score/abstract_score_repository.dart' as _i7;
import 'package:carg/services/impl/score/french_belote_score_service.dart'
    as _i10;
import 'package:mockito/mockito.dart' as _i3;

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

class _FakeAbstractBeloteScoreRepository_0<
        T extends _i1.BeloteScore<_i2.BeloteRound>> extends _i3.SmartFake
    implements _i4.AbstractBeloteScoreRepository<T> {
  _FakeAbstractBeloteScoreRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAbstractScoreRepository_1<T extends _i5.Score<_i6.Round>>
    extends _i3.SmartFake implements _i7.AbstractScoreRepository<T> {
  _FakeAbstractScoreRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseRepository_2<T extends _i8.CargObject> extends _i3.SmartFake
    implements _i9.BaseRepository<T> {
  _FakeBaseRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FrenchBeloteScoreService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFrenchBeloteScoreService extends _i3.Mock
    implements _i10.FrenchBeloteScoreService {
  MockFrenchBeloteScoreService() {
    _i3.throwOnMissingStub(this);
  }

  @override
  _i4.AbstractBeloteScoreRepository<_i11.FrenchBeloteScore>
      get beloteScoreRepository => (super.noSuchMethod(
            Invocation.getter(#beloteScoreRepository),
            returnValue:
                _FakeAbstractBeloteScoreRepository_0<_i11.FrenchBeloteScore>(
              this,
              Invocation.getter(#beloteScoreRepository),
            ),
          ) as _i4.AbstractBeloteScoreRepository<_i11.FrenchBeloteScore>);

  @override
  _i7.AbstractScoreRepository<_i11.FrenchBeloteScore> get scoreRepository =>
      (super.noSuchMethod(
        Invocation.getter(#scoreRepository),
        returnValue: _FakeAbstractScoreRepository_1<_i11.FrenchBeloteScore>(
          this,
          Invocation.getter(#scoreRepository),
        ),
      ) as _i7.AbstractScoreRepository<_i11.FrenchBeloteScore>);

  @override
  _i9.BaseRepository<_i5.Score<_i6.Round>> get repository =>
      (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_2<_i5.Score<_i6.Round>>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i9.BaseRepository<_i5.Score<_i6.Round>>);

  @override
  _i12.Future<_i11.FrenchBeloteScore?> generateNewScore(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #generateNewScore,
          [gameId],
        ),
        returnValue: _i12.Future<_i11.FrenchBeloteScore?>.value(),
      ) as _i12.Future<_i11.FrenchBeloteScore?>);

  @override
  _i12.Future<_i11.FrenchBeloteScore?> getScoreByGame(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGame,
          [gameId],
        ),
        returnValue: _i12.Future<_i11.FrenchBeloteScore?>.value(),
      ) as _i12.Future<_i11.FrenchBeloteScore?>);

  @override
  _i12.Stream<_i11.FrenchBeloteScore?> getScoreByGameStream(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGameStream,
          [gameId],
        ),
        returnValue: _i12.Stream<_i11.FrenchBeloteScore?>.empty(),
      ) as _i12.Stream<_i11.FrenchBeloteScore?>);

  @override
  _i12.Future<void> deleteScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteScoreByGame,
          [gameId],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i12.Future<_i5.Score<_i6.Round>?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i12.Future<_i5.Score<_i6.Round>?>.value(),
      ) as _i12.Future<_i5.Score<_i6.Round>?>);

  @override
  _i12.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> update(_i5.Score<_i6.Round>? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<String> create(_i5.Score<_i6.Round>? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i12.Future<String>.value(''),
      ) as _i12.Future<String>);
}
