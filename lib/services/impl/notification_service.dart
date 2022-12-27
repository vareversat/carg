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
  Future getNotificationOfUser(String? userId,
      StreamController<List<AbstractNotification>> streamController) {
    if (userId == null) {
      throw ServiceException('Please use a non null user id');
    }
    try {
      var notificationStream = notificationRepository.getNotificationOfUser(
          userId, streamController);
      return notificationStream;
    } on RepositoryException catch (e) {
      throw ServiceException(
          'Error on streaming the score by user ID [$userId] : ${e.message}');
    }
  }

  @override
  Future<List<AbstractNotification>> searchNotifications(
      {String query = '',
      AbstractNotification? currentNotification,
      bool? myNotifications}) {
    // TODO: implement searchNotifications
    throw UnimplementedError();
  }
}
