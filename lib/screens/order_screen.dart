import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/appDrawer.dart';
import '../provider/order.dart';
import '../widgets/ItemOrder.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}
class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) => Provider.of<Order>(context, listen: false).fetchAndSetOrders());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderList = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders'),),
      drawer: const AppDrawer(),
      body: ListView.builder(itemBuilder: (ctx, i) =>  ItemOrder(orderList.orders[i]),
      itemCount: orderList.itemCount,),
    );
  }
}
