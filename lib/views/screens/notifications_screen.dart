import 'dart:async';

import 'package:carg/models/notification/abstract_notification.dart' as no;
import 'package:carg/services/impl/notification_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications';
  final NotificationService notificationService = NotificationService();

  NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotificationsScreenState();
  }
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  List<no.AbstractNotification> list = [];
  late StreamController<List<no.AbstractNotification>> streamController;

  @override
  void initState() {
    streamController = StreamController.broadcast();
    widget.notificationService
        .getAllNotificationsOfUser('id', streamController, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.notificationsTitle,
          style: CustomTextStyle.screenHeadLine1(
            context,
          ),
        ),
      ),
      body: StreamBuilder<List<no.AbstractNotification>>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return ErrorMessageWidget(message: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return _NotificationListTile(
                  notification: snapshot.data![index],
                  notificationService: widget.notificationService,
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class _NotificationListTile extends StatelessWidget {
  final no.AbstractNotification notification;
  final NotificationService notificationService;

  const _NotificationListTile(
      {Key? key, required this.notification, required this.notificationService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => {
        notificationService.markNotificationAsRead(notification.id),
        await showDialog(
            context: context,
            builder: (BuildContext context) =>
                notification.displayDialog(context))
      },
      child: ListTile(
        leading: Icon(
          notification.getStatusIcon(),
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          notification.getMessage(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMEd(Localizations.localeOf(context).languageCode)
              .format(
            notification.timeStamp,
          ),
        ),
      ),
    );
  }
}
