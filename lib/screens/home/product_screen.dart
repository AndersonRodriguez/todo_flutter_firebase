import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/models/product.dart';
import 'package:todo_flutter_firebase/services/api_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ApiService? _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: FutureBuilder(
        future: _apiService?.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            print('Error');
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Product> products = snapshot.data!;
            return _buildListView(products);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _buildListView(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _confirmDeleteProduct(context, product);
                      },
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _confirmDeleteProduct(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alerta!!!'),
            content:
                Text('Esta seguro de eliminar este producto ${product.name}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _apiService!.deleteProduct(product.name).then((isSucces) {
                    if (isSucces) {
                      _apiService!.getProducts();
                    } else {
                      print('Error al eliminar');
                    }
                  });
                },
                child: const Text('SI'),
              ),
            ],
          );
        });
  }
}
