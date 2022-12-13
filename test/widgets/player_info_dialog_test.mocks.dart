// Mocks generated by Mockito 5.3.2 from annotations
// in carg/test/widgets/player_info_dialog_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:carg/models/carg_object.dart' as _i3;
import 'package:carg/models/game/game.dart' as _i9;
import 'package:carg/models/player.dart' as _i7;
import 'package:carg/models/players/players.dart' as _i10;
import 'package:carg/repositories/base_repository.dart' as _i4;
import 'package:carg/repositories/player/abstract_player_repository.dart'
    as _i2;
import 'package:carg/services/auth/auth_service.dart' as _i11;
import 'package:carg/services/impl/player_service.dart' as _i6;
import 'package:flutter/material.dart' as _i5;
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

class _FakeAbstractPlayerRepository_0 extends _i1.SmartFake
    implements _i2.AbstractPlayerRepository {
  _FakeAbstractPlayerRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseRepository_1<T extends _i3.CargObject> extends _i1.SmartFake
    implements _i4.BaseRepository<T> {
  _FakeBaseRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWidget_2 extends _i1.SmartFake implements _i5.Widget {
  _FakeWidget_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i5.DiagnosticLevel? minLevel = _i5.DiagnosticLevel.info}) =>
      super.toString();
}

/// A class which mocks [PlayerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlayerService extends _i1.Mock implements _i6.PlayerService {
  MockPlayerService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AbstractPlayerRepository get playerRepository => (super.noSuchMethod(
        Invocation.getter(#playerRepository),
        returnValue: _FakeAbstractPlayerRepository_0(
          this,
          Invocation.getter(#playerRepository),
        ),
      ) as _i2.AbstractPlayerRepository);
  @override
  _i4.BaseRepository<_i7.Player> get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeBaseRepository_1<_i7.Player>(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i4.BaseRepository<_i7.Player>);
  @override
  _i8.Future<String> create(_i7.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [t],
        ),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
  @override
  _i8.Future<void> incrementPlayedGamesByOne(
    String? playerId,
    _i9.Game<_i10.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementPlayedGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> incrementWonGamesByOne(
    String? playerId,
    _i9.Game<_i10.Players>? game,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementWonGamesByOne,
          [
            playerId,
            game,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<_i7.Player?> getPlayerOfUser(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPlayerOfUser,
          [userId],
        ),
        returnValue: _i8.Future<_i7.Player?>.value(),
      ) as _i8.Future<_i7.Player?>);
  @override
  _i8.Future<List<_i7.Player>> searchPlayers({
    String? query = r'',
    _i7.Player? currentPlayer,
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
        returnValue: _i8.Future<List<_i7.Player>>.value(<_i7.Player>[]),
      ) as _i8.Future<List<_i7.Player>>);
  @override
  void resetLastPointedDocument() => super.noSuchMethod(
        Invocation.method(
          #resetLastPointedDocument,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i8.Future<_i7.Player?> get(String? id) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [id],
        ),
        returnValue: _i8.Future<_i7.Player?>.value(),
      ) as _i8.Future<_i7.Player?>);
  @override
  _i8.Future<void> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> update(_i7.Player? t) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [t],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i11.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isAuth => (super.noSuchMethod(
        Invocation.getter(#isAuth),
        returnValue: false,
      ) as bool);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i8.Future<String> googleLogIn() => (super.noSuchMethod(
        Invocation.method(
          #googleLogIn,
          [],
        ),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
  @override
  _i8.Future<void> sendSignInWithEmailLink(String? email) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendSignInWithEmailLink,
          [email],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<String> signInWithEmailLink(
    String? email,
    String? link,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithEmailLink,
          [
            email,
            link,
          ],
        ),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
  @override
  _i8.Future<String> validatePhoneNumber(
    String? smsCode,
    String? verificationId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #validatePhoneNumber,
          [
            smsCode,
            verificationId,
          ],
        ),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
  @override
  _i8.Future<dynamic> changePhoneNumber(
    String? smsCode,
    String? verificationId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #changePhoneNumber,
          [
            smsCode,
            verificationId,
          ],
        ),
        returnValue: _i8.Future<dynamic>.value(),
      ) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> resendPhoneVerificationCode(
    String? phoneNumber,
    _i5.BuildContext? context,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #resendPhoneVerificationCode,
          [
            phoneNumber,
            context,
          ],
        ),
        returnValue: _i8.Future<dynamic>.value(),
      ) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> sendPhoneVerificationCode(
    String? phoneNumber,
    _i5.BuildContext? context,
    _i11.CredentialVerificationType? credentialVerificationType,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendPhoneVerificationCode,
          [
            phoneNumber,
            context,
            credentialVerificationType,
          ],
        ),
        returnValue: _i8.Future<dynamic>.value(),
      ) as _i8.Future<dynamic>);
  @override
  _i8.Future<bool> isAlreadyLogin() => (super.noSuchMethod(
        Invocation.method(
          #isAlreadyLogin,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<void> signOut(_i5.BuildContext? context) => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [context],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> changeEmail(String? newEmail) => (super.noSuchMethod(
        Invocation.method(
          #changeEmail,
          [newEmail],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i5.Widget getCorrectLandingScreen() => (super.noSuchMethod(
        Invocation.method(
          #getCorrectLandingScreen,
          [],
        ),
        returnValue: _FakeWidget_2(
          this,
          Invocation.method(
            #getCorrectLandingScreen,
            [],
          ),
        ),
      ) as _i5.Widget);
  @override
  void setCurrentPlayer(_i7.Player? player) => super.noSuchMethod(
        Invocation.method(
          #setCurrentPlayer,
          [player],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i8.Future<bool> isAdFreeUser() => (super.noSuchMethod(
        Invocation.method(
          #isAdFreeUser,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  void addListener(dynamic listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(dynamic listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
