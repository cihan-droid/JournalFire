import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && email.contains('.')) {
      sink.add(email);
    } else if (email.length > 0) {
      sink.addError('Doğru bir mail adresi giriniz');
    }
  });
  final validateSifre =
      StreamTransformer<String, String>.fromHandlers(handleData: (sifre, sink) {
    if (sifre.length >= 6) {
      sink.add(sifre);
    } else if (sifre.length > 0) {
      sink.addError('Şifre en az altı karakterden oluşmalıdır.');
    }
  });
}
