import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavigationBarController extends StateNotifier<NavigationBarState> {

  NavigationBarController():super(NavigationBarState(true,0));

  get isVisible => super.state.isVisible;

  get scrollPosition => super.state.scrollPosition;

  set isVisible(isVisible) => state = super.state.copyWith(isVisible: isVisible);

  set scrollPosition(scrollPosition) => state = super.state.copyWith(scrollPosition: scrollPosition);

}

class NavigationBarState {
  final bool isVisible;
  final double scrollPosition;

  NavigationBarState(this.isVisible, this.scrollPosition);

  NavigationBarState copyWith({bool? isVisible, double? scrollPosition}) {
    return NavigationBarState(
        isVisible ?? this.isVisible, scrollPosition ?? this.scrollPosition);
  }
}
