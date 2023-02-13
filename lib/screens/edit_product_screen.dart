import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-products';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>(); // establishes connection to State of From Widget,
  // then _form is assigned as key to Form()
  var _editedProduct = Product(id: '', price: 0, imageUrl: '', description: '', title: '');
  var _isinit = true ;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocus.addListener(_updateListener);
    super.initState();
  }
@override
  void didChangeDependencies() {

    // TODO: implement didChangeDependencies
  if( _isinit){ // when didChangeDependencies run for the 1st time this block is executed
    var productId = ModalRoute.of(context)?.settings.arguments as String ;
    if (productId.isNotEmpty) {
      _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _isinit = false; // if block not executed again when didChangeDependencies called several times after
  }
    super.didChangeDependencies();
  }
  void _saveForm() async {

    bool? isValid =  _form.currentState?.validate();
    // if (!isValid!) return;
   if(isValid !) {
     _form.currentState!.save();
     setState(() {
       _isLoading =true;
     });
     //if(_isLoading)
     if(_editedProduct.id.isNotEmpty){
       await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id,_editedProduct);
     }
     else {
       try {
         await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
       }
       catch(error){
         showDialog<void>(context: context, builder: (ctx) =>  AlertDialog(
         title: const Text('An error occurred'),
         content: const Text('Something went wrong!'),
         actions: [
           TextButton(onPressed: () => Navigator.of(ctx).pop(), child:const Text('ok') )
         ],
       ));
       }
       // finally {
       //   Navigator.of(context).pop();
       //   setState(() {
       //     _isLoading = false;
       //   });
       // }
     }
     setState(() {
       _isLoading =false;
     });
     Navigator.of(context).pop();
   }
  }

  void _updateListener() {
    if(!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocus.removeListener(_updateListener);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: _isLoading ?  Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,),)
     : Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              initialValue: _editedProduct.title,
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocus),
              onSaved: (value) {
                _editedProduct = Product(
                  isFavorite: _editedProduct.isFavorite,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    title: value!);
              },
              validator: (value) {
                if (value!.isEmpty) return ('Please provide a title');
                return null;
              },
            ),
            TextFormField(

              initialValue: _editedProduct.price == 0 ? '' : _editedProduct.price.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceFocus,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_descriptionFocus),
              onSaved: (value) {
                _editedProduct = Product(
                    isFavorite: _editedProduct.isFavorite,
                    id: _editedProduct.id,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    title: _editedProduct.title);
              },
              validator: (value) {
                if (value!.isEmpty) return ('Please enter price');
                if (double.tryParse(value) == null) return ('Please enter valid number');
                if(double.parse(value) < 0) return ('Please enter a number greater than Zero');
                return null;
              },
            ),
            TextFormField(
              initialValue: _editedProduct.description,
              decoration: const InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              // textInputAction: TextInputAction.next,
              focusNode: _descriptionFocus,
              onSaved: (value) {
                _editedProduct = Product(
                    isFavorite: _editedProduct.isFavorite,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: value!,
                    title: _editedProduct.title);
              },
              validator: (value) {
                if (value!.isEmpty) return ('Please provide some descriptions');
                if(value.length < 10) return('Should be at least 10 characters long.');
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )),
                  child: _imageUrlController.text.isEmpty
                      ? const Text('Enter Image URL')
                      : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                   // initialValue: _initValues['imageUrl'],
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    onEditingComplete: () => setState(() {}),
                    onSaved: (value) {
                      _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          price: _editedProduct.price,
                          imageUrl: value!,
                          description: _editedProduct.description,
                          title: _editedProduct.title);
                    },
                    validator: (value) {
                      if (value!.isEmpty) return ('Please provide a URL');
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
