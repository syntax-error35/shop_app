import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }
  int get itemCount {
    return _items.length;
  }

  bool updateCartIcon(String id) {
    bool cartEmpty =true ;
    if (_items.containsKey(id)) {
      cartEmpty = false;
    }
    return cartEmpty;
  }

  void addItem(String id, double price, String title) {
    _items.update(
      id,
      (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1),
      ifAbsent: () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1),
    );
    notifyListeners();
  }

  double totalAmount() {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
void removeSingleItem(String id){
    if(!_items.containsKey(id)) return;
    if(_items[id]!.quantity > 1) {
      _items.update(id, (existingItem) =>
          CartItem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity - 1),);
    }
    else{
      removeItem(id) ;
    }
}
  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
