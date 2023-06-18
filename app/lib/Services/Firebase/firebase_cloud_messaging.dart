import 'dart:convert';

import 'package:app/Providers/app_provider.dart';
import 'package:app/Services/Configs/service_config.dart';
import 'package:assets_audio_player/assets_audio_player.dart' as audio;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'firebase_service.dart';

class FCMService {
  final Ref ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late final FirebaseService firebase;

  FCMService(this.ref){
    firebase = ref.watch(AppProvider.firebaseServiceProvider);
  }

  Future<void> saveUserToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      try {
        await firebase.firestore
            .collection("message_token")
            .doc(firebase.firebaseAuth.currentUser!.uid)
            .set({"token": token});
      } catch (e) {
        logger.e("Error while saving message token : ${e.toString()}");
      }
    }
  }

  Future<void> initialize() async {
    await requestPermission();
    await saveUserToken();
    await handleMessage();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<AuthorizationStatus> requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // logger.i('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus;
  }

  ///foreground message handler
  Future<void> handleMessage() async {
    await requestPermission();
    FirebaseMessaging.onMessage.listen((msg) async {
      await audio.AssetsAudioPlayer.newPlayer().open(
          audio.Audio("assets/notifications/default.mp3"),
        showNotification: false,
        autoStart: true,
      );
    });
  }

  ///background message handler
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    logger.w("Handling a background message: ${message.messageId}");
    logger.w('Message data: ${message.data}');
    logger.w('Message notification: ${message.notification?.title}');
    logger.w('Message notification: ${message.notification?.body}');
  }

  Future<void> sendPushNotification(String token, String title, String body,String type) async {
    try {
      await http.post(Uri.parse("${ServiceConfig.fcmApi}send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=${ServiceConfig.fcmSecretKey}',
          },
          body: jsonEncode({
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'type': type
            },
            'notification': {
              'title': title,
              'body': body,
              'android_channel_id': 'test',
              'sound': 'app_notification',
            },
            'to': token
          }));
    }catch(e){
      logger.e("Error while sending push notification : ${e.toString()}");
    }
  }

  Future<String?> getFCMTokenByUser(String userId) async{
    final collection = await firebase.firestore.collection("message_token").doc(userId).get();
    if(collection.exists){
      return collection["token"];
    }
    return null;
  }
  
  FirebaseMessaging get messaging => _messaging;
}
