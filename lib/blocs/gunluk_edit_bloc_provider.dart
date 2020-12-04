import 'gunluk_edit_bloc.dart';
import 'package:flutter/material.dart';

class GunlukEditBlocProvider extends InheritedWidget {
  final GunlukEditBloc gunlukEditBloc;
  const GunlukEditBlocProvider({Key key, Widget child, this.gunlukEditBloc})
      : super(child: child, key: key);

  static GunlukEditBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(GunlukEditBlocProvider old) => false;
}
