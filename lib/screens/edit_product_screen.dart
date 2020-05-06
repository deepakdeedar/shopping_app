import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName='/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode=FocusNode();
  final _descriptionFocusNode=FocusNode();
  final _imageUrlController=TextEditingController();
  final _imageUrlFocusNode=FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct=Product(id: null,title: '',price: 0,description: '',imageUrl: '',);

  var _initValue={
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit=true;
  var isLoading=false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId=ModalRoute.of(context).settings.arguments as String;
      if(productId!=null)
      {
        final product = Provider.of<Products>(context,listen: false).findById(productId);
        _editedProduct=product;
        _initValue={
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text=_editedProduct.imageUrl;
      }
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {});
    }
  }

  void _saveForm(){
    final isValidate=_form.currentState.validate();
    if(!isValidate){
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading=true;
    });
    if(_editedProduct.id!=null)
      {
        Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id,_editedProduct);
        setState(() {
          isLoading=false;
        });
        Navigator.of(context).pop();
      }
    else{

      Provider.of<Products>(context,listen: false).addProduct(_editedProduct).then((_){
        Navigator.of(context).pop();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ): Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValue['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValue['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _priceFocusNode,
                validator: (value){
                  if(value.isEmpty){
                    return 'Please Enter a Price';
                  }
                  if(double.tryParse(value)==null){
                    return 'Please Enter a valid Price';
                  }
                  if(double.parse(value)<=0){
                    return 'Please Enter a valid Price';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValue['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value){
                  if(value.isEmpty){
                    return 'Please provide a description';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8,right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty? Text('Enter a URL'):
                    FittedBox(
                      child: Image.network(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return 'Please provide a value';
                        }
                        if( !value.startsWith('http') && !value.startsWith('https')){
                          return 'Please Enter a Valid URL.';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
