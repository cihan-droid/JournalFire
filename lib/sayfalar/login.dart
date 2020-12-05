import 'package:JournalFire/blocs/login_bloc.dart';
import 'package:JournalFire/servis/authentication.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(authenticationApi: AuthenticationService());
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Icon(
            Icons.account_circle,
            size: 88,
            color: Colors.white,
          ),
          preferredSize: Size.fromHeight(40.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //email text alanı için bir streambuilder oluşturduk.
              //bu streambuilder loginbloc içinde tanımladığımız email streamcontollerini kullanarak hata durumunu akıştan alır aynı zamanda text değiştikçe sink ile akışa veri pompalar
              StreamBuilder(
                stream: _loginBloc.ePostaAkisi,
                builder: (context, snapshot) => TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-Posta Adresi',
                    icon: Icon(Icons.mail_outline),
                    errorText: snapshot.error,
                  ),
                  onChanged: _loginBloc.ePostaDegistiSinki.add,
                ),
              ),
              //email alanı için yaptıklarımızın aynısını burda şifre için de uyguluyoruz
              StreamBuilder(
                stream: _loginBloc.sifreAkisi,
                builder: (context, snapshot) => TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Sifre',
                      icon: Icon(Icons.security),
                      errorText: snapshot.error),
                  onChanged: _loginBloc.sifreDegistiSinki.add,
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              //login ve hesap oluştur butonları streambuilder ile kurulacak eğer loginorCreatebutton akışında login verisi varsa login butonu yoksa hesap oluştur butonu gelecek
              _loginVeCreateButonlariOlustur(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginVeCreateButonlariOlustur() {
    return StreamBuilder(
        initialData: 'Login',
        stream: _loginBloc.loginYadaHesapOlusturButonuAkisi,
        builder: (context, snapshot) {
          if (snapshot.data == 'Login') {
            return _loginButon();
          } else {
            return _hesapOlusturButon();
          }
        });
  }

//login butonu onpressed eventinde snapshot içinde data varsa loginorcreatebutton akışına login ekler
  Column _loginButon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.loginHesapOlusturButonuAktiflemeAkisi,
          builder: (context, snapshot) => RaisedButton(
            elevation: 16.0,
            child: Text('Login'),
            color: Colors.lightGreen.shade200,
            disabledColor: Colors.grey.shade100,
            onPressed: snapshot.data
                ? () =>
                    _loginBloc.loginYadaHesapOlusturDegistiSinki.add('Login')
                : null,
          ),
        ),
        FlatButton(
          child: Text('Hesap Oluştur'),
          onPressed: () =>
              _loginBloc.loginYadaHesapOlusturDegistiSinki.add('Hesap Oluştur'),
        )
      ],
    );
  }

// eğer daha önce hiç kullanıcı girişi yapılmamışsa metod çalışır.
  Widget _hesapOlusturButon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.loginHesapOlusturButonuAktiflemeAkisi,
          builder: (context, snapshot) => RaisedButton(
            elevation: 16,
            child: Text('Hesap Oluştur'),
            color: Colors.lightGreen.shade200,
            disabledColor: Colors.grey.shade100,
            onPressed: snapshot.data
                ? () => _loginBloc.loginYadaHesapOlusturDegistiSinki
                    .add('Hesap Oluştur')
                : null,
          ),
        )
      ],
    );
  }
}
