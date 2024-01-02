// Mocks generated by Mockito 5.4.4 from annotations
// in carg/test/units/services/score/contree_belote/contree_belote_score_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:carg/models/score/contree_belote_score.dart' as _i6;
import 'package:carg/repositories/impl/score/contree_belote_score_repository.dart'
    as _i3;
import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseFirestore_0 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ContreeBeloteScoreRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockContreeBeloteScoreRepository extends _i1.Mock
    implements _i3.ContreeBeloteScoreRepository {
  MockContreeBeloteScoreRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set lastFetchGameDocument(
          _i2.DocumentSnapshot<Object?>? _lastFetchGameDocument) =>
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
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#database),
        ),
      ) as String);

  @override
  String get environment => (super.noSuchMethod(
        Invocation.getter(#environment),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#environment),
        ),
      ) as String);

  @override
  _i2.FirebaseFirestore get provider => (super.noSuchMethod(
        Invocation.getter(#provider),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#provider),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  String get connectionString => (super.noSuchMethod(
        Invocation.getter(#connectionString),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#connectionString),
        ),
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
  _i5.Future<_i6.ContreeBeloteScore?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i5.Future<_i6.ContreeBeloteScore?>.value(),
      ) as _i5.Future<_i6.ContreeBeloteScore?>);

  @override
  _i5.Future<_i6.ContreeBeloteScore?> getScoreByGame(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGame,
          [gameId],
        ),
        returnValue: _i5.Future<_i6.ContreeBeloteScore?>.value(),
      ) as _i5.Future<_i6.ContreeBeloteScore?>);

  @override
  _i5.Stream<_i6.ContreeBeloteScore?> getScoreByGameStream(String? gameId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScoreByGameStream,
          [gameId],
        ),
        returnValue: _i5.Stream<_i6.ContreeBeloteScore?>.empty(),
      ) as _i5.Stream<_i6.ContreeBeloteScore?>);

  @override
  _i5.Future<void> deleteScoreByGame(String? gameId) => (super.noSuchMethod(
        Invocation.method(
          #deleteScoreByGame,
          [gameId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateField(
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> partialUpdate(
    _i6.ContreeBeloteScore? t,
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> update(_i6.ContreeBeloteScore? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<String> create(_i6.ContreeBeloteScore? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [t],
          ),
        )),
      ) as _i5.Future<String>);
}
