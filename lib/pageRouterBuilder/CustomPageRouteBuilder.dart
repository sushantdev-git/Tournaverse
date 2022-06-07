import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder{
  final Widget child;
  CustomPageRoute({required this.child}) : super(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(context, animation , secondaryAnimation, child){
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0)
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
      child: child,
    );
  }
}