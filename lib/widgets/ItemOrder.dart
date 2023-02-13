import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';
import '../provider/order.dart';
import 'package:intl/intl.dart';

class ItemOrder extends StatelessWidget {
  ItemOrder(this.orderItem);
  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    // List l;
    // for (int i =0; i <orderItem.products.length; i ++){
    //   Container(child: orderItem.products[i],)
    // }
    return Card(
      child: Column(
        children: [
          ExpansionTile(
            title: Text('\$${orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat(('dd/MM/yyyy hh:mm')).format(orderItem.dateTime)),
            children: orderItem.products
                .map((prod) => Padding(
              padding: const EdgeInsets.all(8),
                  child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${prod.quantity} x \$${prod.price}',
                            style:
                                const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                ))
                .toList(),
          ),
          // trailing: IconButton(icon: const Icon(Icons.expand_more),onPressed: (){},),),
        ],
      ),
    );
  }
}
