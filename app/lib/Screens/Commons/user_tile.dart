import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserTile extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final String bio;
  final List<Widget>? trails;
  final List<Widget>? actions;

  const UserTile({
    Key? key,
    required this.onTap,
    required this.name,
    required this.bio,
    this.trails,
    this.actions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: onTap,
      child: Container(
        color: WidgetUtils.appColors.shade50,
        margin: const EdgeInsets.only(bottom: 3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
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
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(bio),
                    SizedBox(height: actions == null ? 0 : 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: actions==null?[const SizedBox()]:
                      actions!.map((e) => e).toList()
                    ),
                  ],
                ),
              ),
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
