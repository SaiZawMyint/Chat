import 'package:rive/rive.dart';

class RiveAsset {
  final String artboardName, stateMachineName, title, src;
  late SMIBool? input;
  late Artboard? artboard;

  RiveAsset(this.src,
      {required this.artboardName,
        required this.stateMachineName,
        required this.title,
        this.input,
      this.artboard,});

  set setInput(SMIBool status) {
    input = status;
  }
}