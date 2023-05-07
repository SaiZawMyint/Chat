import 'package:app/Screens/Commons/navs/animated_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';

import '../../../Providers/app_provider.dart';

typedef PageChange = void Function(int index, int state);

class AppNavigationBar extends HookConsumerWidget{
  final PageChange pageChange;
  const AppNavigationBar({super.key,required this.pageChange,});
  StateMachineController _getStateMachineController(Artboard artboard, {stateMachineName = "State Machine 1"}){
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    return controller;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AppProvider.routeProvider);
    final lists = ref.watch(AppProvider.appNavigators);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(lists.length, (index) => GestureDetector(
          onTap: () async{
            pageChange(index,state);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBar(isActive: index == state),
              Builder(
                builder: (context) {
                  return SizedBox(
                    height: 36,
                    width: 36,
                    child: Opacity(
                      opacity: index == state ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        lists[index].src,
                        artboard: lists[index].artboardName,
                        onInit: (artboard) {
                          lists[index].artboard = artboard;
                          lists[index].input =
                              _getStateMachineController(artboard, stateMachineName: lists[index].stateMachineName)
                                  .findSMI("active") as SMIBool;
                        },

                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ))
      ,
    );
  }

}