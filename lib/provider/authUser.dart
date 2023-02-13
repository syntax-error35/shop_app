import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/httpException.dart';

class AuthUser with ChangeNotifier {
  DateTime _expiryDate = DateTime.now();
   String _token = '';
   String _userId = '';
   Timer? _authTimer;
  bool get isAuth {
    return _token.isNotEmpty;
  }

  String get userId{
    return _userId;
}
  String get token {
    if (_token.isNotEmpty && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return '';
  }

  Future<void> authenticate(
      String email, String password, String urlSeg) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSeg?key=AIzaSyDqAYPH8_GG5zdTbZWMQaRKq3aGqLbiIrg');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'returnSecureToken': true,
            'email': email,
            'password': password,
          },
        ),
      );
      final respondedMsg = json.decode(response.body);
      if (respondedMsg['error'] != null) {
        throw HttpException(respondedMsg['error']['message']);
      }
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(respondedMsg['expiresIn']),
        ),
      );
      _token = respondedMsg['idToken'];
      _userId = respondedMsg['localId'];
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

     //
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String mail, String password) async {
    return authenticate(mail, password, 'signInWithPassword');
  }
  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false ;
    }
    final extractedData = json.decode(prefs.getString('userData')!) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    if( expiryDate.isBefore(DateTime.now())){
      return false ;
    }
_expiryDate = expiryDate;
    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    notifyListeners();
    autoLogOut();
    return true;
  }
  Future<void> logOut() async{
    _userId = '';
    _token = '';
    _expiryDate = DateTime.now();
    _authTimer?.cancel();
    _authTimer = null ;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  void autoLogOut(){
    if(_authTimer?.isActive == true){
      _authTimer?.cancel();
    }
    var timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
   // notifyListeners();
  }
}
