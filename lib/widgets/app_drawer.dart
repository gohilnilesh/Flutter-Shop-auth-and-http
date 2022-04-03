import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/order_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('D-Mart'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: const Text('Shop'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
            title: const Text('Your Orders'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
            title: const Text('Manage Products'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            title: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
