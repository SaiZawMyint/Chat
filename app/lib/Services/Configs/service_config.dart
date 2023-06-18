import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceConfig{
  static const String fcmApi = "https://fcm.googleapis.com/fcm/";
  static const String fcmSecretKey = "AAAAYYjNB2c:APA91bFpMU_RLz-29VrohZNh0rV2dlwVHrEycZ87BFuGNmhhQlgfKNl-HSYy3Wd0av3oST4AZvFc3i8iwqia9fY_yoIp_uXL0ag4nmaC3IJVBuGwPEAb8QaCb2Zn0ma4-U04bwPZbRQW";

  static const String messagePN = "MESSAGE";
  static const String friendRequestPN = "FRIEND_REQUEST";
  static const String friendAcceptPN = "FRIEND_ACCEPT";
  static const String friendRejectPN = "FRIEND_REJECT";
  static const String systemPN = "SYSTEM";


  static DateTime? timeStampToDateTime(Map<String, dynamic> json, String key){
    if(!json.containsKey(key)){return null;}
    if(json[key] == null) return null;
    final timeStamp = json[key] as Timestamp;
    return timeStamp.toDate();
  }
}
