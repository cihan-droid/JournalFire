import 'package:JournalFire/blocs/gunluk_edit_bloc.dart';
import 'package:JournalFire/blocs/gunluk_edit_bloc_saglayici.dart';
import 'package:JournalFire/classes/mod_ikonlari.dart';
import 'package:JournalFire/classes/tarihFormatla.dart';
import 'package:flutter/material.dart';

class GirisDuzenle extends StatefulWidget {
  @override
  _GirisDuzenleState createState() => _GirisDuzenleState();
}

class _GirisDuzenleState extends State<GirisDuzenle> {
  GunlukEditBloc _gunlukEditBloc;
  TarihFormat _tarihFormat;
  ModIkonlari _modIkonlari;
  TextEditingController _notController;

  @override
  void initState() {
    super.initState();
    _tarihFormat = TarihFormat();
    _modIkonlari = ModIkonlari();
    _notController = TextEditingController();
    _notController.text = '';
  }

//inherited widget tarafından başlatılan değişkenler için didchangedependencies metodu kullanılır.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gunlukEditBloc = GunlukEditBlocSaglayici.of(context).gunlukEditBloc;
  }

  @override
  void dispose() {
    _notController.dispose();
    _gunlukEditBloc.dispose();
    super.dispose();
  }

  Future<String> _tarihSec(String seciliTarih) async {
    DateTime _gelenTarih = DateTime.parse(seciliTarih);

    final DateTime _secilmisTarih = await showDatePicker(
      context: context,
      initialDate: _gelenTarih,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (_secilmisTarih != null) {
      seciliTarih = DateTime(
              _secilmisTarih.year,
              _secilmisTarih.month,
              _secilmisTarih.day,
              _gelenTarih.hour,
              _gelenTarih.minute,
              _gelenTarih.second,
              _gelenTarih.millisecond,
              _gelenTarih.microsecond)
          .toString();
    }
    return seciliTarih;
  }

  void _gunluguEkleYadaGuncelle() {
    //gunlukkaydet stream de akışı dinlerken eğer kaydet görürse apiye kaydetme çağrısı yapıyordu.
    _gunlukEditBloc.gunlukKaydetDegistiSinki.add('Kaydet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giriş',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //sayfanın üstündeki tarih bölümü için streambuilder olacak
              StreamBuilder(
                stream: _gunlukEditBloc.tarihDuzenlemeAkisi,
                //eğer tarih bilgisi yoksa sadece boş container olacak ama tarih varsa flatbutton içinde tarih yazdırıp tıklama olayı ile de tarihseçme widgetı açılacak
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 22,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 16),
                        Text(
                          _tarihFormat.tarihFormatlaYilAyGun(snapshot.data),
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        )
                      ],
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String _seciliTarih = await _tarihSec(snapshot.data);
                      _gunlukEditBloc.tarihDuzenlemeDegistiSinki
                          .add(_seciliTarih);
                    },
                  );
                },
              ),
              StreamBuilder(
                stream: _gunlukEditBloc.modDuzenlemeAkisi,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _modIkonlari.getModIkonList()[_modIkonlari
                          .getModIkonList()
                          .indexWhere((ikon) => ikon.baslik == snapshot.data)],
                      onChanged: (secili) {
                        _gunlukEditBloc.modDuzenlemeDegistiSinki
                            .add(secili.baslik);
                      },
                      items: _modIkonlari
                          .getModIkonList()
                          .map((ModIkonlari secili) {
                        return DropdownMenuItem(
                          value: secili,
                          child: Row(
                            children: [
                              Transform(
                                transform: Matrix4.identity()
                                  ..rotateZ(
                                    _modIkonlari.getModRotasyon(secili.baslik),
                                  ),
                                alignment: Alignment.center,
                                child: Icon(
                                  _modIkonlari.getModIkon(secili.baslik),
                                  color: _modIkonlari.getModRenk(secili.baslik),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(secili.baslik)
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: _gunlukEditBloc.notDuzenlemeAkisi,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    Container();
                  }
                  _notController.value =
                      _notController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _notController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        labelText: 'Not', icon: Icon(Icons.subject)),
                    maxLines: null,
                    onChanged: (not) =>
                        _gunlukEditBloc.notDuzenlemeDegistiSinki.add(not),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text("Vazgeç"),
                    color: Colors.grey.shade100,
                    onPressed: () => {Navigator.pop(context)},
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FlatButton(
                    child: Text('Kaydet'),
                    color: Colors.lightGreen.shade100,
                    onPressed: () {
                      _gunluguEkleYadaGuncelle();
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
