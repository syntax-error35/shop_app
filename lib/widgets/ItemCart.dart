import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class ItemCart extends StatelessWidget {
  ItemCart(this.id, this.prodId, this.title, this.price, this.quantity);
  final String id;
  final String prodId;
  final String title;
  final double price;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    // print('listener called');
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      onDismissed: (direction) => cart.removeItem(prodId),
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        color: Theme.of(context).errorColor,
        child: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
          margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: FittedBox(
                  child: Text('\$${price.toStringAsFixed(2)}'),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total amount \$${price * quantity}'),
              trailing: Text('$quantity x'),
            ),
          )),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              content: const Text('Are you sure you want to delete the item'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('No')),
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Yes'))
              ]),
        );
      },
    );
  }
}
