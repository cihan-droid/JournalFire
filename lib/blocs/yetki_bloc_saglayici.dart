import 'package:JournalFire/blocs/yetki_bloc.dart';
import 'package:flutter/material.dart';

class YetkiBlocSaglayici extends InheritedWidget {
  final YetkiBloc yetkiBloc;

  const YetkiBlocSaglayici({Key key, Widget child, this.yetkiBloc})
      : super(key: key, child: child);

  static YetkiBlocSaglayici of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(YetkiBlocSaglayici old) => yetkiBloc != old.yetkiBloc;
}
