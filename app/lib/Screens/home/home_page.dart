import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends ConsumerWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 120,
                minHeight: 120,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Center(
                              child: IconButton(
                                onPressed: () => {},
                                icon: const Icon(Icons.menu,color: Colors.black,)),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("Profile", style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    )
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: Container(color: Colors.white,))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                onPressed: (){},
                icon: SvgPicture.asset("assets/icons/chat-bubble.svg", width: 25,),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: (){},
                icon: const Icon(Icons.people_alt_outlined),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: (){},
                icon: const Icon(Icons.notifications_outlined),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: (){},
                icon: SvgPicture.asset("assets/icons/profile-icon.svg", width: 25,),
              ),
            ),
          ],
        ),
      ),
    );
  }

}