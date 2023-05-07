import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/page_loading_error.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Commons/notification_widget.dart';
import '../auth/account_info.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> test = [];
    final allUsersList = ref.watch(AppProvider.allUsersProvider);
    final isUserRegistered = ref.watch(AppProvider.isUserRegistered);
    return isUserRegistered.when(data: (bool data) {
      if (!data) {
        return AccountInformationPage();
      } else {
        return Scaffold(
          // appBar: ,
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
                                        if (index == test.length) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: WidgetUtils.appColors.shade50,
                                              shape: BoxShape.circle,

                                            ),
                                            child: IconButton(
                                              color: WidgetUtils.appColors.shade400,
                                              onPressed: () {},
                                              icon: const Icon(Icons.add),
                                            ),
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
                                              child: ClipOval(
                                                  child: Image.asset(
                                                      "assets/images/gp-icon.jpg",
                                                      width: 60)),
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
                                data: (users) {
                                  if (users.isEmpty) {
                                    return const Center(
                                        child: Text("No user here"));
                                  }
                                  return ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      final user = users[index];
                                      return ListTile(
                                        onTap: (){},
                                        leading: Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: WidgetUtils.appColors.shade200,
                                              child: SvgPicture.asset("assets/icons/profile-icon.svg"),
                                            ),
                                            Positioned(
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xff006c3f),

                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                                        subtitle: Text(user.bio,),
                                        trailing: IconButton(
                                          icon: SvgPicture.asset("assets/icons/add-user-icon.svg",width: 25,)
                                          , onPressed: (){},
                                        ),
                                      );
                                    },
                                  );
                                },
                                error: (e, stk) =>
                                    PageLoadingError(message: e.toString()),
                                loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    )))
                      ],
                    ))
                  ],
                ),
                Positioned(
                  top: 10,
                  child: Center(
                    child: Container(
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
          /*bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xfff11347),
                  borderRadius: BorderRadius.circular(30)),
              child: const AppNavigationBar(),
            ),
          ),*/
        );
      }
    }, error: (Object error, StackTrace stackTrace) {
      logger.e("Error occurred : ${error.toString()}");
      return PageLoadingError(message: error.toString());
    }, loading: () {
      logger.i("status is : loading");
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    });
  }
}
