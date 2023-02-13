import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';

import '../widgets/appDrawer.dart';
import '../widgets/Product_Grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorite = false;
  var _isLoading = false ;
  var _isInit = true;
  @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    //Provider.of(context)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Overview'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavorite = true;
                } else {
                  _showFavorite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: FilterOptions.favorite, child: Text('Show Favorites')),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All products'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : ProductGrid(_showFavorite),
    );
  }
}
