import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProduct extends StatelessWidget {
  final String? id;
  final String? title;
  final String? imageUrl;

  UserProduct(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title!),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
      ),
      trailing: Container(
        width: 130,
        child: Row(children: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            child: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id!);
              } catch (error) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(const SnackBar(
                  content: Text('Deleting failed!'),
                ));
              }
            },
            child: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          ),
        ]),
      ),
    );
  }
}
