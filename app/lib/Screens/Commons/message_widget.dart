import 'package:app/Models/Messages/message_model.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageWidget extends HookConsumerWidget {
  final bool isMe;
  final List<MessageModel> message;

  const MessageWidget(this.isMe, this.message, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMe ? _messageView(context).reversed.toList() : _messageView(context),
      ),
    );
  }

  List<Widget> _messageView(context) {
    return [
      !isMe ? CircleAvatar(
        radius: 15,
        backgroundColor: WidgetUtils.appColors.shade50,
        child:
        SvgPicture.asset("assets/icons/profile-icon.svg", width: 15),
      ):const SizedBox(),
      const SizedBox(
        width: 5,
      ),
      Column(
        children: message
            .map((e) => Container(
          constraints: BoxConstraints(
            minWidth: 30,
              maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical:10),
          decoration: BoxDecoration(
            color: isMe
                ? WidgetUtils.appColors
                : WidgetUtils.appColors.shade200,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            e.message,
            style: TextStyle(fontSize: 15, color: isMe ? Colors.white:Colors.black),
          ),
        ))
            .toList(),
      ),
      // const Icon(Icons.more_vert, color: Colors.black26,)
    ];
  }
}
