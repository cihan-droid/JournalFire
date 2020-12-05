import 'gunluk_edit_bloc.dart';
import 'package:flutter/material.dart';

class GunlukEditBlocSaglayici extends InheritedWidget {
  final GunlukEditBloc gunlukEditBloc;
  const GunlukEditBlocSaglayici({Key key, Widget child, this.gunlukEditBloc})
      : super(child: child, key: key);

  static GunlukEditBlocSaglayici of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(GunlukEditBlocSaglayici old) => false;
}
