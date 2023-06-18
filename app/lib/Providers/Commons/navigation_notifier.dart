import 'package:app/Screens/Commons/rive_asset.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavigationNotifier extends StateNotifier<List<RiveAsset>>{
  NavigationNotifier():super([
    RiveAsset("assets/rives/animated_icon.riv",
        artboardName: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Chat"),
    RiveAsset("assets/rives/animated_icon.riv",
        artboardName: "SEARCH",
        stateMachineName: "SEARCH_Interactivity",
        title: "Search"),
    RiveAsset("assets/rives/animated_icon.riv",
        artboardName: "TIMER",
        stateMachineName: "TIMER_Interactivity",
        title: "Chat"),
    RiveAsset("assets/rives/animated_icon.riv",
        artboardName: "BELL",
        stateMachineName: "BELL_Interactivity",
        title: "Notifications"),
    RiveAsset("assets/rives/animated_icon.riv",
        artboardName: "USER",
        stateMachineName: "USER_Interactivity",
        title: "Profile"),
  ]);
}