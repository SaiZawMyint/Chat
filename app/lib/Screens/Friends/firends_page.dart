import 'package:app/Screens/Commons/user_tile.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Providers/app_provider.dart';
import '../Commons/page_loading_error.dart';

class FriendsPage extends HookConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsList = ref.watch(AppProvider.friendsListProvider);
    final userService = ref.watch(AppProvider.userService);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:
                            WidgetUtils.searchInputDecoration("Search", () {
                          logger.i("Search button clicked");
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: TabBar(
                tabs: [
                  Tab(
                      icon: SvgPicture.asset("assets/icons/add-user-icon.svg",
                          width: 25)),
                  const Tab(
                      icon: Icon(
                    Icons.people_alt_outlined,
                    color: Colors.red,
                  )),
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: TabBarView(
                  children: [
                    friendsList.when(
                        data: (users) {
                          if (users.where((u) => u.status == 0).isEmpty) {
                            return const Center(child: Text("No friends requests!"));
                          }
                          return ListView(
                            children: users
                                .where((element) => element.status == 0)
                                .map((user) => UserTile(
                                      onTap: () {},
                                      name: user.user.name,
                                      bio: user.user.bio,
                                      actions: [
                                        ElevatedButton(
                                          style:
                                              WidgetUtils.cancelButtonStyle(),
                                          onPressed: () {},
                                          child: const Text("Cancel"),
                                        ),
                                        const SizedBox(width: 5),
                                        ElevatedButton(
                                            onPressed: () async{
                                              bool request = await userService.acceptFriend(user.user.id);
                                              if(request){
                                                logger.i("Accept friend successfully!");
                                              }else{
                                                logger.e("Something went wrong!");
                                              }
                                            },
                                            child: const Text("Accept"))
                                      ],
                                    ))
                                .toList(),
                          );
                        },
                        error: (e, stk) {
                          logger.e(e.toString());
                          return PageLoadingError(message: e.toString());
                        },
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            )),
                    friendsList.when(
                        data: (users) {
                          if (users.where((u) => u.status == 1).isEmpty) {
                            return const Center(child: Text("No Friends here"));
                          }
                          return ListView(
                            children: users
                                .where((element) => element.status == 1)
                                .map((user) => UserTile(
                                      onTap: () {},
                                      name: user.user.name,
                                      bio: user.user.bio,
                              trails:const [ Icon(Icons.chat_bubble_outline)],
                                    ))
                                .toList(),
                          );
                        },
                        error: (e, stk) {
                          logger.e(e.toString());
                          return PageLoadingError(message: e.toString());
                        },
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
