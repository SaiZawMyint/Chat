import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Providers/app_provider.dart';
import 'Commons/navs/app_navigation_bar.dart';
import 'Commons/pages.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(AppProvider.firebaseServiceProvider);
    final pageProvider = ref.watch(AppProvider.routeProvider.notifier);
    final pageState = ref.watch(AppProvider.routeProvider);
    final title = ref.watch(AppProvider.titleProvider);
    final lists = ref.read(AppProvider.appNavigators);
    final pageController = ref.watch(AppProvider.carouselControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: const Color(0xfff11347),
        leading: IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await authService.signOut();
                AppProvider.refresh();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
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
          Positioned(
            bottom: 0,
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  padding: const EdgeInsets.all(24),
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
                          lists[index].input?.change(true);
                          if (index != state) {
                            pageProvider.changePage(index);
                            pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
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
        ],
      ),
    );
  }
}
