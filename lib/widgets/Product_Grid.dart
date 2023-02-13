import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';
import '../provider/products.dart';

class ProductGrid extends StatelessWidget {

  final showFavProduct;
  const ProductGrid(this.showFavProduct);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavProduct ? productData.favorites : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: const ProductItem(
              // imageUrl: products[i].imageUrl,
              // id: products[i].id,
              // title: products[i].title)
          )),
      itemCount: products.length,
    );
  }
}
