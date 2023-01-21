import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SystemNotification extends AbstractNotification {
  final String message;

  factory SystemNotification.fromJSON(Map<String, dynamic>? json, String id) {
    return SystemNotification(
      id: id,
      notificationStatus:
          EnumToString.fromString(NotificationStatus.values, json?['status'])!,
      timeStamp: DateTime.parse(json?['time_stamp']),
      boundTo: json?['bound_to'],
      message: json?['message'],
    );
  }

  SystemNotification(
      {super.id,
      super.notificationStatus,
      super.timeStamp,
      required super.boundTo,
      required this.message})
      : super(kind: NotificationKind.system);

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'message': message});
    return tmpJSON;
  }

  @override
  String getMessage(BuildContext context) {
    return AppLocalizations.of(context)!.information;
  }

  @override
  IconData getVisualIcon() {
    return Icons.info_outline_rounded;
  }

  @override
  Widget displayDialog(BuildContext context) {
    return WarningDialog(
      showCancelButton: false,
      onConfirm: () async => {},
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              getVisualIcon(),
              size: 40,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                style: const TextStyle(fontSize: 20),
                message,
              ),
            ),
          ),
        ],
      ),
      title: AppLocalizations.of(context)!.information,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}
