import 'dart:async';
import '../servis/authentication_api.dart';

class AuthenticationBloc {
  final AuthenticationApi authenticationApi;
  final StreamController<String> _authenticationController =
      StreamController<String>();
  Sink<String> get kullaniciEkle => _authenticationController.sink;
  Stream<String> get kullanici => _authenticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutKullanici => _logoutController.sink;
  Stream<bool> get listLogOutKullanici => _logoutController.stream;

  AuthenticationBloc({this.authenticationApi}) {
    onAuthChanged();
  }

  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }

  void onAuthChanged() {
    authenticationApi.getFirebaseAuth().onAuthStateChanged.listen((kullanici) {
      final String uid = kullanici != null ? kullanici.uid : null;
      kullaniciEkle.add(uid);
    });
    _logoutController.stream.listen((logout) {
      if (logout == true) {
        _cikisYap();
      }
    });
  }

  void _cikisYap() {
    authenticationApi.cikisYap();
  }
}
