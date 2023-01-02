import 'dart:async';

import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/repositories/notification/abstract_notification_repository.dart';
import 'package:carg/services/base_abstract_service.dart';

abstract class AbstractNotificationService
    extends BaseAbstractService<AbstractNotification> {
  final AbstractNotificationRepository notificationRepository;

  AbstractNotificationService({required this.notificationRepository})
      : super(repository: notificationRepository);

  /// Get the notifications of a particular user via his/her/them [userId]
  /// Return the notification or null if not found
  Future getAllNotificationsOfUser(
      String? userId,
      StreamController<List<AbstractNotification>> streamController,
      NotificationStatus status);

  /// Mark a notification [notificationId] as read
  /// Return the notification or null if not found
  Future markNotificationAsRead(String? notificationId);
}
