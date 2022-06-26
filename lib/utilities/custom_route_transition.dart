import '/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class CustomRouteBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (route.settings.name == './') {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
    if (route.settings.name == ChatScreen.routeName) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    } else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
      //return SlideTransition(position: Tween<Offset>(begin: Offset(0, animation.value), end: const Offset(0, 0)).animate(animation));
    }
  }
}
