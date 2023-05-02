import 'package:app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef NotificationCallback = Function(NotificationState state);

class NotificationController extends StateNotifier<List<NotificationState>> {
  NotificationController() : super([]);

  addNotification(Type type, String title, String message,
      [NotificationCallback? callback]) {
    int unique = DateTime.now().microsecond;
    final notification = NotificationState(
        id: unique, type: type, title: title, message: message);
    state = [...state, notification];
    if (callback != null) callback(notification);
    //automatically remove after 10 seconds
    Future.delayed(
      const Duration(seconds: 10),
      () {
        int index = state.indexWhere((element) => element.id == unique);
        //check if the notification is already removed or not
        if (index == -1) {
          logger.i("No notification found for id: $unique");
          return;
        }
        removeNotification(unique);
      },
    );
  }

  removeNotification(int id) {
    state = state.where((element) => element.id != id).toList();
  }
}

class NotificationState {
  final int id;
  final Type type;
  final String title;
  final String message;

  NotificationState(
      {required this.id,
      required this.type,
      required this.title,
      required this.message});
}

enum Type {
  info,
  error,
  warning,
}
