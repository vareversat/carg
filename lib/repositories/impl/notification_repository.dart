import 'dart:async';

import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/models/notification/game_ended_notification.dart';
import 'package:carg/models/notification/new_game_notification.dart';
import 'package:carg/models/notification/system_notification.dart';
import 'package:carg/repositories/notification/abstract_notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository extends AbstractNotificationRepository {
  NotificationRepository(
      {String? database,
      String? environment,
      FirebaseFirestore? provider,
      DocumentSnapshot? lastFetchGameDocument})
      : super(
            database: database ?? Const.notificationDB,
            environment: environment ??
                const String.fromEnvironment(Const.dartVarEnv,
                    defaultValue: Const.defaultEnv),
            provider: provider ?? FirebaseFirestore.instance,
            lastFetchGameDocument: lastFetchGameDocument);

  @override
  Future<AbstractNotification?> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getNotificationOfUser(String userId,
      StreamController<List<AbstractNotification>> streamController) {
    try {
      return provider
          .collection(connectionString)
          .where('bound_to', isEqualTo: userId)
          .snapshots()
          .map((element) {
        List<AbstractNotification> notifications = [];
        for (var doc in element.docs) {
          final Map<String, dynamic> value = doc.data();
          var kind = value['kind'];
          if (kind == 'system') {
            notifications.add(SystemNotification.fromJSON(value, doc.id));
          } else if (kind == 'newGameInvite') {
            notifications.add(NewGameNotification.fromJSON(value, doc.id));
          } else if (kind == 'gameEnded') {
            notifications.add(GameEndedNotification.fromJSON(value, doc.id));
          }
        }
        return notifications;
      }).pipe(streamController);
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
