import 'package:app/Models/Messages/message_model.dart';
import 'package:app/Providers/Auth/auth_state_notifier.dart';
import 'package:app/Providers/Commons/navigation_controller.dart';
import 'package:app/Providers/Commons/navigation_notifier.dart';
import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Providers/Commons/page_notifier.dart';
import 'package:app/Providers/Messages/message_notifier.dart';
import 'package:app/Screens/Commons/pages.dart';
import 'package:app/Screens/Commons/rive_asset.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/Services/Firebase/firebase_cloud_messaging.dart';
import 'package:app/Services/Messages/messages_service.dart';
import 'package:app/Services/User/user_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Models/Users/user_friend_model.dart';
import '../Models/Users/user_model.dart';
import '../Services/Firebase/firebase_service.dart';
import '../Services/Messages/room_service.dart';
import 'Auth/auth_controller.dart';
import 'Users/user_state_notifier.dart';

///Application Provider
///
class AppProvider {
  ///main container
  static final providerContainer = ProviderContainer();

  static final authScreenStateNotifier = StateNotifierProvider<AuthScreenStateNotifier, AuthPage>((ref) => AuthScreenStateNotifier());

  ///notification provider
  static final notificationsProvider =
      StateNotifierProvider<NotificationController, List<NotificationState>>(
          (ref) => NotificationController());

  ///a computed provider for firebase service
  static final firebaseServiceProvider =
      Provider((ref) => FirebaseService(ref));

  ///a computed provider for firebase cloud messaging service
  static final firebaseCloudServiceProvider =
      Provider((ref) => FCMService(ref));

  ///handling notifications
  static final initializeFCMService = FutureProvider(
      (ref) async => await ref.read(firebaseCloudServiceProvider).initialize());

  ///auth state provider to handle firebase authentication changes
  static final authStateProvider = StreamProvider.autoDispose<User?>(
      (ref) => ref.watch(AppProvider.firebaseServiceProvider).authStateChange);

  ///auth controller provider to perform auth states
  static final authController =
      StateNotifierProvider<AuthController, UserModel>(
          (ref) => AuthController(ref));

  ///a computed user provider for user service
  static final userService =
      Provider((ref) => UserService(ref, ref.watch(firebaseServiceProvider)));

  ///a state to handle user
  static final userProvider =
      StateNotifierProvider.family<UserStateNotifier, UserModel, String>(
          (ref, id) =>
              UserStateNotifier(ref.watch(AppProvider.userService), id));

  ///a disposable user list stream provider
  static final allUsersProvider = StreamProvider.autoDispose<List<UserModel>>(
      (ref) => ref.watch(userService).getAllUserLists());

  ///check user
  static final isUserRegistered = StreamProvider.autoDispose<bool>(
      (ref) => ref.watch(userService).checkUser());

  ///handle current route providers
  static final routeProvider =
      StateNotifierProvider<PageNotifier, int>((ref) => PageNotifier());

  ///application navigators
  static final appNavigators =
      StateNotifierProvider<NavigationNotifier, List<RiveAsset>>(
          (ref) => NavigationNotifier());

  ///application title provider
  static final titleProvider =
      StateProvider<String>((ref) => Pages.pageNames[ref.watch(routeProvider)]);

  ///carousel controller provider
  static final carouselControllerProvider =
      StateProvider<CarouselController>((ref) => CarouselController());

  ///friends list provider
  static final friendsListProvider =
      StreamProvider.autoDispose<List<UserFriendModel>>(
          (ref) => ref.watch(userService).getFriends());

  ///room service provider
  static final roomServiceProvider = Provider(
    (ref) => RoomService(ref, ref.watch(firebaseServiceProvider)),
  );

  ///message service provider
  static final messageServiceProvider = Provider(
    (ref) => MessageServices(ref, ref.watch(firebaseServiceProvider)),
  );

  ///message list service providers
  static final messageListServiceProviders = StreamProvider.autoDispose
      .family<List<MessageModel>, String>((ref, roomId) =>
          ref.watch(messageServiceProvider).getRoomMessage(roomId));

  ///latest message notifier
  static final latestMessageStateNotifier =
      StateNotifierProvider.family<LatestMessageNotifier, String, String>(
          (ref, initialValue) => LatestMessageNotifier(initialValue));

  ///scroll controller
  static final scrollController =
      Provider.autoDispose.family((ref, [OnScrollChange? callback]) {
    final controller = ScrollController();
    double lastPosition = 0;
    if (callback != null) {
      controller.addListener(() {
        double newPosition = controller.position.pixels;
        if (newPosition > lastPosition && !controller.position.outOfRange) {
          callback(ScrollOptions.bottom);
        }
        if (newPosition < lastPosition && !controller.position.outOfRange) {
          callback(ScrollOptions.top);
        }
        if (controller.offset >= controller.position.maxScrollExtent &&
            !controller.position.outOfRange) {
          callback(ScrollOptions.bottom);
        }
        lastPosition = newPosition;
      });
    }
    return controller;
  });

  static final defaultScrollController = StateProvider.autoDispose(
      (ref) => ref.watch(AppProvider.scrollController((direction) {
            if (direction == ScrollOptions.bottom) {
              ref.watch(navigationBarController.notifier).isVisible = false;
            }
            if (direction == ScrollOptions.top) {
              ref.watch(navigationBarController.notifier).isVisible = true;
            }
          })));

  ///navigation bar controller notifier
  static final navigationBarController = StateNotifierProvider.autoDispose<
      NavigationBarController, NavigationBarState>(
    (ref) => NavigationBarController(),
  );

  ///message text editing controller
  static final messageTextEditingController =
      Provider.autoDispose((ref) => TextEditingController());

  static final reorderLists = StateProvider.family(
    (ref, arg) {},
  );

  ///Refresh providers to original state<br>
  ///@param -[ProviderBase] provider : Nullable parameter
  static Future<void> refresh([ProviderBase<Object?>? provider]) async {
    // Get all the providers inside the container
    final elements = providerContainer.getAllProviderElements().toList();
    // Iterate over all the providers inside the container
    for (final element in elements) {
      if (provider != null && element.provider == provider) {
        providerContainer.refresh(provider);
      } else {
        providerContainer.refresh(element.provider);
      }
    }
    await Future.delayed(const Duration(seconds: 5));
  }
}

class DataMigrator {
  static final conversationsDataMigrator = FutureProvider((ref) async {
    final FirebaseService service =
        ref.watch(AppProvider.firebaseServiceProvider);
    final data = await service.firestore.collection("chat").get();
    List<String> roomIds = data.docs.map((e) => e.id).toList();
    int day=0;
    for (var id in roomIds) {
      final roomData = service.firestore
          .collection("chat")
          .doc(id)
          .collection("messages")
          .doc("conversations");
      final snap = await roomData.get();
      final data = snap.data();
      if(data!=null && data.containsKey("messages")){
        final message = data["messages"];
        roomData.update({
          "messages": message,
          "createdAt": DateTime(2023,1,day++),
          "updatedAt": DateTime(2023,1,day++)
        });
      }else{
        roomData.set({
          "messages":[],
          "createdAt": DateTime(2023,1,day++),
          "updatedAt": DateTime(2023,1,day++)
        });
      }
    }
  });
}
