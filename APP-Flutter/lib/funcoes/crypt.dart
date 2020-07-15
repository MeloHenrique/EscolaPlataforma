import 'dart:convert';
import 'package:crypto/crypto.dart';

Future cyptPass(String pass) async{
  var bytes = utf8.encode(pass);

  return sha256.convert(bytes).toString();
}
