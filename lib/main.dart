import 'package:JournalFire/blocs/authentication.dart';
import 'package:JournalFire/blocs/authentication_bloc.dart';
import 'package:JournalFire/blocs/home_bloc.dart';
import 'package:JournalFire/blocs/home_bloc_provider.dart';
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
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(authenticationApi: _authenticationService);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        //programın başlangıcında ilk değer olarak null veriyoruz hiç bir kullanıcı daha bağlanmadı anlamında
        initialData: null,
        //authentication bloc sınıfında yazdığımız akış sağlayıcının adı kullanıcı idi. bu bize herhangi bir kullanıcının girip girmediğinin bilgisini sağlayacak
        stream: _authenticationBloc.kullanici,
        //builder özelliği stream içerisine bakarak veri olup olmadığına göre ekranı yeniden çizer. eğer kullanıcı bilgisi akıştan geliyorsa home sayfasını gösterirken kullanıcı bilgisi yoksa login sayfasını gösterir.
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomeBlocProvider(
              homeBloc: HomeBloc(
                  authenticationApi: _authenticationService,
                  dbApi: DbFirestoreService()),
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
