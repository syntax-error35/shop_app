import 'package:flutter/material.dart';
import 'package:shop_app/provider/authUser.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    // required this.imageUrl, required this.id, required this.title
  }) : super(key: key);
  // final String imageUrl;
  // final String id;
  // final String title;
//Product_Item(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
    bool isCartEmpty;
    //print('listener called');
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<AuthUser>(context);
    //print('widget rebuilt');
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
                builder: (ctx, item, child) => IconButton(
                    onPressed: () =>
                        item.toggleFavorite(authData.token, authData.userId),
                    icon: Icon(
                      item.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: Colors.deepOrange,
                    ))),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added item to cart!'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                    cart.updateCartIcon(product.id)
                        ? Icons.shopping_cart_outlined
                        : Icons.shopping_cart,
                    color: Colors.deepOrange)),
          ),
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id),
            child: FadeInImage(
              placeholder: AssetImage('asset/product_placeholder.png'),
              //AssetImage(),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
