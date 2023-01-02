import 'dart:async';

import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/services/impl/notification_service.dart';
import 'package:carg/views/screens/notifications_screen.dart';
import 'package:flutter/material.dart';

class BellNotificationWidget extends StatefulWidget {
  const BellNotificationWidget();

  @override
  State<StatefulWidget> createState() {
    return BellNotificationWidgetState();
  }
}

class BellNotificationWidgetState extends State<BellNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _dingAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late StreamController<List<AbstractNotification>> streamController;
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    streamController = StreamController.broadcast();
    _dingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    notificationService.getAllNotificationsOfUser(
        'id', streamController, NotificationStatus.unread);
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.ease,
    );
    super.initState();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _dingAnimationController.dispose();
    super.dispose();
  }

  void _runBellAnimation() async {
    await _fadeAnimationController.forward();
    await _dingAnimationController.forward();
    await _dingAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AbstractNotification>>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        _runBellAnimation();
        return Stack(
          children: [
            RawMaterialButton(
              constraints: const BoxConstraints(minHeight: 40, minWidth: 60),
              onPressed: () async => {
                Navigator.push(
                  context,
                  CustomRouteFade(
                    builder: (context) => NotificationsScreen(),
                  ),
                )
              },
              elevation: 2.0,
              fillColor: Theme.of(context).cardColor,
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
              shape: const CircleBorder(),
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: -.1)
                    .chain(CurveTween(curve: Curves.elasticIn))
                    .animate(_dingAnimationController),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? const Icon(
                          Icons.notifications_active,
                        )
                      : const Icon(
                          Icons.notifications_none,
                        ),
                ),
              ),
            ),
            snapshot.hasData && snapshot.data!.isNotEmpty
                ? Positioned(
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        '${snapshot.data!.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
