import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _favstatus(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }



  Future<void> toggleFavouriteStatus(String token,String userId) async {
    var _oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-shop-a325b-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(isFavourite,)
      );
      if (response.statusCode >= 400) {
        _favstatus(_oldstatus);
      }
    } catch (error) {
      _favstatus(_oldstatus);
    }
  }
}
