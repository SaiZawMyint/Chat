import 'package:app/Screens/Commons/user_tile.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Models/Users/user_model.dart';
import '../../Providers/app_provider.dart';
import '../Commons/page_loading_error.dart';

class UsersPage extends HookConsumerWidget{
  const UsersPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersList = ref.watch(AppProvider.allUsersProvider);
    final userService = ref.watch(AppProvider.userService);
    final scrollController = ref.watch(AppProvider.defaultScrollController);

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
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
                          decoration: WidgetUtils.searchInputDecoration("Search",() {
                            logger.i("Search button clicked");
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: allUsersList.when(
                      data: (users){
                        if(users.isEmpty){
                          return const Center(
                              child: Text("No user here")
                          );
                        }
                        return HookBuilder(
                          builder: (context) {
                            final requestState = useState<Set<UserModel>>({});
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: users.length + 1,
                              itemBuilder: (context, index) {
                                if(index == users.length){
                                  return const SizedBox(height: 60);
                                }
                                final user = users[index];
                                return StatefulBuilder(
                                  builder: (context, setState){
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: UserTile(
                                          onTap: (){},
                                          name: user.name,
                                          contentText: Text(user.bio),
                                        center: true,
                                        trails: [
                                          requestState.value.contains(user)?
                                          IconButton(
                                            onPressed: (){},
                                              icon: SvgPicture.asset("assets/icons/friend-requested-icon.svg",width: 25,))
                                              :
                                          IconButton(
                                            icon: SvgPicture.asset("assets/icons/add-user-icon.svg",width: 25,)
                                            , onPressed: () async{
                                            logger.i("Request user : ${user.id}");
                                            setState((){
                                              requestState.value.add(user);
                                            });
                                            logger.i(requestState.value.contains(user));
                                            final request = await userService.requestFriend(user.id);
                                            if(request){
                                              logger.i("Request friend successfully!");
                                            }else{
                                              logger.e("Cannot request friend!");
                                            }
                                          },
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                );
                              },
                            );
                          }
                        );
                      },
                      error: (e,stk) => PageLoadingError(message: e.toString()),
                      loading:()=> const Center(
                        child: CircularProgressIndicator(),
                      )
                  )
              )
            ],
          ),
        ),
    );
  }
}
