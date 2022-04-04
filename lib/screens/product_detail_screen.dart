import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  // final String id;
  // final String title;
  // final String desc;

  //ProductDetailScreen(this.id, this.title, this.desc)

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadeditems =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadeditems.title),

      // ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadeditems.title,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              background: Hero(
                tag: loadeditems.id,
                child: Image.network(
                  loadeditems.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\$${loadeditems.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadeditems.desc,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
