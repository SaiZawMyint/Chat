import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/page_loading_error.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Commons/notification_widget.dart';
import '../auth/account_info.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(AppProvider.firebaseServiceProvider);
    final userProvider = ref.watch(AppProvider.userProvider(authService.firebaseAuth.currentUser!.uid));

    logger.i("username: ${userProvider.id}");

    final user = ref.watch(
        AppProvider.userProvider(authService.firebaseAuth.currentUser!.uid));

    List<String> test = [];

    final allUsersList = ref.watch(AppProvider.allUsersProvider);

    return userProvider.id.isEmpty ? AccountInformationPage():
    Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f5f9),
        leading: IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
        title: Text(
          user.name,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async{
                await authService.signOut();
              },
              icon: const Icon(Icons.logout,color: Colors.black,))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 70,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: test.length + 1,
                                      itemBuilder: (context, index) {
                                        if(index == test.length){
                                          return IconButton(
                                            color: Colors.blue,
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                          );
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: GestureDetector(
                                            onTap: () {
                                              // logger.i("Click");
                                            },
                                            child: CircleAvatar(
                                              radius: 30,
                                              child: ClipOval(child: Image.asset("assets/images/gp-icon.jpg", width: 60)),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: allUsersList.when(
                                data: (users){
                                  if(users.isEmpty){
                                    return const Center(
                                        child: Text("No user here")
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index){
                                      final user = users[index];
                                      return ListTile(
                                        title: Text(user.name),
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
                    ))
              ],
            ),
            Positioned(
              top: 10,
              child: Center(
                child: Container(
                    color: Colors.red,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: const NotificationWidget()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/icons/chat-bubble.svg",
                  width: 25,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.people_alt_outlined),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/icons/profile-icon.svg",
                  width: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
