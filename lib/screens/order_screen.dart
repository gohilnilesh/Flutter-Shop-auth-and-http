
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  // var _isLoading = false;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  // void initState() {
  //   _isLoading = true;

  //   Provider.of<Orders>(context, listen: false)
  //       .fetchAndSetOrders()
  //       .then((_) {
  //       setState(() {
  //         _isLoading = false;

  //       });
  //       });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (datasnapshot.error != null) {
              return const Center(
                child: Text('An Error has Occured'),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, orderdata, child) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: orderdata.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(orderdata.orders[i],orderdata.orders[i].id,)
                        ),
                      ));
            }
          },
        ));
  }
}
