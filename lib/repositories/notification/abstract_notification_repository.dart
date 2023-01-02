import 'dart:async';

import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractNotificationRepository
    extends BaseRepository<AbstractNotification> {
  AbstractNotificationRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider,
      DocumentSnapshot? lastFetchGameDocument})
      : super(
            database: database,
            environment: environment,
            provider: provider,
            lastFetchGameDocument: lastFetchGameDocument);

  /// Get the notifications of a particular user via his/her/them [userId]
  /// Return the notifications or null if not found
  Future getNotificationOfUser(String userId,
      StreamController<List<AbstractNotification>> streamController);

  /// Get the notifications of a particular status user via his/her/them [userId]
  /// Return the notifications or null if not found
  Future getNotificationOfStatusOfUser(
      String userId,
      StreamController<List<AbstractNotification>> streamController,
      NotificationStatus status);
}
