import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_complete/providers/product.dart';
import '../screens/product_detail_screen.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap: (() => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              fadeInDuration: Duration(seconds: 2),

              placeholder: const AssetImage('assets/img/prod-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  product.toggleFavouriteStatus(
                    authToken.token!,
                    authToken.userId!,
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              product.title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('item is added to cart'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.black87,
          ),
        ),
      ),
    );
  }
}
