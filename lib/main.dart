import 'package:JournalFire/blocs/yetki_bloc.dart';
import 'package:JournalFire/blocs/yetki_bloc_saglayici.dart';
import 'package:JournalFire/blocs/home_bloc.dart';
import 'package:JournalFire/blocs/home_bloc_saglayici.dart';
import 'package:JournalFire/sayfalar/home.dart';
import 'package:JournalFire/sayfalar/login.dart';
import 'package:JournalFire/servis/authentication.dart';
import 'package:JournalFire/servis/db_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final YetkiBloc _authenticationBloc =
        YetkiBloc(yetkiApi: _authenticationService);
    return YetkiBlocSaglayici(
      yetkiBloc: _authenticationBloc,
      child: StreamBuilder(
        //programın başlangıcında ilk değer olarak null veriyoruz hiç bir kullanıcı daha bağlanmadı anlamında
        initialData: null,
        //authentication bloc sınıfında yazdığımız akış sağlayıcının adı kullanıcı idi. bu bize herhangi bir kullanıcının girip girmediğinin bilgisini sağlayacak
        stream: _authenticationBloc.kullaniciAkisi,
        //builder özelliği stream içerisine bakarak veri olup olmadığına göre ekranı yeniden çizer. eğer kullanıcı bilgisi akıştan geliyorsa home sayfasını gösterirken kullanıcı bilgisi yoksa login sayfasını gösterir.
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomeBlocSaglayici(
              homeBloc: HomeBloc(
                  yetkiApi: _authenticationService, dbApi: DbFirestoreServis()),
              uid: snapshot.data,
              child: _materialAppOlustur(Home()),
            );
          } else {
            return _materialAppOlustur(Login());
          }
        },
      ),
    );
  }

  MaterialApp _materialAppOlustur(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gunluk',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        bottomAppBarColor: Colors.lightGreen,
      ),
      home: homePage,
    );
  }
}
