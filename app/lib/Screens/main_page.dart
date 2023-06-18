import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/Screens/Drawer/main_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Providers/app_provider.dart';
import 'Commons/navs/app_navigation_bar.dart';
import 'Commons/notification_widget.dart';
import 'Commons/pages.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageProvider = ref.watch(AppProvider.routeProvider.notifier);
    final pageState = ref.watch(AppProvider.routeProvider);
    final title = ref.watch(AppProvider.titleProvider);
    final lists = ref.watch(AppProvider.appNavigators);
    final pageController = ref.watch(AppProvider.carouselControllerProvider);
    final navigationBarState = ref.watch(AppProvider.navigationBarController);
    final navigationBarController =
        ref.watch(AppProvider.navigationBarController.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => {Scaffold.of(context).openDrawer()},
              icon: const Icon(
                Icons.menu,
              ));
        }),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          CarouselSlider(
            carouselController: pageController,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              // autoPlay: true,
              initialPage: pageState,
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                pageProvider.changePage(index);
                navigationBarController.isVisible = true;
              },
            ),
            items: Pages.mainPages.map((page) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: SafeArea(child: page));
                },
              );
            }).toList(),
          ),
          AnimatedPositioned(
            bottom: navigationBarState.isVisible ? 0 : -80,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 8,
                    color: WidgetUtils.appColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: AppNavigationBar(
                        pageChange: (index, state) {
                          // logger.i("change state $index to $state");
                          lists[index].input?.change(true);
                          if (index != state) {
                            pageProvider.changePage(index);
                            pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            navigationBarController.isVisible = true;
                          }
                          Future.delayed(const Duration(seconds: 1), () {
                            lists[index].input?.change(false);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      drawer: const MainDrawer(),
    );
  }
}
