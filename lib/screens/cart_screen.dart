import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/screens/order_screen.dart';
import '../widgets/ItemCart.dart';

import '../provider/cart.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  const Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      '\$${cart.totalAmount().toStringAsFixed(2)}',
                    ),
                  ),
                  orderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => ItemCart(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed:  widget.cart.totalAmount() <= 0  ? null : () {
          Provider.of<Order>(context, listen: false).addOrder(widget.cart.items.values.toList(),widget.cart.totalAmount());
          widget.cart.clearCart();
          Navigator.of(context).pushNamed(OrderScreen.routeName);
        },
        child: Text(
          'Order Now',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary),
        ));
  }
}
