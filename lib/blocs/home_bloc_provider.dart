import 'package:JournalFire/blocs/home_bloc.dart';
import 'package:flutter/material.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;
  const HomeBlocProvider({Key key, Widget child, this.homeBloc, this.uid})
      : super(child: child, key: key);

  static HomeBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(HomeBlocProvider old) => homeBloc != old.homeBloc;
}
