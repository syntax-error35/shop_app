import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserItem(this.id, this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () => Provider.of<Products>(context, listen: false).removeProduct(id),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
          ),
      ],
        ),
      ),
    );
  }
}
