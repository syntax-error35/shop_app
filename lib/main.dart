// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/authUser.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

import 'provider/order.dart';
import 'screens/product_Overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'provider/products.dart';
import 'provider/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  print('listener called');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthUser()),
        ChangeNotifierProxyProvider<AuthUser, Products>(
          update: (ctx, auth, prevProducts) => Products(auth.token, auth.userId,
              prevProducts == null ? [] : prevProducts.items),
          create: (_) => Products("", "", []),
        ),
        // Provider(create: ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<AuthUser, Order>(
            create: (_) => Order("", "", []),
            update: (ctx, auth, prevOrders) => Order(auth.token, auth.userId,
                prevOrders == null ? [] : prevOrders.orders)),

        //  Provider(create: ),

        //ChangeNotifierProvider(create: (_) => UserProductScreen())
      ],
      child: Consumer<AuthUser>(
        builder: (ctx, auth, ch) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResSnapshot) =>
                      authResSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                ProductDetailScreen(), //registering a pg to route table
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            UserProductScreen.routeName: (context) => const UserProductScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
            // AuthScreen.routeName : (context) => const ,
          },
        ),
      ),
    );
  }
}
