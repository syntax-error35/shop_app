// provider to handle list of products
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product>? _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String? authToken = "";
  String userId = "";

  Products(this.authToken,this.userId, this._items);

  List<Product> get items {
    return [..._items ?? []];
  }

  List<Product> get favorites {
    return (_items ?? []).where((productItems) => productItems.isFavorite).toList();
  }

  Product findById(String id) {
    return (_items ?? []).firstWhere((productItem) => productItem.id == id);
  }

  Future<void> addProduct(Product productItem) async {
    // converting the url string to url object
    try {
      final url = Uri.parse(
          'https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken');
      final response = await http.post(
        url,
        // headers: {
        //   'Content-Type' : 'provider'
        // },
        body: json.encode(
          {
            'title': productItem.title,
            'description': productItem.description,
            'price': productItem.price,
            'imageUrl': productItem.imageUrl,
            'userId' : userId,
            //'isFavorite': productItem.isFavorite,
          },
        ),
      );
      //.then((response) {
      // print();
      Product newProduct = Product(
          id: json.decode(response.body)['name'],
          price: productItem.price,
          imageUrl: productItem.imageUrl,
          description: productItem.description,
          title: productItem.title);
      (_items ?? []).add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    int index = (_items ?? []).indexWhere((prod) => prod.id == id);
    //  Product product = _items.where((prod) => prod.id == updatedProduct.id) as Product;
    // var id = product.id;
    //indexWhere((product) => product.id == newProduct.id);
    final url = Uri.parse(
        'https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken');
    await http.patch(
      url,
      body: json.encode({
        'title': updatedProduct.title,
        'description': updatedProduct.description,
        'price': updatedProduct.price,
        'imageUrl': updatedProduct.imageUrl,
      }),
    );
    _items![index] = updatedProduct;
    notifyListeners();
  }

  void removeProduct(String id) {
    var existingProductIndex = (_items ?? []).indexWhere((element) => element.id == id);
    Product existingProduct = (_items ?? [])[existingProductIndex];
    final url = Uri.parse(
        'https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken');
    try {
      (_items ?? []).removeWhere((product) => product.id == id);
      notifyListeners();
      http.delete(url);
    } catch (error) {
      (_items ?? [])[existingProductIndex] = existingProduct;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url); // data fetched and sent as response
      final extractedData = json.decode(response.body)  as Map<String, dynamic>; // this wrapped in .then()
      final urlFav = Uri.parse('https://shopapp-a17f6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final responseFav = await http.get(urlFav);
      final favData = json.decode(responseFav.body);
      List<Product> loadedProduct = [];
      //  print(extractedData);
      extractedData.forEach((key, value) {
        loadedProduct.add(
          Product(
            isFavorite: favData == null ? false : favData[key] ?? false,
            id: key,
            price: value['price'],
            imageUrl: value['imageUrl'],
            description: value['description'],
            title: value['title'],
          ),
        );
      },
      );
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
