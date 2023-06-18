import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/page_loading_error.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/Screens/messages/private_message_page.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Models/Messages/message_model.dart';
import '../Commons/user_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> test = [];
    final id = ref
        .watch(AppProvider.firebaseServiceProvider)
        .firebaseAuth
        .currentUser!
        .uid;
    final list = ref.watch(AppProvider.friendsListProvider);
    final me = ref.read(AppProvider.userProvider(id));
    final scrollController = ref.watch(AppProvider.defaultScrollController);

    return Scaffold(
      // appBar: ,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
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
                                            color:
                                                WidgetUtils.appColors.shade50,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            color:
                                                WidgetUtils.appColors.shade400,
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
                          child: list.when(
                              data: (users) {
                                if (users.where((u) => u.status == 1).isEmpty) {
                                  return const Center(
                                      child: Text(
                                          "You don't have any friends yet!"));
                                }
                                return StatefulBuilder(
                                    builder: (context, state) {
                                  final chatUserList = users
                                      .where((element) => element.status == 1)
                                      .toList();
                                  return ListView.builder(
                                    controller: scrollController,
                                    itemCount: chatUserList.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == chatUserList.length) {
                                        return const SizedBox(height: 60);
                                      }
                                      final user = chatUserList[index];
                                      return UserTile(
                                        center: true,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PrivateMessagePage(
                                                        user.roomId,
                                                        me,
                                                        user.user),
                                              ));
                                        },
                                        name: user.user.name,
                                        contentText: StreamBuilder(
                                          stream: ref
                                              .watch(AppProvider
                                                  .messageServiceProvider)
                                              .getRecentMessageStream(
                                                  user.roomId),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<MessageModel?>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.active) {
                                              if (snapshot.hasData) {
                                                final data = snapshot.data!;
                                                final isMe =
                                                    data.senderId == me.id;
                                                final timeDiff = DateTime.now()
                                                    .difference(
                                                        data.createdAt!);
                                                final ago = timeago.format(
                                                    DateTime.now()
                                                        .subtract(timeDiff),locale: 'en_short');

                                                return Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "${isMe ? 'You : ' : ''}${snapshot.data!.message}",
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: WidgetUtils.appColors,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      width: 5,
                                                      height: 5,
                                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                                    ),
                                                    Text(ago)
                                                  ],
                                                );

                                              } else {
                                                return const Text(
                                                    "Say hi to friend!");
                                              }
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                        trails: [
                                          SvgPicture.asset(
                                            "assets/icons/chat-bubble.svg",
                                            width: 25,
                                          )
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                              error: (e, stk) {
                                logger.e("Error : ${e.toString()}");
                                return PageLoadingError(message: e.toString());
                              },
                              loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  )))
                    ],
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
