import 'package:app/Screens/Friends/firends_page.dart';
import 'package:app/Screens/home/home_page.dart';
import 'package:app/Screens/users/users_page.dart';
import 'package:flutter/cupertino.dart';

class Pages{
  static final List<Widget> mainPages = [
    const HomePage(),
    const UsersPage(),
    const HomePage(),
    const HomePage(),
    const FriendsPage(),
  ];
  static final List<String> pageNames = ["Messages", "Explore", "Recent", "Notifications", "Friends"];
}