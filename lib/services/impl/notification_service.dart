import 'dart:async';

import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/repositories/impl/notification_repository.dart';
import 'package:carg/repositories/notification/abstract_notification_repository.dart';
import 'package:carg/services/notification/abstract_notification_service.dart';

class NotificationService extends AbstractNotificationService {
  NotificationService({AbstractNotificationRepository? notificationRepository})
      : super(
            notificationRepository:
                notificationRepository ?? NotificationRepository());

  @override
  Future getAllNotificationsOfUser(
      String? userId,
      StreamController<List<AbstractNotification>> streamController,
      NotificationStatus? status) {
    if (userId == null) {
      throw ServiceException('Please use a non null user id');
    }
    try {
      Future notificationStream;
      if (status == null) {
        notificationStream = notificationRepository.getNotificationOfUser(
            userId, streamController);
      } else {
        notificationStream =
            notificationRepository.getNotificationOfStatusOfUser(
                userId, streamController, NotificationStatus.unread);
      }
      return notificationStream;
    } on RepositoryException catch (e) {
      throw ServiceException(
          'Error on streaming the score by user ID [$userId] : ${e.message}');
    }
  }

  @override
  Future markNotificationAsRead(String? notificationId) async {
    if (notificationId == null) {
      throw ServiceException('Please use a non notification id');
    }
    try {
      await notificationRepository.updateField(
          notificationId, 'status', NotificationStatus.read.name);
    } on RepositoryException catch (e) {
      throw ServiceException(
          'Error marking as read the notification [$notificationId] : ${e.message}');
    }
  }
}
