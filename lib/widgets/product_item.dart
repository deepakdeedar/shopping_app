import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  
  final String id;
  final String title;
  final String imageUrl;
  
  ProductItem(this.id,this.title,this.imageUrl);
  
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(imageUrl,fit: BoxFit.cover,),
      footer: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTileBar(
          leading: IconButton(
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
            onPressed: (){},
          ),
          backgroundColor: Colors.black87,
          title: Text(title,textAlign: TextAlign.center,),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: (){},
          ),
        ),
      ),
    );
  }
}
