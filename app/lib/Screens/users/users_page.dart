import 'package:app/Screens/Commons/user_tile.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Providers/app_provider.dart';
import '../Commons/page_loading_error.dart';

class UsersPage extends HookConsumerWidget{
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersList = ref.watch(AppProvider.allUsersProvider);
    final userService = ref.watch(AppProvider.userService);
    return Scaffold(
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
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserTile(
                              onTap: (){},
                              name: user.name,
                              bio: user.bio,
                            trails: [
                              IconButton(
                                icon: SvgPicture.asset("assets/icons/add-user-icon.svg",width: 25,)
                                , onPressed: () async{
                                logger.i("Request user : ${user.id}");
                                final request = await userService.requestFriend(user.id);
                                if(request){
                                  logger.i("Request friend successfully!");
                                }else{
                                  logger.e("Cannot request friend!");
                                }
                              },
                              )
                            ],
                          );
                        },
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
    );
  }
}
