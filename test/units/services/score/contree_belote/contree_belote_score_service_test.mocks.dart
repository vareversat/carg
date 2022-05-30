// Mocks generated by Mockito 5.1.0 from annotations
// in carg/test/units/services/score/contree_belote/contree_belote_score_service_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:carg/models/score/contree_belote_score.dart' as _i5;
import 'package:carg/repositories/impl/score/contree_belote_score_repository.dart'
    as _i3;
import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
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

class _FakeFirebaseFirestore_0 extends _i1.Fake
    implements _i2.FirebaseFirestore {}

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
          Invocation.setter(#lastFetchGameDocument, _lastFetchGameDocument),
          returnValueForMissingStub: null);
  @override
  String get database =>
      (super.noSuchMethod(Invocation.getter(#database), returnValue: '')
          as String);
  @override
  String get environment =>
      (super.noSuchMethod(Invocation.getter(#environment), returnValue: '')
          as String);
  @override
  _i2.FirebaseFirestore get provider =>
      (super.noSuchMethod(Invocation.getter(#provider),
          returnValue: _FakeFirebaseFirestore_0()) as _i2.FirebaseFirestore);
  @override
  String get connectionString =>
      (super.noSuchMethod(Invocation.getter(#connectionString), returnValue: '')
          as String);
  @override
  set connectionString(String? _connectionString) => super.noSuchMethod(
      Invocation.setter(#connectionString, _connectionString),
      returnValueForMissingStub: null);
  @override
  _i4.Future<_i5.ContreeBeloteScore?> get(String? id) =>
      (super.noSuchMethod(Invocation.method(#get, [id]),
              returnValue: Future<_i5.ContreeBeloteScore?>.value())
          as _i4.Future<_i5.ContreeBeloteScore?>);
  @override
  _i4.Future<_i5.ContreeBeloteScore?> getScoreByGame(String? gameId) =>
      (super.noSuchMethod(Invocation.method(#getScoreByGame, [gameId]),
              returnValue: Future<_i5.ContreeBeloteScore?>.value())
          as _i4.Future<_i5.ContreeBeloteScore?>);
  @override
  _i4.Stream<_i5.ContreeBeloteScore?> getScoreByGameStream(String? gameId) =>
      (super.noSuchMethod(Invocation.method(#getScoreByGameStream, [gameId]),
              returnValue: Stream<_i5.ContreeBeloteScore?>.empty())
          as _i4.Stream<_i5.ContreeBeloteScore?>);
  @override
  _i4.Future<void> deleteScoreByGame(String? gameId) =>
      (super.noSuchMethod(Invocation.method(#deleteScoreByGame, [gameId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> delete(String? id) =>
      (super.noSuchMethod(Invocation.method(#delete, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> updateField(String? id, String? fieldName, dynamic value) =>
      (super.noSuchMethod(
          Invocation.method(#updateField, [id, fieldName, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> partialUpdate(
          _i5.ContreeBeloteScore? t, Map<String, dynamic>? partToUpdate) =>
      (super.noSuchMethod(Invocation.method(#partialUpdate, [t, partToUpdate]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> update(_i5.ContreeBeloteScore? t) =>
      (super.noSuchMethod(Invocation.method(#update, [t]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<String> create(_i5.ContreeBeloteScore? t) =>
      (super.noSuchMethod(Invocation.method(#create, [t]),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
}
