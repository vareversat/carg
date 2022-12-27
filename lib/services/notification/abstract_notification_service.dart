import 'dart:async';

import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/repositories/notification/abstract_notification_repository.dart';
import 'package:carg/services/base_abstract_service.dart';

abstract class AbstractNotificationService
    extends BaseAbstractService<AbstractNotification> {
  final AbstractNotificationRepository notificationRepository;

  AbstractNotificationService({required this.notificationRepository})
      : super(repository: notificationRepository);

  /// Get the notification of a particular user via his/her/them [userId]
  /// Return the notification or null if not found
  Future getNotificationOfUser(String? userId,
      StreamController<List<AbstractNotification>> streamController);

  /// Search notifications into the index
  /// Return the notification or null if not found
  Future<List<AbstractNotification>> searchNotifications(
      {String query = '',
      AbstractNotification? currentNotification,
      bool? myNotifications});
}
