import 'package:JournalFire/blocs/home_bloc.dart';
import 'package:flutter/material.dart';

class HomeBlocSaglayici extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;
  const HomeBlocSaglayici({Key key, Widget child, this.homeBloc, this.uid})
      : super(child: child, key: key);

  static HomeBlocSaglayici of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(HomeBlocSaglayici old) => homeBloc != old.homeBloc;
}
