import 'package:carg/models/carg_object.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AbstractNotification extends CargObject {
  late DateTime timeStamp;
  late NotificationStatus notificationStatus;
  final String boundTo;
  final NotificationKind kind;

  AbstractNotification(
      {String? id,
      NotificationStatus? notificationStatus,
      DateTime? timeStamp,
      required this.boundTo,
      required this.kind})
      : super(id: id) {
    this.timeStamp = timeStamp ?? DateTime.now();
    this.notificationStatus = notificationStatus ?? NotificationStatus.unseen;
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'status': EnumToString.convertToString(notificationStatus),
      'time_stamp': DateFormat('yyyy-MM-ddTHH:mm:ss').format(timeStamp),
      'bound_to': boundTo
    };
  }

  /// Return de localized message of de notification
  String getMessage(BuildContext context);

  /// Return the Icon representing the notification kind
  IconData getVisualIcon();

  /// Return the dialog when the notification is pressed
  Widget displayDialog(BuildContext context);

  /// Return the Icon representing the notification status
  IconData getStatusIcon() {
    if (notificationStatus == NotificationStatus.unseen) {
      return Icons.notifications_on_outlined;
    } else {
      return Icons.check_circle;
    }
  }
}

enum NotificationStatus { seen, unseen }

enum NotificationKind { newGameInvite, gameEnded, system }
