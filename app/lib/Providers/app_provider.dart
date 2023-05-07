import 'package:app/Providers/Commons/navigation_notifier.dart';
import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Providers/Commons/page_notifier.dart';
import 'package:app/Screens/Commons/pages.dart';
import 'package:app/Screens/Commons/rive_asset.dart';
import 'package:app/Services/User/user_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Models/Users/user_friend_model.dart';
import '../Models/Users/user_model.dart';
import '../Services/Auth/firebase_service.dart';
import 'Auth/auth_controller.dart';
import 'Users/user_controller.dart';

///Application Provider
///
class AppProvider {

  ///main container
  static final providerContainer = ProviderContainer();

  ///notification provider
  static final notificationsProvider = StateNotifierProvider<NotificationController, List<NotificationState>>((ref) => NotificationController());

  ///a computed provider for firebase service provider
  static final firebaseServiceProvider = Provider((ref) => FirebaseService(ref));

  ///auth state provider to handle firebase authentication changes
  static final authStateProvider = StreamProvider.autoDispose<User?>((ref) => ref.read(AppProvider.firebaseServiceProvider).authStateChange);

  ///auth controller provider to perform auth states
  static final authController = StateNotifierProvider<AuthController, UserModel>((ref) => AuthController(ref));

  ///a computed user provider for user service
  static final userService = Provider((ref) => UserService(ref, ref.watch(firebaseServiceProvider)));

  ///a state to handle user
  static final userProvider = StateNotifierProvider.family<UserController, UserModel,String>((ref, id) => UserController(ref.watch(AppProvider.userService), id));

  ///a disposable user list stream provider
  static final allUsersProvider = StreamProvider.autoDispose<List<UserModel>>((ref)=> ref.watch(userService).getAllUserLists());

  ///check user
  static final isUserRegistered = StreamProvider.autoDispose<bool>((ref) => ref.watch(userService).checkUser());

  ///handle current route providers
  static final routeProvider = StateNotifierProvider<PageNotifier, int>((ref) => PageNotifier());

  ///application navigators
  static final appNavigators = StateNotifierProvider<NavigationNotifier, List<RiveAsset>>((ref) => NavigationNotifier());

  ///application title provider
  static final titleProvider = StateProvider<String>((ref) => Pages.pageNames[ref.watch(routeProvider)]);

  ///carousel controller provider
  static final carouselControllerProvider = StateProvider<CarouselController>((ref) => CarouselController());

  ///friends list provider
  static final friendsListProvider = StreamProvider.autoDispose<List<UserFriendModel>>((ref)=> ref.watch(userService).getFriends());

  ///Refresh providers to original state<br>
  ///@param -[ProviderBase] provider : Nullable parameter
  static void refresh([ProviderBase<Object?>? provider]) {
    // Iterate over all the providers inside the container
    providerContainer.getAllProviderElements().forEach((element) {
      if(provider!=null && element.provider == provider){
        providerContainer.refresh(provider);
      }else{
        providerContainer.refresh(element.provider);
      }
    });
  }
}