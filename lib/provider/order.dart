import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    required this.id,
    required this.dateTime,
    required this.products,
    required this.amount,
  });
}

class Order with ChangeNotifier {
   List<OrderItem> _orders = [];
 String? authToken ;
   String? userId ;
Order(this.authToken, this.userId, this._orders);
  int get itemCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartItem, double totalAmount) async {
    final date = DateTime.now();
    final url = Uri.parse(
        'https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.post(
      url,
      body: json.encode({
        'amount': totalAmount,
        'dateTime': date.toIso8601String(),
        'products': cartItem
            .map((cart) => {
                  'id': cart.id,
                  'price': cart.price.toString(),
                  'title': cart.title,
                  'quantity': cart.quantity.toString(),
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        dateTime: DateTime.now(),
        products: cartItem,
        amount: totalAmount,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final List<OrderItem> loadedOrders = [];
    try {
      final response = await http.get(url); // data fetched and sent as response
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((orderId, orderItem) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            dateTime: DateTime.parse(orderItem['dateTime']),
            products: (orderItem['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: double.parse(item['price']) ,
                    quantity: int.parse(item['quantity']),
                  ),
                )
                .toList(),
            amount: orderItem['amount'],
          ),
        );
      });
      print(extractedData);
    } catch (error) {
      rethrow;
    }
    _orders = loadedOrders.reversed.toList() ;
    notifyListeners();
  }
}
