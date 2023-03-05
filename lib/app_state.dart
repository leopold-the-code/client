import 'package:client/data/user.dart';
import 'package:flutter/material.dart';

class AppScope extends StatefulWidget {
  const AppScope({
    super.key,
    required this.child,
  });
  final Widget child;

  static _AppScopeState? of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_InheritedScope>()?.state;
    }
    final inhW = context.getElementForInheritedWidgetOfExactType<_InheritedScope>()?.widget;
    return inhW is _InheritedScope ? inhW.state : null;
  }

  @override
  State<AppScope> createState() => _AppScopeState();
}

class _AppScopeState extends State<AppScope> {
  String? token;
  User? me;

  @override
  Widget build(BuildContext context) => _InheritedScope(
        state: this,
        child: widget.child,
      );
}

class _InheritedScope extends InheritedWidget {
  _InheritedScope({
    required super.child,
    required this.state,
  });

  final _AppScopeState state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
