import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserTile extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final Widget contentText;
  final List<Widget>? trails;
  final List<Widget>? actions;
  final bool? center;

  const UserTile({
    Key? key,
    required this.onTap,
    required this.name,
    required this.contentText,
    this.trails,
    this.actions,
    this.center
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          // color: Colors.black12,
          borderRadius: BorderRadius.circular(5)
        ),
        margin: const EdgeInsets.only(bottom: 3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: center != null && center! ? CrossAxisAlignment.center: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueGrey.shade200,
                    child: SvgPicture.asset("assets/icons/profile-icon.svg"),
                  ),
                  Positioned(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff006c3f),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                    contentText,
                    SizedBox(height: actions == null ? 0 : 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: actions==null?[const SizedBox()]:
                      actions!.map((e) => e).toList()
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Row(
                children: trails == null ? [const SizedBox()] : trails!.map((e) => e).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
