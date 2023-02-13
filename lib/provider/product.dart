import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;
  Product(
      {required this.id,
      required this.price,
      required this.imageUrl,
      required this.description,
      required this.title,
      this.isFavorite = false});

  void toggleFavorite( String token, String userId ) async{
    var oldValue = isFavorite ;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse('https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try{
      final response = await http.put(url, body: json.encode(
        isFavorite,
    ));
      if(response.statusCode >= 400){
        isFavorite = oldValue;
       // notifyListeners();
      }
    }
    catch(error){
      isFavorite = oldValue;
    }
    notifyListeners();
  }

}
