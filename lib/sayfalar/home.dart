import 'package:JournalFire/blocs/authentication.dart';
import 'package:JournalFire/blocs/authentication_bloc.dart';
import 'package:JournalFire/blocs/gunluk_edit_bloc.dart';
import 'package:JournalFire/blocs/gunluk_edit_bloc_provider.dart';
import 'package:JournalFire/blocs/home_bloc.dart';
import 'package:JournalFire/blocs/home_bloc_provider.dart';
import 'package:JournalFire/classes/mod_ikonlari.dart';
import 'package:JournalFire/classes/tarihFormatla.dart';
import 'package:JournalFire/model/gunluk.dart';
import 'package:JournalFire/servis/db_firestore.dart';
import 'package:flutter/material.dart';

import 'giris_duzenle.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationBloc _authenticationBloc;
  HomeBloc _homeBloc;
  String _uid;
  ModIkonlari _modIkon = ModIkonlari();
  TarihFormat _tarihFormat;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //inherited widgetlara initstate metoduyla değil didchangedependicies metodu üzerinden erişilir.
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void _gunlukEkleYadaDegistir(bool ekle, Gunluk gunluk) {
    Navigator.push(
        context,
        //metot baska bir sayfaya yönlendirme yaparak tam ekran bu sayfanın çizilmesini sağlayacak ve bu sayfanın başında bir inherited widget olacak ve kurucusunda yine bir bloc yapısı olacak
        MaterialPageRoute(
            builder: (context) => GunlukEditBlocProvider(
                  gunlukEditBloc:
                      GunlukEditBloc(ekle, gunluk, DbFirestoreService()),
                  child: GirisDuzenle(),
                ),
            fullscreenDialog: true));
  }

  Future<bool> _gunlukSilmeOnayla() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        //dialog penceresi true ya da false bir değer dönecek bunu da navigator.pop metodu ile kullanıcıya seçtiriyoruz. eğer kullanıcı sil derse doğru dönecek vazgeç derse yanlış döncek ve silme işlemi iptal edilecek.
        return AlertDialog(
          title: Text("Günlük Sil"),
          content: Text("Bu günlüğü silmek istediğinize emin misiniz?"),
          actions: [
            FlatButton(
              child: Text("Vazgeç"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Sil"),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      },
    );
  }

  Widget _listViewGoster(AsyncSnapshot snapshot) {
    //bu metot içerisine snapshot alacak ve içindeki bilgileri listview deki olması gerekn yerlere formatlayarak gösterecek
    return ListView.separated(
      itemCount: snapshot.data.lenght,
      itemBuilder: (context, index) {
        //tarih format sınıfı yardımıyla gelen string tarihi istediğimiz şekliyle gösterebilme yeteneğine sahibiz
        String _baslikTarihi =
            _tarihFormat.tarihFormatlaKisaGunAdi(snapshot.data[index].tarih);
        String _altYazilar =
            snapshot.data[index].mod + "\n" + snapshot.data[index].not;
        //dismissible widgetı sağa ya da sola kaydırmalı bir widgettır.
        return Dismissible(
          key: snapshot.data[index].documentID,
          //sağa kaydırdığında göreceğin kısmı yazdık bu bi cpntainer ve içinde de ikon var
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          //sola kaydırdığında göreceğin
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
          //normalde göreceğin kısım
          child: ListTile(
            //leading tile widgetının en baş tarafı olur snapshot içerisindeki dataları gösterir
            leading: Column(
              children: [
                Text(
                  _tarihFormat
                      .tarihFormatlaGunNumarasi(snapshot.data[index].tarih),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.lightGreen),
                ),
                Text(_tarihFormat
                    .tarihFormatlaKisaGunAdi(snapshot.data[index].tarih))
              ],
            ),
            //trailing listviewin son tarafıdır.transform widgetı kendi içindeki widgetı belli bir yönde döndürür
            trailing: Transform(
              transform: Matrix4.identity()
                ..rotateZ(
                  _modIkon.getModRotasyon(snapshot.data[index].mod),
                ),
              alignment: Alignment.center,
              child: Icon(
                _modIkon.getModIkon(snapshot.data[index].mod),
                color: _modIkon.getModRenk(snapshot.data[index].mod),
                size: 42,
              ),
            ),
            title: Text(
              _baslikTarihi,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_altYazilar),
            onTap: () {
              _gunlukEkleYadaDegistir(false, snapshot.data[index]);
            },
          ),
          //eğer sağa ya da sola çekerse önce alert çıkaracak metot çağrılacak o metotdan true dönerse ğer homebloc nesnesi içerisinde yer alan gunluksil sink widgetına bir değer ekleyerek silme işini yapacak
          confirmDismiss: (direction) async {
            bool silmeyiOnayla = await _gunlukSilmeOnayla();
            if (silmeyiOnayla) {
              _homeBloc.gunlukSil.add(snapshot.data[index]);
            }
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Gunluk', style: TextStyle(color: Colors.lightGreen.shade800)),
        elevation: 0.0,
        bottom: PreferredSize(
            child: Container(), preferredSize: Size.fromHeight(32.0)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            onPressed: () {
              //authentication bloc nesnesini yaratırken iki farklı stream kontoller yaratmıştık bunlardan biri authentication kontroller diğeri de logout controller idi şu an butona basıldığında logoutcontroller ın sink tarafı havuza bir true göndererek bütün dinleyiciler tarafından kullanıcın çıkış yaptığı bilinecek
              _authenticationBloc.logoutKullanici.add(true);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        //ana sayfamızın esas veri kaynağı user id ye göre filtrelenmiş günlüklerdir. bundan dolayı veri varsa başka yoksa başka veya veriler geliyorsa başka şekilde ekran çizilecek.
        stream: _homeBloc.gunlukListesi,
        builder: (context, snapshot) {
          //eğer bağlantı durumu bekliyorsa dönen animasyon göster
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //eğer snapshot içinde veri varsa listview yardımıyla bütün veriyi düzenli hale getirip ekranı çizeceğiz.
          else if (snapshot.hasData) {
            return _listViewGoster(snapshot);
          }
          //snapshot içerisinde herhangi bir veri yoksa tam ortada günlük ekle diye yazı göstereceğim.
          else {
            return Center(
              child: Container(
                child: Text("Günlük Ekle"),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen.shade50, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Günlük Girişi Ekle',
        backgroundColor: Colors.lightGreen.shade300,
        child: Icon(Icons.add),
        onPressed: () async {
          //bu butondan bu metoda yönlendiysek eğer demek ki yeni bir günlük ekliyoruz demektir bundan dolayı metodun ekle parametresine true olarak değer gönderiyoruz ve gunluk tipinde beklediği parametre içinde yeni bir günlük oluşturup uid değeri olarak geçerli kullanıcın id sini verip gönderiyoruz.
          _gunlukEkleYadaDegistir(true, Gunluk(uid: _uid));
        },
      ),
    );
  }
}
