import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageNotifier extends StateNotifier<int>{
  PageNotifier() : super(0);

  void changePage(int newValue){
    state = newValue;
  }

  int get page => state;
}