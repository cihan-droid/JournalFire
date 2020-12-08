import 'package:JournalFire/blocs/kimlik_dogrulama_bloc.dart';
import 'package:flutter/material.dart';

class KimlikDogrulamaBlocSaglayici extends InheritedWidget {
  final KimlikDogrulamaBloc kimlikDogrulamaBloc;

  const KimlikDogrulamaBlocSaglayici(
      {Key key, Widget child, this.kimlikDogrulamaBloc})
      : super(key: key, child: child);

  static KimlikDogrulamaBlocSaglayici of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(KimlikDogrulamaBlocSaglayici old) =>
      kimlikDogrulamaBloc != old.kimlikDogrulamaBloc;
}
