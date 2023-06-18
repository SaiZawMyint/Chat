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
    final scrollController = ref.watch(AppProvider.defaultScrollController);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TabBar(
            tabs: [
              Tab(
                  icon: SvgPicture.asset("assets/icons/add-user-icon.svg",
                      width: 25)),
              Tab(
                  icon: SvgPicture.asset("assets/icons/users-icon.svg",
                      width: 25)
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 6,
                  child: TabBarView(
                    children: [
                      friendsList.when(
                          data: (users) {
                            final requestLists = users.where((u) => u.status == 0 || u.status == 3).toList();
                            if (requestLists.isEmpty) {
                              return const Center(child: Text("No friends requests!"));
                            }
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: ListView.builder(
                                itemCount: requestLists.length + 1,
                                itemBuilder: (context, index) {
                                  if(index == requestLists.length){
                                    return const SizedBox(height: 60,);
                                  }
                                final user = requestLists[index];
                                return UserTile(
                                  onTap: () {},
                                  name: user.user.name,
                                  contentText: Text(user.user.bio),
                                  actions:
                                  user.status == 3 ?
                                  [Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:const Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text("Waiting for response")
                                      ),
                                    ),
                                  )]
                                      :
                                  [ElevatedButton(
                                    style:
                                    WidgetUtils.cancelButtonStyle(),
                                    onPressed: () async{
                                      bool request = await userService.cancelFriendRequest(user.user.id);
                                      if(request){
                                        logger.i("Successfully cancel!");
                                      }else{
                                        logger.e("Something went wrong!");
                                      }
                                    },
                                    child: const Text("Delete"),
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
                                        child: const Text("Accept"))]
                                  ,
                                );
                              },),
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
                            final listOfFriend = users.where((element) => element.status == 1).toList();
                            if (listOfFriend.isEmpty) {
                              return const Center(child: Text("No Friends here"));
                            }
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: listOfFriend.length + 1,
                                itemBuilder: (context, index) {
                                  if(index == listOfFriend.length){
                                    return const SizedBox(height: 60,);
                                  }
                                final user = listOfFriend[index];
                                return UserTile(
                                  center: true,
                                  onTap: () {},
                                  name: user.user.name,
                                  contentText: Text(user.user.bio, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  trails:[
                                    IconButton(onPressed: (){},icon: SvgPicture.asset("assets/icons/chat-bubble.svg", width: 25,)),
                                    IconButton(onPressed: (){},icon: SvgPicture.asset("assets/icons/unfriend-icon.svg", width: 25,))
                                  ],
                                );
                              },),
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
      ),
    );
  }
}
