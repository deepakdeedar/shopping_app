import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create:(ctx)=>Products(),),
        ChangeNotifierProvider(
          create:(ctx)=>Cart(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName:(ctx) => ProductDetailScreen(),
          CartScreen.routeName:(ctx) => CartScreen(),
        },
      ),
    );
  }
}
