import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shop_complete/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;
  Orders(this.authToken,this.userId, this._orders);
  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-a325b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(
      Uri.parse(url),
    );
    final List<OrderItem> loadedorders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedorders.add(
        OrderItem(
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
          amount: orderData['amount'],
          datetime: DateTime.parse(orderData['datetime']),
        ),
      );
    });
    _orders = loadedorders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    final url =
        'https://flutter-shop-a325b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'products': cartproducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        products: cartproducts,
        amount: total,
        datetime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  //  Future<void> deleteOrder(String id) async {
  //   final url =
  //       'https://flutter-shop-a325b-default-rtdb.firebaseio.com/orders/$id.json?auth=$authToken';
  //   final existingOrderIndex = _orders.indexWhere((prod) => prod.id == id);
  //   OrderItem? existingOrder = _orders[existingOrderIndex];
  //   _orders.removeAt(existingOrderIndex);
  //   notifyListeners();
  //   final response = await http.delete(Uri.parse(url));
  //   if (response.statusCode >= 400) {
  //     _orders.insert(existingOrderIndex, existingOrder);
  //     notifyListeners();
  //     throw HttpException('Could not delete order.');
  //   }
  //   existingOrder = null;
  // }
}
