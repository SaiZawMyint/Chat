import 'package:hooks_riverpod/hooks_riverpod.dart';

class LatestMessageNotifier extends StateNotifier<String>{

  LatestMessageNotifier(super.state);

  void changeLatestMessage(String latest){
    state = latest;
  }
  String get getLatestMessage => state;
}
