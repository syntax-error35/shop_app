import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/appDrawer.dart';
import 'package:shop_app/widgets/userItem.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-product';
  Future<void> _refreshProducts (BuildContext context) async{
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
   // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: ''),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
       future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
        const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx, productData,_ ) =>
             Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemBuilder: (ctx, i) =>
                      Column(
                        children: [
                          UserItem(
                            productData.items[i].id,
                            productData.items[i].title,
                            productData.items[i].imageUrl,
                          ),
                          const Divider(),
                        ],
                      ),
                  itemCount: productData.items.length ),
            ),
          ),
        ),
      ),
    );
  }
}
