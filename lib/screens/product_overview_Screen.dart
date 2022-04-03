// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favourites,
  All,
}

var _showFavouriteOnly = false;
var _isinit = true;
var _isLoading = false;

class ProductOverView extends StatefulWidget {
  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  @override
  void initState() {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProduct()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isinit = false;
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isinit) {
  //     Provider.of<Products>(context).fetchAndSetOrders();
  //   }
  //   _isinit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    //final productTable = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'Shop App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectValue) {
              setState(() {
                if (selectValue == FilterOptions.Favourites) {
                  // productTable.showFavourites();
                  _showFavouriteOnly = true;
                } else {
                  // productTable.showAll();
                  _showFavouriteOnly = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              const PopupMenuItem(
                child: Text('All Products'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavouriteOnly),
    );
  }
}
