import 'package:app/Providers/Commons/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Providers/app_provider.dart';

class NotificationWidget extends ConsumerWidget{
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(AppProvider.notificationsProvider);
    return notifications.isEmpty ? const SizedBox.shrink():
    SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                leading: CircleAvatar(
                  backgroundColor:  notifications.last.type == NotificationType.info
                      ? Colors.blue
                      : notifications.last.type == NotificationType.warning
                      ? Colors.orangeAccent
                      : notifications.last.type == NotificationType.error
                      ? Colors.redAccent
                      : Colors.blue,
                  child: Text("${notifications.length}"),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(notifications.last.title),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(notifications.last.message),
                ),
                trailing: IconButton(
                  onPressed: (){
                    ref.read(AppProvider.notificationsProvider.notifier).removeNotification(notifications.last.id);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
          /*Positioned(
            top: 5,
            right: 5,
            child: ,
          )*/
        ],
      ),
    );
  }


}