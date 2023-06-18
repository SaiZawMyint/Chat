import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainDrawer extends HookConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebase = ref.watch(AppProvider.firebaseServiceProvider);
    final user = ref.watch(
        AppProvider.userProvider(firebase.firebaseAuth.currentUser!.uid));
    final authService = ref.watch(AppProvider.firebaseServiceProvider);
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: WidgetUtils.appColors,
                          radius: 50,
                          child: SvgPicture.asset(
                              "assets/icons/profile-icon-light.svg",
                              width: 40),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          padding: EdgeInsets.zero,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: SvgPicture.asset("assets/icons/edit-icon.svg",
                                  width: 18)),
                        )
                      ],
                    ))
              ],
            ),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: ListView(
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {},
                          leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              "assets/icons/profile-icon-light.svg",
                              width: 23,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white: Colors.black54,
                            ),
                          ),
                          title: const Text("Profile"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {},
                          leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.people_alt_outlined)),
                          title: const Text("Groups"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {},
                          leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.notifications_outlined)),
                          title: const Text("Notifications"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {},
                          leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.settings)),
                          title: const Text("General"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {},
                          leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.info_outline)),
                          title: const Text("About"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.SCALE,
                                headerAnimationLoop: false,
                                customHeader: const Icon(Icons.power_settings_new_sharp, size: 50, color: Colors.red),
                                title: 'Logout',
                                desc:
                                'Are you sure you want to log out?',
                                btnCancelColor: Colors.black12,
                                buttonsTextStyle: const TextStyle(color: Colors.black),
                                btnOkColor: WidgetUtils.appColors,
                                btnOkOnPress: () async{

                                  try{
                                    await authService.signOut();
                                    await AppProvider.refresh();
                                  }catch(e){
                                    logger.w("Some exception thrown during logout process : ${e.toString()}");
                                  }
                                },
                                btnCancelOnPress: () {},
                              ).show();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Logout"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
